import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/task/data/tasks.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super(tasks);

  void addTask(String title, String listId, String sheetId) {
    final newTask = TaskModel(listId: listId, title: title, sheetId: sheetId);
    state = [...state, newTask];
  }

  void deleteTask(String taskId) {
    state = state.where((t) => t.id != taskId).toList();
  }

  void updateTask(
    String taskId, {
    String? title,
    Description? description,
    bool? isCompleted,
    DateTime? dueDate,
    String? listId,
  }) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(
            title: title,
            description: description,
            isCompleted: isCompleted,
            dueDate: dueDate,
            listId: listId,
          )
        else
          task,
    ];
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
}
