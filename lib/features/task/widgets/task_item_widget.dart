import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_view_with_avatar.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/utils/task_utils.dart';
import 'package:zoe/features/task/widgets/task_assignee_header_widget.dart';
import 'package:zoe/features/task/widgets/task_checkbox_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_stacked_avatars_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/users/widgets/user_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class TaskWidget extends ConsumerWidget {
  final String taskId;
  final bool isEditing;
  final bool showSheetName;
  final bool showUserName;

  const TaskWidget({
    super.key,
    required this.taskId,
    required this.isEditing,
    this.showSheetName = true,
    this.showUserName = false,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaskCheckboxWidget(task: task),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTaskItemTitle(context, ref, task, shouldFocus),
                  if (task.assignedUsers.isNotEmpty && !showUserName)
                    _buildAssignedUsersStackWidget(context, ref, task),
                ],
              ),
              const SizedBox(height: 4),
              _buildTaskItemDueDate(context, ref, task),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (showSheetName) ...[
                    DisplaySheetNameWidget(sheetId: task.sheetId),
                  ],
                ],
              ),
              if (showUserName) ...[
                const SizedBox(height: 10),
                TaskAssigneeHeaderWidget(
                  isEditing: false,
                  task: task,
                  iconSize: 12,
                  textSize: 11,
                ),
                const SizedBox(height: 4),
                _buildDisplayTaskAssigneesListWidget(context, ref, task),
                const SizedBox(height: 10),
              ],
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
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time_outlined,
          size: 10,
          color: (isPast || isToday)
              ? theme.colorScheme.error.withValues(alpha: 0.6)
              : theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 2),
        Text(
          TaskUtils.formatTaskDueDate(context, task),
          style: theme.textTheme.labelSmall?.copyWith(
            color: (isPast || isToday)
                ? theme.colorScheme.error.withValues(alpha: 0.6)
                : null,
          ),
        ),
      ],
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
        if (ref.watch(getUserByIdProvider(userId)) != null)
          ref.watch(getUserByIdProvider(userId))!,
    ];

    return GestureDetector(
      onTap: () => _buildTaskAssigneesBottomSheet(context, ref, users),
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ZoeStackedAvatarsWidget(users: users),
      ),
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

  Widget _buildDisplayTaskAssigneesListWidget(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
  ) {
    final theme = Theme.of(context);
    final users = [
      for (final userId in task.assignedUsers)
        if (ref.watch(getUserByIdProvider(userId)) != null)
          ref.watch(getUserByIdProvider(userId))!,
    ];

    if (users.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 1,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...users
            .take(2)
            .map((user) => ZoeDisplayUserNameViewWidget(user: user)),
        if (users.length > 2)
          GestureDetector(
            onTap: () => _buildTaskAssigneesBottomSheet(context, ref, users),
            child: Text(
              'view +${users.length - 2}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
      ],
    );
  }

  void _buildTaskAssigneesBottomSheet(
    BuildContext context,
    WidgetRef ref,
    List<UserModel> users,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => UserListWidget(
        userIdList: Provider((ref) => users.map((user) => user.id).toList()),
        title: L10n.of(context).assignees,
      ),
    );
  }
}
