import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_notifers.dart';

class MockTaskNotifier extends TaskNotifier {
  MockTaskNotifier(super.ref);

  void setTasks(List<TaskModel> tasks) {
    state = tasks;
  }
  

  void updateTask(TaskModel task) {
    state = [
      for (final t in state)
        if (t.id == task.id) task else t,
    ];
  }

  void removeTask(String taskId) {
    state = state.where((t) => t.id != taskId).toList();
  }

  @override
  void toggleTaskCompletion(String taskId) {
    state = [
      for (final t in state)
        if (t.id == taskId) t.copyWith(isCompleted: !t.isCompleted) else t,
    ];
  }
}

final mockTaskListProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) => MockTaskNotifier(ref));

final mockTodaysTasksProvider = Provider<List<TaskModel>>((ref) {
  final allTasks = ref.watch(mockTaskListProvider);
  final now = DateTime.now();
  return allTasks
      .where((t) => 
          t.dueDate.year == now.year &&
          t.dueDate.month == now.month &&
          t.dueDate.day == now.day)
      .toList();
});

final mockUpcomingTasksProvider = Provider<List<TaskModel>>((ref) {
  final allTasks = ref.watch(mockTaskListProvider);
  final now = DateTime.now();
  return allTasks
      .where((t) => t.dueDate.isAfter(now))
      .toList();
});

final mockPastDueTasksProvider = Provider<List<TaskModel>>((ref) {
  final allTasks = ref.watch(mockTaskListProvider);
  final now = DateTime.now();
  return allTasks
      .where((t) => 
          t.dueDate.isBefore(now) &&
          !t.isCompleted)
      .toList();
});
