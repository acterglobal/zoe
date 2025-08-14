import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/common/providers/common_providers.dart';
import 'package:Zoe/common/utils/date_time_utils.dart';
import 'package:Zoe/features/task/models/task_model.dart';
import 'package:Zoe/features/task/providers/task_notifers.dart';

final taskListProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>(
  (ref) => TaskNotifier(ref),
);

final todaysTasksProvider = Provider<List<TaskModel>>((ref) {
  final allTasks = ref.watch(taskListProvider);
  final todayTasks = allTasks.where((task) => task.dueDate.isToday).toList();
  todayTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return todayTasks;
});

final upcomingTasksProvider = Provider<List<TaskModel>>((ref) {
  final allTasks = ref.watch(taskListProvider);
  final upcomingTasks = allTasks.where((task) {
    return task.dueDate.isAfter(DateTime.now()) && !task.dueDate.isToday;
  }).toList();
  upcomingTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  return upcomingTasks;
});

final pastDueTasksProvider = Provider<List<TaskModel>>((ref) {
  final allTasks = ref.watch(taskListProvider);
  final pastDueTasks = allTasks.where((task) {
    return task.dueDate.isBefore(DateTime.now()) && !task.dueDate.isToday;
  }).toList();
  pastDueTasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
  return pastDueTasks;
});

final allTasksProvider = Provider<List<TaskModel>>((ref) {
  final todayTasks = ref.watch(todaysTasksProvider);
  final upcomingTasks = ref.watch(upcomingTasksProvider);
  final pastDueTasks = ref.watch(pastDueTasksProvider);
  return [...todayTasks, ...upcomingTasks, ...pastDueTasks];
});

final taskListSearchProvider = Provider<List<TaskModel>>((ref) {
  final searchValue = ref.watch(searchValueProvider);
  final allTasks = ref.watch(allTasksProvider);
  if (searchValue.isEmpty) return allTasks;
  return allTasks.where((task) {
    return task.title.toLowerCase().contains(searchValue.toLowerCase());
  }).toList();
});

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

final listOfUsersByTaskIdProvider = Provider.family<List<String>, String>((
  ref,
  taskId,
) {
  final taskList = ref.watch(taskListProvider);
  return taskList.where((t) => t.id == taskId).firstOrNull?.assignedUsers ?? [];
});

// Focus management for newly added tasks
final taskFocusProvider = StateProvider<String?>((ref) => null);