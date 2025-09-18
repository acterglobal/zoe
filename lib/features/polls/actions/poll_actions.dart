import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

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
  static void sharePoll(BuildContext context, String pollId) {
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
