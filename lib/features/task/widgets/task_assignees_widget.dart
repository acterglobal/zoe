import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/task/widgets/task_assignee_avatar_widget.dart';
import 'package:zoey/features/task/widgets/task_assignee_list_widget.dart';  
import 'package:zoey/features/users/providers/user_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class TaskAssigneesWidget extends ConsumerWidget {
  final TaskModel task;
  final bool isEditing;

  const TaskAssigneesWidget({
    super.key,
    required this.task,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAssigneeHeader(context, ref),
        const SizedBox(height: 12),
        _buildAssigneesList(context, ref),
      ],
    );
  }

  Widget _buildAssigneeHeader(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.people_rounded, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          L10n.of(context).assignees,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        if (isEditing)
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => TaskAssigneeListWidget(task: task),
              );
            },
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
      ],
    );
  }

  Widget _buildAssigneesList(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    if (task.assignedUsers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 8),
            Text(
              L10n.of(context).noAssigneesYet,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: task.assignedUsers.map((userId) {
        return _buildAssigneeChip(context, ref, userId);
      }).toList(),
    );
  }

  Widget _buildAssigneeChip(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) {
    final user = ref.watch(getUserByIdProvider(userId));
    if (user == null) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TaskAssigneeAvatarWidget(user: user),
          const SizedBox(width: 8),
          Text(
            user.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontSize: 12,
            ),
          ),
          if (isEditing) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _removeAssignee(ref, userId),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _removeAssignee(WidgetRef ref, String userId) {
    final updatedAssignees = List<String>.from(task.assignedUsers)
      ..remove(userId);

    ref
        .read(taskListProvider.notifier)
        .updateTaskAssignees(task.id, updatedAssignees);
  }
}
