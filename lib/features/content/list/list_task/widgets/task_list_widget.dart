import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/list/list_task/providers/task_list_providers.dart';
import 'package:zoey/features/content/list/list_task/widgets/task_item_widget.dart';

class TaskListWidget extends ConsumerWidget {
  final String listId;
  final bool isEditing;

  const TaskListWidget({
    super.key,
    required this.listId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskByListProvider(listId));
    if (tasks.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItemWidget(
          key: ValueKey(task.id),
          taskItemId: task.id,
          isEditing: isEditing,
        );
      },
    );
  }
}
