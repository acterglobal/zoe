import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/list/list_todos/data/tasks.dart';
import 'package:zoey/features/content/list/list_todos/models/task_model.dart';

class TaskListNotifier extends StateNotifier<List<TaskModel>> {
  TaskListNotifier() : super(tasks);

  // Update the title of a task item
  void updateTask(String id, {String? title, bool? isCompleted}) {
    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(title: title, isCompleted: isCompleted);
      }
      return task;
    }).toList();
  }

  // Delete a task item
  void deleteTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }

  // Add a task item
  String addTask(String title, String listId) {
    final newTask = TaskModel(title: title, listId: listId);
    state = [...state, newTask];
    return newTask.id;
  }
}
