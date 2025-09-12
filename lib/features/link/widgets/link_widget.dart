import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/common/widgets/emoji_picker/widgets/custom_emoji_picker_widget.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';

import 'package:zoe/l10n/generated/l10n.dart';

class LinkWidget extends ConsumerWidget {
  final String linkId;
  final bool showSheetName;

  const LinkWidget({
    super.key,
    required this.linkId,
    this.showSheetName = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the link content provider
    final linkContent = ref.watch(linkProvider(linkId));
    if (linkContent == null) return const SizedBox.shrink();

    /// Builds the link content widget
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _buildLinkContent(context, ref, linkContent),
    );
  }

  Widget _buildLinkContent(
    BuildContext context,
    WidgetRef ref,
    LinkModel linkContent,
  ) {
    final editContentId = ref.watch(editContentIdProvider);
    final isEditing = editContentId == linkId;

    return Row(
      children: [
        _buildLinkContentEmoji(context, ref, linkContent.emoji, isEditing),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildLinkContentTitle(
                      context,
                      ref,
                      linkContent.title,
                      isEditing,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isEditing)
                    ZoeDeleteButtonWidget(
                      onTap: () {
                        ref.read(linkListProvider.notifier).deleteLink(linkId);
                        ref.read(editContentIdProvider.notifier).state = null;
                      },
                    ),
                ],
              ),
              const SizedBox(height: 6),
              _buildUrl(context, ref, linkContent.url, isEditing),
              const SizedBox(height: 6),
              if (showSheetName) ...[
                DisplaySheetNameWidget(sheetId: linkContent.sheetId),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the link content icon
  Widget _buildLinkContentEmoji(
    BuildContext context,
    WidgetRef ref,
    String? emoji,
    bool isEditing,
  ) {
    return EmojiWidget(
      isEditing: isEditing,
      emoji: emoji ?? '🔗',
      size: 20,
      onTap: (currentEmoji) => showCustomEmojiPicker(
        context,
        ref,
        onEmojiSelected: (emoji) {
          ref.read(linkListProvider.notifier).updateLinkEmoji(linkId, emoji);
        },
      ),
    );
  }

  /// Builds the link content title
  Widget _buildLinkContentTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: L10n.of(context).linkTitle,
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      onTextChanged: (value) =>
          ref.read(linkListProvider.notifier).updateLinkTitle(linkId, value),
      onLongTapText: () =>
          ref.read(editContentIdProvider.notifier).state = linkId,
    );
  }

  /// Builds the link content url
  Widget _buildUrl(
    BuildContext context,
    WidgetRef ref,
    String url,
    bool isEditing,
  ) {
    final theme = Theme.of(context);
    final color = url.isNotEmpty && CommonUtils.isValidUrl(url)
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    return ZoeInlineTextEditWidget(
      hintText: L10n.of(context).linkUrlPlaceholder,
      isEditing: isEditing,
      text: url,
      textStyle: theme.textTheme.bodySmall?.copyWith(
        color: color,
        decoration: TextDecoration.none,
      ),
      onTextChanged: (value) =>
          ref.read(linkListProvider.notifier).updateLinkUrl(linkId, value),
      onTapText: () => CommonUtils.openUrl(url, context),
    );
  }
}
