import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';

class TaskListWidget extends ConsumerWidget {
  final ProviderBase<List<TaskModel>> tasksProvider;
  final bool isEditing;
  final int? maxItems;
  final bool shrinkWrap;
  final bool showCardView;
  final Widget emptyState;

  const TaskListWidget({
    super.key,
    required this.tasksProvider,
    required this.isEditing,
    this.maxItems,
    this.shrinkWrap = true,
    this.showCardView = true,
    this.emptyState = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    if (tasks.isEmpty) {
      return emptyState;
    }

    final itemCount = maxItems != null
        ? min(maxItems!, tasks.length)
        : tasks.length;

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      padding: const EdgeInsets.symmetric(vertical: 10),
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return GestureDetector(
          onTap: () => context.push(
            AppRoutes.taskDetail.route.replaceAll(':taskId', task.id),
          ),
          child: showCardView
              ? Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    child: TaskWidget(
                      key: Key(task.id),
                      taskId: task.id,
                      isEditing: isEditing,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: TaskWidget(
                    key: ValueKey(task.id),
                    taskId: task.id,
                    isEditing: isEditing,
                    showSheetName: false,
                  ),
                ),
        );
      },
    );
  }
}
