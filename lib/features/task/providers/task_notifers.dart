import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/core/preference_service/preferences_service.dart';
import 'package:zoey/features/task/data/tasks.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super(tasks);

  void addTask(String title, String parentId, String sheetId) async {
    final createdBy = await PreferencesService().getLoginUserId();
    final newTask = TaskModel(
      parentId: parentId,
      title: title,
      sheetId: sheetId,
      dueDate: DateTime.now(),
      isCompleted: false,
      createdBy: createdBy,
      assignedUsers: [],
    );
    state = [...state, newTask];
  }

  void deleteTask(String taskId) {
    state = state.where((t) => t.id != taskId).toList();
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
        if (task.id == taskId) task.copyWith(assignedUsers: assignedUsers) else task,
    ];
  }
}
