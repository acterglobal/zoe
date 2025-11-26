import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/choose_color_bottom_sheet.dart';
import 'package:zoe/common/widgets/media_selection_bottom_sheet.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/sheet/actions/delete_sheet.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows the sheet menu popup using the generic component
void showSheetMenu({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEditing,
  required String sheetId,
}) {
  final menuItems = [
    ZoeCommonMenuItems.connect(
      onTapConnect: () => SheetActions.connectSheet(context, sheetId),
      subtitle: L10n.of(context).connectWithWhatsAppGroup,
    ),
    ZoeCommonMenuItems.chooseTheme(
      onTapChooseTheme: () => SheetActions.chooseTheme(context, ref, sheetId),
      subtitle: L10n.of(context).chooseTheme,
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

  /// Adds or Updates the cover image for the specified sheet content
  static Future<void> addOrUpdateCoverImage(
    BuildContext context,
    WidgetRef ref,
    String sheetId,
    bool hasCoverImage,
  ) async {
    final l10n = L10n.of(context);
    XFile? selectedImage;
    await showMediaSelectionBottomSheet(
      context,
      title: l10n.selectSheetCoverImage,
      subtitle: l10n.chooseAMediaFile,
      onTapCamera: (image) => selectedImage = image,
      onTapGallery: (images) => selectedImage = images.first,
      onTapRemoveImage: hasCoverImage
          ? () => SheetActions.removeCoverImage(context, ref, sheetId)
          : null,
    );
    if (selectedImage != null && context.mounted) {
      ref
          .read(sheetListProvider.notifier)
          .updateSheetCoverImage(sheetId, selectedImage!.path);
    }
  }

  /// Removes the cover image for the specified sheet content
  static void removeCoverImage(
    BuildContext context,
    WidgetRef ref,
    String sheetId,
  ) {
    final theme = Theme.of(context);
    final sheetListNotifier = ref.read(sheetListProvider.notifier);
    sheetListNotifier.updateSheetCoverImage(sheetId, null);
    sheetListNotifier.updateSheetTheme(
      sheetId: sheetId,
      primary: theme.colorScheme.primary,
      secondary: theme.colorScheme.secondary,
    );
    Navigator.of(context).pop();
  }

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

  /// Chooses theme for the specified sheet content
  static void chooseTheme(BuildContext context, WidgetRef ref, String sheetId) {
    ChooseColorBottomSheet.show(context, sheetId: sheetId);
  }
}
