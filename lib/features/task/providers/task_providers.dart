import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/date_time_utils.dart';
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
final taskByParentProvider = Provider.family<List<TaskModel>, String>((
  ref,
  parentId,
) {
  final taskList = ref.watch(taskListProvider);
  return taskList.where((t) => t.parentId == parentId).toList();
});

final listOfUsersByTaskIdProvider = Provider.family<List<String>, String>((ref, taskId) {
  final taskList = ref.watch(taskListProvider);
  return taskList.where((t) => t.id == taskId).firstOrNull?.assignedUsers ?? [];
});

final todaysTasksProvider = Provider<List<TaskModel>>((ref) {
  final allTasks = ref.watch(taskListProvider);
  final todayTasks = allTasks.where((task) => task.dueDate.isToday).toList();
  todayTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return todayTasks;
});
