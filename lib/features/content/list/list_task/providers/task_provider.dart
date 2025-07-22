import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/list/list_todos/models/task_model.dart';
import 'package:zoey/features/content/list/list_todos/providers/task_list_providers.dart';

final taskItemProvider = Provider.family<TaskModel?, String>((
  ref,
  String taskItemId,
) {
  final taskList = ref.watch(taskListProvider);
  try {
    return taskList.firstWhere((task) => task.id == taskItemId);
  } catch (e) {
    return null;
  }
});

final taskItemIsCompletedUpdateProvider = Provider<void Function(String, bool)>(
  (ref) {
    return (String taskItemId, bool isCompleted) {
      ref
          .read(taskListProvider.notifier)
          .updateTask(taskItemId, isCompleted: isCompleted);
    };
  },
);

final taskItemTitleUpdateProvider = Provider<void Function(String, String)>((
  ref,
) {
  return (String taskItemId, String title) {
    ref.read(taskListProvider.notifier).updateTask(taskItemId, title: title);
  };
});

final taskItemDeleteProvider = Provider<void Function(String)>((ref) {
  return (String taskItemId) {
    ref.read(taskListProvider.notifier).deleteTask(taskItemId);
  };
});
