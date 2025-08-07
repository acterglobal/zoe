import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/users/providers/user_providers.dart';
import 'package:zoey/features/users/widgets/user_list_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

Future<void> assignTask(
  BuildContext context,
  WidgetRef ref,
  TaskModel task,
) async {
  final l10n = L10n.of(context);
  final theme = Theme.of(context);
  final allUsers = ref.read(usersBySheetIdProvider(task.sheetId));
  final currentAssignees = task.assignedUsers.toSet();
  final availableUsers = allUsers
      .where((user) => !currentAssignees.contains(user.id))
      .toList();
  if (availableUsers.isEmpty) {
    CommonUtils.showSnackBar(context, l10n.allUsersAreAlreadyAssignedToThisTask);
    return;
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    builder: (context) => UserListWidget(
      userIdList: userIdsFromUserModelsProvider(availableUsers),
      actionWidget: Icon(Icons.add, size: 20, color: theme.colorScheme.primary),
      onTapUser: (userId) {
        ref
            .read(taskListProvider.notifier)
            .addAssignee(context, ref, task, userId);
      },
      title: l10n.availableMembersToAssignToThisTask,
    ),
  );
}
