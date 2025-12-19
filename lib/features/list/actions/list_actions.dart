import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows the list menu popup using the generic component
void showListMenu({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEditing,
  required String listId,
  bool isDetailScreen = false,
}) {
  final currentUserId = ref.read(currentUserProvider)?.id;
  final createdBy = ref.read(listItemProvider(listId))?.createdBy;
  final isOwner = currentUserId != null && currentUserId == createdBy;

  final menuItems = [
    ZoeCommonMenuItems.copy(
      context: context,
      onTapCopy: () => ListActions.copyList(context, ref, listId),
      subtitle: L10n.of(context).copyListContent,
    ),
    ZoeCommonMenuItems.share(
      context: context,
      onTapShare: () => ListActions.shareList(context, ref, listId),
      subtitle: L10n.of(context).shareThisList,
    ),
    if (!isEditing && isOwner)
      ZoeCommonMenuItems.edit(
        context: context,
        onTapEdit: () => ListActions.editList(ref, listId),
        subtitle: L10n.of(context).editThisList,
      ),
    if (isOwner)
      ZoeCommonMenuItems.delete(
        context: context,
        onTapDelete: () {
          ListActions.deleteList(context, ref, listId);
          if (context.mounted && context.canPop() && isDetailScreen) {
            context.pop();
          }
        },
        subtitle: L10n.of(context).deleteThisList,
      ),
  ];

  ZoePopupMenuWidget.show(context: context, items: menuItems);
}

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
  static void shareList(BuildContext context, WidgetRef ref, String listId) {
    final listContent = ref.read(listItemProvider(listId));
    if (listContent == null) return;
    if (listContent.title.isEmpty) {
      CommonUtils.showSnackBar(context, L10n.of(context).pleaseAddListTitle);
      return;
    }
    showShareItemsBottomSheet(context: context, parentId: listId);
  }

  /// Enables edit mode for the specified list
  static void editList(WidgetRef ref, String listId) {
    ref.read(editContentIdProvider.notifier).state = listId;
  }

  /// Deletes the specified list content
  static void deleteList(BuildContext context, WidgetRef ref, String listId) {
    ref.read(listsProvider.notifier).deleteList(listId);
    CommonUtils.showSnackBar(context, L10n.of(context).listDeleted);
  }
}
