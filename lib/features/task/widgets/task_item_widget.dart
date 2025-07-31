import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/utils/date_time_utils.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/task/widgets/task_checkbox_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class TaskWidget extends ConsumerWidget {
  final String taskId;
  final bool isEditing;

  const TaskWidget({super.key, required this.taskId, required this.isEditing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskProvider(taskId));
    final focusedTaskId = ref.watch(taskFocusProvider);
    final shouldFocus = focusedTaskId == taskId;
    if (task == null) return const SizedBox.shrink();

    return _buildTaskItemContent(context, ref, task, shouldFocus);
  }

  Widget _buildTaskItemContent(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
    bool shouldFocus,
  ) {
    return Row(
      children: [
        TaskCheckboxWidget(task: task),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskItemTitle(context, ref, task, shouldFocus),
              const SizedBox(height: 4),
              _buildTaskItemDueDate(context, ref, task.dueDate),
            ],
          ),
        ),
        const SizedBox(width: 6),
        if (isEditing) _buildTaskItemActions(context, ref),
      ],
    );
  }

  // Builds the task item title
  Widget _buildTaskItemTitle(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
    bool shouldFocus,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: L10n.of(context).taskItem,
      text: task.title,
      isEditing: isEditing,
      autoFocus: shouldFocus,
      textInputAction: TextInputAction.next,
      textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        decoration: task.isCompleted
            ? TextDecoration.lineThrough
            : TextDecoration.none,
      ),
      onTextChanged: (value) {
        ref.read(taskListProvider.notifier).updateTaskTitle(taskId, value);
      },
      onEnterPressed: () => ref
          .read(taskListProvider.notifier)
          .addTask(
            parentId: task.parentId,
            sheetId: task.sheetId,
            orderIndex: task.orderIndex + 1,
          ),
      onBackspaceEmptyText: () =>
          ref.read(taskListProvider.notifier).deleteTask(taskId),
      onTapText: () => context.push(
        AppRoutes.taskDetail.route.replaceAll(':taskId', taskId),
      ),
    );
  }

  Widget _buildTaskItemDueDate(
    BuildContext context,
    WidgetRef ref,
    DateTime? dueDate,
  ) {
    if (dueDate == null) return const SizedBox.shrink();

    return Text(
      'Due: ${DateTimeUtils.formatDate(dueDate)}',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  // Builds the task item actions
  Widget _buildTaskItemActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Edit list item
        GestureDetector(
          onTap: () => context.push(
            AppRoutes.taskDetail.route.replaceAll(':taskId', taskId),
          ),
          child: Icon(
            Icons.edit,
            size: 16,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(width: 6),

        // Delete list item
        ZoeCloseButtonWidget(
          onTap: () {
            ref.read(taskListProvider.notifier).deleteTask(taskId);
          },
        ),
      ],
    );
  }
}
