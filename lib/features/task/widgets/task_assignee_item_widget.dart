import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/task/widgets/task_assignee_avatar_widget.dart';
import 'package:zoey/features/users/models/user_model.dart';

class TaskAssigneeItemWidget extends ConsumerWidget {
  final UserModel user;
  final TaskModel task;

  const TaskAssigneeItemWidget({
    super.key,
    required this.user,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: ListTile(
        leading: TaskAssigneeAvatarWidget(user: user),
        title: Text(
          user.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: Icon(
          Icons.add_rounded,
          color: theme.colorScheme.primary,
          size: 16,
        ),
        onTap: () => ref
            .read(taskListProvider.notifier)
            .addAssignee(context, ref, task, user.id),
      ),
    );
  }
}
