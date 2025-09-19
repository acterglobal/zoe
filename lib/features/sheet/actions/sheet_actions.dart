import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/sheet/actions/delete_sheet.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows the sheet menu popup using the generic component
void showSheetMenu({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEditing,
  required String sheetId,
}) {
  final menuItems = [
    ZoeCommonMenuItems.copy(
      onTapCopy: () => SheetActions.copySheet(context, ref, sheetId),
      subtitle: L10n.of(context).copySheetContent,
    ),
    ZoeCommonMenuItems.share(
      onTapShare: () => SheetActions.shareSheet(context, sheetId),
      subtitle: L10n.of(context).shareThisSheet,
    ),
    if (!isEditing)
      ZoeCommonMenuItems.edit(
        onTapEdit: () => SheetActions.editSheet(ref, sheetId),
        subtitle: L10n.of(context).editThisSheet,
      ),
    ZoeCommonMenuItems.delete(
      onTapDelete: () => SheetActions.deleteSheet(context, ref, sheetId),
      subtitle: L10n.of(context).deleteThisSheet,
    ),
  ];

  ZoePopupMenuWidget.show(context: context, items: menuItems);
}

/// Sheet-specific actions that can be performed on sheet content
class SheetActions {
  /// Copies sheet content to clipboard
  static void copySheet(BuildContext context, WidgetRef ref, String sheetId) {
    final sheetContent = ShareUtils.getSheetShareMessage(
      ref: ref,
      parentId: sheetId,
    );
    Clipboard.setData(ClipboardData(text: sheetContent));
    CommonUtils.showSnackBar(context, L10n.of(context).copiedToClipboard);
  }

  /// Shares sheet content using the platform share functionality
  static void shareSheet(BuildContext context, String sheetId) {
    showShareItemsBottomSheet(
      context: context,
      parentId: sheetId,
      isSheet: true,
    );
  }

  /// Enables edit mode for the specified sheet
  static void editSheet(WidgetRef ref, String sheetId) {
    ref.read(editContentIdProvider.notifier).state = sheetId;
  }

  /// Deletes the specified sheet content
  static void deleteSheet(BuildContext context, WidgetRef ref, String sheetId) {
    showDeleteSheetConfirmation(context, ref, sheetId);
  }
}
