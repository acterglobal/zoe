import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/models/user_chip_type.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_chip_widget.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_assignee_header_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

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
        TaskAssigneeHeaderWidget(isEditing: isEditing, task: task),
        const SizedBox(height: 12),
        _buildAssigneesList(context, ref),
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

    return ZoeUserChipWidget(
      user: user,
      onRemove: isEditing ? () => ref
          .read(taskListProvider.notifier)
          .removeAssignee(ref, task, userId) : null,
          type: ZoeUserChipType.userNameWithAvatarChip,
    );
  }
}
