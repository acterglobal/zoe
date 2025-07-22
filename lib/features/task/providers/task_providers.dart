import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_notifers.dart';

final taskListProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>(
  (ref) => TaskNotifier(),
);

final taskProvider = Provider.family<TaskModel?, String>((ref, taskId) {
  final taskList = ref.watch(taskListProvider);
  return taskList.where((t) => t.id == taskId).firstOrNull;
});

// Additional provider for filtering tasks by list (needed by widgets)
final taskByListProvider = Provider.family<List<TaskModel>, String>((
  ref,
  listId,
) {
  final taskList = ref.watch(taskListProvider);
  return taskList.where((t) => t.listId == listId).toList();
});
