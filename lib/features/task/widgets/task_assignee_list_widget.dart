import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/widgets/task_assignee_item_widget.dart';
import 'package:zoey/features/users/models/user_model.dart';
import 'package:zoey/features/users/providers/user_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class TaskAssigneeListWidget extends ConsumerWidget {
  final TaskModel task;

  const TaskAssigneeListWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final allUsers = ref.read(userListProvider);
    final currentAssignees = task.assignedUsers.toSet();
    final availableUsers = allUsers
        .where((user) => !currentAssignees.contains(user.id))
        .toList();

    if (availableUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.allUsersAreAlreadyAssignedToThisTask)),
      );
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTaskAssigneeHeader(context, ref, availableUsers),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: availableUsers.length,
            itemBuilder: (context, index) {
              final user = availableUsers[index];
              return TaskAssigneeItemWidget(user: user, task: task);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskAssigneeHeader(
    BuildContext context,
    WidgetRef ref,
    List<UserModel> availableUsers,
  ) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.person_add_rounded,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.addAssignee,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            '${availableUsers.length} ${l10n.available}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
