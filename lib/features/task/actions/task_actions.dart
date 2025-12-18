import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows the task menu popup using the generic component
void showTaskMenu({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEditing,
  required String taskId,
  bool isDetailScreen = false,
}) {
  final currentUserId = ref.read(currentUserProvider)?.id;
  final createdBy = ref.read(taskProvider(taskId))?.createdBy;
  final isOwner = currentUserId == createdBy;

  final menuItems = [
    ZoeCommonMenuItems.copy(
      onTapCopy: () => TaskActions.copyTask(context, ref, taskId),
      subtitle: L10n.of(context).copyTaskContent,
    ),
    ZoeCommonMenuItems.share(
      onTapShare: () => TaskActions.shareTask(context, ref, taskId),
      subtitle: L10n.of(context).shareThisTask,
    ),
    if (!isEditing && isOwner)
      ZoeCommonMenuItems.edit(
        onTapEdit: () => TaskActions.editTask(ref, taskId),
        subtitle: L10n.of(context).editThisTask,
      ),
    if (isOwner)
      ZoeCommonMenuItems.delete(
        onTapDelete: () {
          TaskActions.deleteTask(context, ref, taskId);
          if (context.mounted && context.canPop() && isDetailScreen) {
            context.pop();
          }
        },
        subtitle: L10n.of(context).deleteThisTask,
      ),
  ];

  ZoePopupMenuWidget.show(context: context, items: menuItems);
}

/// Task-specific actions that can be performed on task content
class TaskActions {
  /// Copies task content to clipboard
  static void copyTask(BuildContext context, WidgetRef ref, String taskId) {
    final taskContent = ShareUtils.getTaskContentShareMessage(
      ref: ref,
      parentId: taskId,
    );
    Clipboard.setData(ClipboardData(text: taskContent));
    CommonUtils.showSnackBar(context, L10n.of(context).copiedToClipboard);
  }

  /// Shares task content using the platform share functionality
  static void shareTask(BuildContext context, WidgetRef ref, String taskId) {
    final taskContent = ref.read(taskProvider(taskId));
    if (taskContent == null) return;
    if (taskContent.title.isEmpty) {
      CommonUtils.showSnackBar(context, L10n.of(context).pleaseAddTaskTitle);
      return;
    }
    showShareItemsBottomSheet(context: context, parentId: taskId);
  }

  /// Enables edit mode for the specified task
  static void editTask(WidgetRef ref, String taskId) {
    ref.read(editContentIdProvider.notifier).state = taskId;
  }

  /// Deletes the specified task content
  static void deleteTask(BuildContext context, WidgetRef ref, String taskId) {
    ref.read(taskListProvider.notifier).deleteTask(taskId);
    CommonUtils.showSnackBar(context, L10n.of(context).taskDeleted);
  }
}
