import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows the text menu popup using the generic component
void showTextMenu({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEditing,
  required String textId,
  bool isDetailScreen = false,
}) {
  final menuItems = [
    ZoeCommonMenuItems.copy(
      onTapCopy: () => TextActions.copyText(context, ref, textId),
      subtitle: L10n.of(context).copyTextContent,
    ),
    ZoeCommonMenuItems.share(
      onTapShare: () => TextActions.shareText(context, ref, textId),
      subtitle: L10n.of(context).shareThisText,
    ),
    if (!isEditing)
      ZoeCommonMenuItems.edit(
        onTapEdit: () => TextActions.editText(context, ref, textId),
        subtitle: L10n.of(context).editThisText,
      ),
    ZoeCommonMenuItems.delete(
      onTapDelete: () {
        TextActions.deleteText(context, ref, textId);
        if (context.mounted && context.canPop() && isDetailScreen) {
          context.pop();
        }
      },
      subtitle: L10n.of(context).deleteThisText,
    ),
  ];

  ZoePopupMenuWidget.show(context: context, items: menuItems);
}

/// Text-specific actions that can be performed on text content
class TextActions {
  /// Copies text content to clipboard
  static void copyText(BuildContext context, WidgetRef ref, String textId) {
    final textContent = ref.read(textProvider(textId));
    if (textContent == null) return;

    final buffer = StringBuffer();

    // Add emoji and title
    if (textContent.emoji != null) {
      buffer.write('${textContent.emoji} ');
    }
    buffer.write(textContent.title);

    // Add description if available
    final description = textContent.description?.plainText;
    if (description != null && description.isNotEmpty) {
      buffer.write('\n\n$description');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    CommonUtils.showSnackBar(context, L10n.of(context).copiedToClipboard);
  }

  /// Shares text content using the platform share functionality
  static void shareText(BuildContext context, WidgetRef ref, String textId) {
    showShareItemsBottomSheet(
      context: context,
      parentId: textId,
      isSheet: false,
    );
  }

  /// Enables edit mode for the specified text
  static void editText(BuildContext context, WidgetRef ref, String textId) {
    ref.read(editContentIdProvider.notifier).state = textId;
  }

  /// Deletes the specified text content
  static void deleteText(BuildContext context, WidgetRef ref, String textId) {
    ref.read(textListProvider.notifier).deleteText(textId);
    CommonUtils.showSnackBar(context, L10n.of(context).textDeleted);
  }
}
