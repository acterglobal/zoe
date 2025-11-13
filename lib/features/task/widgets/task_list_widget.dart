import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class TaskListWidget extends ConsumerWidget {
  final ProviderListenable<List<TaskModel>> tasksProvider;
  final bool isEditing;
  final int? maxItems;
  final bool shrinkWrap;
  final bool showCardView;
  final Widget emptyState;
  final bool showSectionHeader;

  const TaskListWidget({
    super.key,
    required this.tasksProvider,
    required this.isEditing,
    this.maxItems,
    this.shrinkWrap = true,
    this.showCardView = true,
    this.emptyState = const SizedBox.shrink(),
    this.showSectionHeader = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    if (tasks.isEmpty) {
      return emptyState;
    }

    if (showSectionHeader) {
      return Column(
        children: [
          _buildSectionHeader(context),
          const SizedBox(height: 16),
          _buildTaskList(context, ref, tasks),
        ],
      );
    }

    return _buildTaskList(context, ref, tasks);
  }

  Widget _buildTaskList(
    BuildContext context,
    WidgetRef ref,
    List<TaskModel> tasks,
  ) {
    final itemCount = maxItems != null
        ? min(maxItems!, tasks.length)
        : tasks.length;

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: itemCount,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return GestureDetector(
          onTap: () => context.push(
            AppRoutes.taskDetail.route.replaceAll(':taskId', task.id),
          ),
          child: showCardView
              ? Card(
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

  Widget _buildSectionHeader(BuildContext context) {
    return QuickSearchTabSectionHeaderWidget(
      title: L10n.of(context).tasks,
      icon: Icons.task_alt_rounded,
      onTap: () => context.push(AppRoutes.tasksList.route),
      color: AppColors.successColor,
    );
  }
}
