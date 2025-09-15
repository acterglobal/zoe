import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/actions/common_actions.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/utils/content_utils.dart';
import 'package:zoe/common/widgets/option_button_widget.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void showLongTapBottomSheet(
  BuildContext context, {
  String? contentId,
  String? sheetId,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => LongTapBottomSheetWidget(
      contentId: contentId,
      sheetId: sheetId,
    ),
  );
}

class LongTapBottomSheetWidget extends ConsumerWidget {
  final String? contentId;
  final String? sheetId;
  final bool isDetailScreen;

  const LongTapBottomSheetWidget({
    super.key,
    this.contentId,
    this.sheetId,
    this.isDetailScreen = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    // Determine if we're working with content or sheet
    if (contentId != null) {
      return _buildContentBottomSheet(context, ref, theme, l10n);
    } else if (sheetId != null) {
      return _buildSheetBottomSheet(context, ref, theme, l10n);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildContentBottomSheet(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    L10n l10n,
  ) {
    // Get content from provider
    final content = ref.watch(contentProvider(contentId!));
    if (content == null) return const SizedBox.shrink();

    return _buildBottomSheetContent(
      context,
      theme,
      l10n,
      title: ContentUtils.getContentTypeDisplayTitle(
        context: context,
        type: content.type,
        content: content,
      ),
      subtitle: content.title.isNotEmpty ? content.title : l10n.untitled,
      editIcon: ContentUtils.getContentTypeIcon(
        context: context,
        type: content.type,
        content: content,
      ),
      editTitle: ContentUtils.getEditContentTitle(
        context: context,
        type: content.type,
        content: content,
      ),
      onEdit: () {
        Navigator.of(context).pop();
        editContentAction(ref: ref, contentId: content.id);
      },
      onCopy: () {
        Navigator.of(context).pop();
        _handleCopyTitle(context, content.title, l10n);
      },
      onDelete: () {
        Navigator.of(context).pop();
        deleteContentAction(context: context, ref: ref, contentId: content.id);
      },
    );
  }

  Widget _buildSheetBottomSheet(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    L10n l10n,
  ) {
    // Get sheet from provider
    final sheet = ref.watch(sheetProvider(sheetId!));
    if (sheet == null) return const SizedBox.shrink();

    return _buildBottomSheetContent(
      context,
      theme,
      l10n,
      title: l10n.sheet,
      subtitle: sheet.title.isNotEmpty ? sheet.title : l10n.untitled,
      editIcon: Icons.edit_rounded,
      editTitle: l10n.editSheet,
      onEdit: () {
        Navigator.of(context).pop();
        editSheetAction(ref: ref, sheetId: sheet.id);
      },
      onCopy: () {
        Navigator.of(context).pop();
        _handleCopyTitle(context, sheet.title, l10n);
      },
      onDelete: () {
        Navigator.of(context).pop();
        deleteSheetAction(context: context, ref: ref, sheetId: sheet.id);
      },
    );
  }

  Widget _buildBottomSheetContent(
    BuildContext context,
    ThemeData theme,
    L10n l10n, {
    required String title,
    required String subtitle,
    required IconData editIcon,
    required String editTitle,
    required VoidCallback onEdit,
    required VoidCallback onCopy,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 32),

          // Edit
          OptionButtonWidget(
            icon: editIcon,
            title: editTitle,
            subtitle: sheetId != null
                ? l10n.editSheetSubtitle
                : l10n.editContentSubtitle,
            color: theme.colorScheme.primary,
            onTap: onEdit,
          ),
          const SizedBox(height: 16),

          // Copy Title
          OptionButtonWidget(
            icon: Icons.copy_rounded,
            title: l10n.copyTitle,
            subtitle: l10n.copyTitleSubtitle,
            color: theme.colorScheme.secondary,
            onTap: onCopy,
          ),
          const SizedBox(height: 16),

          // Delete
          OptionButtonWidget(
            icon: Icons.delete_rounded,
            title: sheetId != null
                ? l10n.deleteSheetButton
                : l10n.deleteContent,
            subtitle: sheetId != null
                ? l10n.deleteSheetSubtitle
                : l10n.deleteContentSubtitle,
            color: theme.colorScheme.error,
            onTap: onDelete,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Handle copy title action - copy to clipboard and show feedback
  void _handleCopyTitle(BuildContext context, String title, L10n l10n) {
    if (title.isEmpty) return;
    Clipboard.setData(ClipboardData(text: title));
    CommonUtils.showSnackBar(context, l10n.copyTitleToClipboard);
  }
}
