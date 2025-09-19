import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// List-specific actions that can be performed on list content
class ListActions {
  /// Copies list content to clipboard
  static void copyList(BuildContext context, WidgetRef ref, String listId) {
    final listContent = ShareUtils.getListContentShareMessage(
      ref: ref,
      parentId: listId,
    );
    Clipboard.setData(ClipboardData(text: listContent));
    CommonUtils.showSnackBar(context, L10n.of(context).copiedToClipboard);
  }

  /// Shares poll content using the platform share functionality
  static void shareList(BuildContext context, String listId) {
    showShareItemsBottomSheet(context: context, parentId: listId);
  }

  /// Enables edit mode for the specified list
  static void editList(WidgetRef ref, String listId) {
    ref.read(editContentIdProvider.notifier).state = listId;
  }

  /// Deletes the specified list content
  static void deleteList(BuildContext context, WidgetRef ref, String listId) {
    ref.read(listsrovider.notifier).deleteList(listId);
    CommonUtils.showSnackBar(context, L10n.of(context).listDeleted);
  }
}
