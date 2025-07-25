import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/task/widgets/task_item_widget.dart';

class TaskListWidget extends ConsumerWidget {
  final String parentId;
  final bool isEditing;

  const TaskListWidget({
    super.key,
    required this.parentId,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskByParentProvider(parentId));
    if (tasks.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TaskWidget(
            key: ValueKey(task.id),
            taskId: task.id,
            isEditing: isEditing,
          ),
        return GestureDetector(
          onTap: () => context.push(
            AppRoutes.taskDetail.route.replaceAll(':taskId', task.id),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: TaskWidget(key: ValueKey(task.id), taskId: task.id),
          ),
        );
      },
    );
  }
}
