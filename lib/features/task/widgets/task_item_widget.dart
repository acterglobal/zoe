import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/utils/task_utils.dart';
import 'package:zoe/features/task/widgets/task_checkbox_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_stacked_avatars_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class TaskWidget extends ConsumerWidget {
  final String taskId;
  final bool isEditing;
  final bool showSheetName;

  const TaskWidget({
    super.key,
    required this.taskId,
    required this.isEditing,
    this.showSheetName = true,
  });

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
    final color = Theme.of(context).colorScheme.surface;
    return InkWell(
      onTap: () => context.push(
        AppRoutes.taskDetail.route.replaceAll(':taskId', taskId),
      ),
      borderRadius: BorderRadius.circular(8),
      splashColor: color,
      highlightColor: color,
      hoverColor: color,
      focusColor: color,
      child: Row(
        children: [
          TaskCheckboxWidget(task: task),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTaskItemTitle(context, ref, task, shouldFocus),
                    if (task.assignedUsers.isNotEmpty)
                      _buildAssignedUsersStackWidget(context, ref, task),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (showSheetName) ...[
                      DisplaySheetNameWidget(sheetId: task.sheetId),
                    ],
                    _buildTaskItemDueDate(context, ref, task),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          if (isEditing) _buildTaskItemActions(context, ref),
        ],
      ),
    );
  }

  // Builds the task item title
  Widget _buildTaskItemTitle(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
    bool shouldFocus,
  ) {
    return Flexible(
      child: ZoeInlineTextEditWidget(
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
      ),
    );
  }

  Widget _buildTaskItemDueDate(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
  ) {
    final isToday = task.dueDate.isToday;
    final isPast = task.dueDate.isBefore(DateTime.now()) && !isToday;

    return Text(
      TaskUtils.formatTaskDueDate(context, task),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: (isPast || isToday) ? AppColors.errorColor : null,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Builds assigned users view
  Widget _buildAssignedUsersStackWidget(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
  ) {
    
    final users = [
      for (final userId in task.assignedUsers) 
        ref.watch(getUserByIdProvider(userId))
    ].whereType<UserModel>().toList();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ZoeStackedAvatarsWidget(users: users),
    );
  }

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
