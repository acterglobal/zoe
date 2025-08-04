import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/users/models/user_model.dart';
import 'package:zoey/features/users/providers/user_providers.dart';
import 'package:zoey/features/users/widgets/user_list_widget.dart';
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
    final l10n = L10n.of(context);
    final allUsers = ref.read(userListProvider);
    final currentAssignees = task.assignedUsers.toSet();
    final availableUsers = allUsers
        .where((user) => !currentAssignees.contains(user.id))
        .toList();
    return Row(
      children: [
        Icon(Icons.people_rounded, size: 20),
        const SizedBox(width: 8),
        Text(
          l10n.assignees,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        if (isEditing)
          IconButton(
            onPressed: () {
              if (availableUsers.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    content: Text(
                      l10n.allUsersAreAlreadyAssignedToThisTask,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                );
                return;
              }
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: theme.colorScheme.surface,
                builder: (context) => UserListWidget(
                  userIdList: userIdsFromUserModelsProvider(availableUsers),
                  addUserActionWidget: Icon(
                    Icons.add,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  onUserSelected: (userId) {
                    ref
                        .read(taskListProvider.notifier)
                        .addAssignee(context, ref, task, userId);
                  },
                  title: l10n.availableMembersToAssignToThisTask,
                ),
              );
            },
            icon: Icon(
              Icons.add_circle_outline_rounded,
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
    final randomColor = CommonUtils().getRandomColorFromName(user.name);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: randomColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: randomColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAssigneeAvatar(context, user, randomColor),
          const SizedBox(width: 8),
          Text(
            user.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: randomColor,
              fontSize: 12,
            ),
          ),
          if (isEditing) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => ref
                  .read(taskListProvider.notifier)
                  .removeAssignee(ref, task, userId),
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

  Widget _buildAssigneeAvatar(BuildContext context, UserModel user, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
