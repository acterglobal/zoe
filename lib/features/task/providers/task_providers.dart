import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_notifers.dart';

final taskListProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>(
  (ref) => TaskNotifier(ref),
);

final taskProvider = Provider.family<TaskModel?, String>((ref, taskId) {
  final taskList = ref.watch(taskListProvider);
  return taskList.where((t) => t.id == taskId).firstOrNull;
});

// Additional provider for filtering tasks by list (needed by widgets)
final taskByParentProvider = Provider.family<List<TaskModel>, String>((
  ref,
  parentId,
) {
  final taskList = ref.watch(taskListProvider);
  final filteredTasks = taskList.where((t) => t.parentId == parentId).toList();
  filteredTasks.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  return filteredTasks;
});

// Focus management for newly added tasks
final taskFocusProvider = StateProvider<String?>((ref) => null);