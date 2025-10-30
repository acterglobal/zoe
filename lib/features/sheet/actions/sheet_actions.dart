import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/document_selection_bottom_sheet.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/sheet/actions/delete_sheet.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows the sheet menu popup using the generic component
void showSheetMenu({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEditing,
  bool hasCoverImage = false,
  required String sheetId,
}) {
  final menuItems = [
    ZoeCommonMenuItems.connect(
      onTapConnect: () => SheetActions.connectSheet(context, sheetId),
      subtitle: L10n.of(context).connectWithWhatsAppGroup,
    ),
    if (hasCoverImage) ...[
      ZoeCommonMenuItems.updateCoverImage(
        onTapUpdateCoverImage: () =>
            SheetActions.updateCoverImage(context, ref, sheetId),
        subtitle: L10n.of(context).updateCoverImage,
      ),
      ZoeCommonMenuItems.removeCoverImage(
        onTapRemoveCoverImage: () =>
            SheetActions.removeCoverImage(context, ref, sheetId),
        subtitle: L10n.of(context).removeCoverImage,
      ),
    ] else
      ZoeCommonMenuItems.addCoverImage(
        onTapAddCoverImage: () =>
            SheetActions.addCoverImage(context, ref, sheetId),
        subtitle: L10n.of(context).addCoverImage,
      ),
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
  /// Connects to the specified sheet content
  static void connectSheet(BuildContext context, String sheetId) {
    context.push(
      AppRoutes.whatsappGroupConnect.route.replaceAll(':sheetId', sheetId),
    );
  }

  /// Adds the cover image for the specified sheet content
  static void addCoverImage(
    BuildContext context,
    WidgetRef ref,
    String sheetId,
  ) {
    showFileSelectionBottomSheet(
      context,
      onTapCamera: () => {},
      onTapGallery: () => {},
      onTapFileChooser: () => {},
    );
  }

  /// Updates the cover image for the specified sheet content
  static void updateCoverImage(
    BuildContext context,
    WidgetRef ref,
    String sheetId,
  ) {}

  /// Removes the cover image for the specified sheet content
  static void removeCoverImage(
    BuildContext context,
    WidgetRef ref,
    String sheetId,
  ) {}

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
