import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows the poll menu popup using the generic component
void showPollMenu({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEditing,
  required String pollId,
  bool isDetailScreen = false,
}) {
  final currentUserId = ref.read(currentUserProvider)?.id;
  final createdBy = ref.read(pollProvider(pollId))?.createdBy;
  final isOwner = currentUserId == createdBy;

  final menuItems = [
    ZoeCommonMenuItems.copy(
      onTapCopy: () => PollActions.copyPoll(context, ref, pollId),
      subtitle: L10n.of(context).copyPollContent,
    ),
    ZoeCommonMenuItems.share(
      onTapShare: () => PollActions.sharePoll(context, ref, pollId),
      subtitle: L10n.of(context).shareThisPoll,
    ),
    if (!isEditing && isOwner)
      ZoeCommonMenuItems.edit(
        onTapEdit: () => PollActions.editPoll(ref, pollId),
        subtitle: L10n.of(context).editThisPoll,
      ),
    if (isOwner)
      ZoeCommonMenuItems.delete(
        onTapDelete: () {
          PollActions.deletePoll(context, ref, pollId);
          if (context.mounted && context.canPop() && isDetailScreen) {
            context.pop();
          }
        },
        subtitle: L10n.of(context).deleteThisPoll,
      ),
  ];

  ZoePopupMenuWidget.show(context: context, items: menuItems);
}

/// Poll-specific actions that can be performed on poll content
class PollActions {
  /// Copies text content to clipboard
  static void copyPoll(BuildContext context, WidgetRef ref, String pollId) {
    final pollContent = ShareUtils.getPollContentShareMessage(
      ref: ref,
      parentId: pollId,
    );
    Clipboard.setData(ClipboardData(text: pollContent));
    CommonUtils.showSnackBar(context, L10n.of(context).copiedToClipboard);
  }

  /// Shares poll content using the platform share functionality
  static void sharePoll(BuildContext context, WidgetRef ref, String pollId) {
    final pollContent = ref.read(pollProvider(pollId));
    if (pollContent == null) return;
    if (pollContent.title.isEmpty) {
      CommonUtils.showSnackBar(context, L10n.of(context).pleaseAddPollTitle);
      return;
    }
    showShareItemsBottomSheet(context: context, parentId: pollId);
  }

  /// Enables edit mode for the specified poll
  static void editPoll(WidgetRef ref, String pollId) {
    ref.read(editContentIdProvider.notifier).state = pollId;
  }

  /// Deletes the specified poll content
  static void deletePoll(BuildContext context, WidgetRef ref, String pollId) {
    ref.read(pollListProvider.notifier).deletePoll(pollId);
    CommonUtils.showSnackBar(context, L10n.of(context).pollDeleted);
  }
}
