import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';
import 'package:zoe/features/task/data/tasks.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  Ref ref;
  TaskNotifier(this.ref) : super(tasks);

  Future<void> addTask({
    String title = '',
    required String parentId,
    required String sheetId,
    int? orderIndex,
  }) async {
    // Single pass optimization: collect parent tasks and determine new orderIndex
    int newOrderIndex;
    Map<String, TaskModel> tasksToUpdate = {};

    if (orderIndex == null) {
      // Find max orderIndex for this parent in a single pass
      int maxOrderIndex = -1;
      for (final task in state) {
        if (task.parentId == parentId && task.orderIndex > maxOrderIndex) {
          maxOrderIndex = task.orderIndex;
        }
      }
      newOrderIndex = maxOrderIndex + 1;
    } else {
      // Collect tasks that need orderIndex updates in a single pass
      newOrderIndex = orderIndex;
      for (final task in state) {
        if (task.parentId == parentId && task.orderIndex >= orderIndex) {
          tasksToUpdate[task.id] = task.copyWith(
            orderIndex: task.orderIndex + 1,
          );
        }
      }
    }

    final createdBy = await PreferencesService().getLoginUserId();

    // Create the new task
    final newTask = TaskModel(
      parentId: parentId,
      title: title,
      sheetId: sheetId,
      orderIndex: newOrderIndex,
      dueDate: DateTime.now(),
      isCompleted: false,
      createdBy: createdBy,
      assignedUsers: [],
    );

    // Update state efficiently
    if (orderIndex == null) {
      // Simple append - no need to update existing tasks
      state = [...state, newTask];
    } else {
      // Replace existing tasks with updated ones and add new task
      final updatedState = <TaskModel>[];

      // Single pass to build new state with O(1) lookup
      for (final task in state) {
        final updatedTask = tasksToUpdate[task.id];
        updatedState.add(updatedTask ?? task);
      }
      updatedState.add(newTask);
      state = updatedState;
      ref.read(taskFocusProvider.notifier).state = newTask.id;
    }
  }

  void deleteTask(String taskId) {
    // Get the focus task id (previous or next)
    final focusTaskId = getFocusTaskId(taskId);
    // Remove the task from the state
    state = state.where((t) => t.id != taskId).toList();
    // Set the focus to the focus task
    ref.read(taskFocusProvider.notifier).state = focusTaskId;
  }

  void toggleTaskCompletion(String taskId) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(isCompleted: !task.isCompleted)
        else
          task,
    ];
  }

  void updateTaskTitle(String taskId, String title) {
    state = [
      for (final task in state)
        if (task.id == taskId) task.copyWith(title: title) else task,
    ];
  }

  void updateTaskDescription(String taskId, Description description) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(description: description)
        else
          task,
    ];
  }

  void updateTaskCompletion(String taskId, bool isCompleted) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(isCompleted: isCompleted)
        else
          task,
    ];
  }

  void updateTaskDueDate(String taskId, DateTime? dueDate) {
    state = [
      for (final task in state)
        if (task.id == taskId) task.copyWith(dueDate: dueDate) else task,
    ];
  }

  void updateTaskOrderIndex(String taskId, int orderIndex) {
    state = [
      for (final task in state)
        if (task.id == taskId) task.copyWith(orderIndex: orderIndex) else task,
    ];
  }

  void updateTaskAssignees(String taskId, List<String> assignedUsers) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(assignedUsers: assignedUsers)
        else
          task,
    ];
  }

  void addAssignee(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
    String userId,
  ) {
    final updatedAssignees = List<String>.from(task.assignedUsers)..add(userId);

    ref
        .read(taskListProvider.notifier)
        .updateTaskAssignees(task.id, updatedAssignees);
  }

  void removeAssignee(WidgetRef ref, TaskModel task, String userId) {
    final updatedAssignees = List<String>.from(task.assignedUsers)
      ..remove(userId);

    ref
        .read(taskListProvider.notifier)
        .updateTaskAssignees(task.id, updatedAssignees);
  }

  String? getFocusTaskId(String taskId) {
    try {
      // Get the task for the parent from current state
      final task = state.where((t) => t.id == taskId).firstOrNull;
      if (task == null) return null;
      final parentId = task.parentId;

      // Get the parent task list from current state
      final parentTasks = state.where((t) => t.parentId == parentId).toList()
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      // Get the current task index
      final currentTaskIndex = parentTasks.indexOf(task);

      // If the current task is the first task, try to return the next task
      if (currentTaskIndex <= 0) {
        // Check if there's a next task available
        if (currentTaskIndex < parentTasks.length - 1) {
          // Return the next task id
          return parentTasks[currentTaskIndex + 1].id;
        }
        return null;
      }

      // Return the previous task id
      return parentTasks[currentTaskIndex - 1].id;
    } catch (e) {
      return null;
    }
  }
}
