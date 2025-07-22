import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/list/list_todos/models/task_model.dart';
import 'package:zoey/features/content/list/list_todos/providers/notifiers/task_list_notifier.dart';

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<TaskModel>>((ref) {
      return TaskListNotifier();
    });

final taskByListProvider = Provider.family<List<TaskModel>, String>((
  ref,
  String listId,
) {
  final taskList = ref.watch(taskListProvider);
  return taskList.where((task) => task.listId == listId).toList();
});
