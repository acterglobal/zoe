import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows the link menu popup using the generic component
void showLinkMenu({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEditing,
  required String linkId,
}) {
  final menuItems = [
    ZoeCommonMenuItems.copy(
      onTapCopy: () => LinkActions.copyLink(context, ref, linkId),
      subtitle: L10n.of(context).copyLinkContent,
    ),
    if (!isEditing)
      ZoeCommonMenuItems.edit(
        onTapEdit: () => LinkActions.editLink(ref, linkId),
        subtitle: L10n.of(context).editThisLink,
      ),
    ZoeCommonMenuItems.delete(
      onTapDelete: () => LinkActions.deleteLink(context, ref, linkId),
      subtitle: L10n.of(context).deleteThisLink,
    ),
  ];

  ZoePopupMenuWidget.show(context: context, items: menuItems);
}

/// Link-specific actions that can be performed on link content
class LinkActions {
  /// Copies link content to clipboard
  static void copyLink(BuildContext context, WidgetRef ref, String linkId) {
    final linkContent = ref.read(linkProvider(linkId));
    if (linkContent == null) return;

    final buffer = StringBuffer();

    // Add emoji and title
    if (linkContent.emoji != null) {
      buffer.write('${linkContent.emoji} ');
    }
    // Add title
    buffer.write(linkContent.title);
    // Add url
    if (linkContent.url.isNotEmpty) {
      buffer.write('\n\n${linkContent.url}');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    CommonUtils.showSnackBar(context, L10n.of(context).copiedToClipboard);
  }

  /// Enables edit mode for the specified link
  static void editLink(WidgetRef ref, String linkId) {
    ref.read(editContentIdProvider.notifier).state = linkId;
  }

  /// Deletes the specified text content
  static void deleteLink(BuildContext context, WidgetRef ref, String linkId) {
    ref.read(linkListProvider.notifier).deleteLink(linkId);
    CommonUtils.showSnackBar(context, L10n.of(context).linkDeleted);
  }
}
