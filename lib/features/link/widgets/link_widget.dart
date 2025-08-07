import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/common/widgets/emoji_picker/widgets/custom_emoji_picker_widget.dart';
import 'package:zoey/common/widgets/emoji_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/link/models/link_model.dart';
import 'package:zoey/features/link/providers/link_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class LinkWidget extends ConsumerWidget {
  final String linkId;
  final bool isEditing;

  const LinkWidget({super.key, required this.linkId, required this.isEditing});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLinkContentEmoji(context, ref, linkContent.emoji),
            Expanded(
              child: _buildLinkContentTitle(context, ref, linkContent.title),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () =>
                    ref.read(linkListProvider.notifier).deleteLink(linkId),
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildUrl(
          context,
          ref,
          linkContent.url,
          isEditing,
        ),
      ],
    );
  }

  /// Builds the link content icon
  Widget _buildLinkContentEmoji(
    BuildContext context,
    WidgetRef ref,
    String? emoji,
  ) {
    return EmojiWidget(
      isEditing: isEditing,
      emoji: emoji ?? '🔗',
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
  ) {
    return ZoeInlineTextEditWidget(
      hintText: L10n.of(context).linkTitle,
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      onTextChanged: (value) =>
          ref.read(linkListProvider.notifier).updateLinkTitle(linkId, value),
    );
  }

  /// Builds the link content url
  Widget _buildUrl(
    BuildContext context,
    WidgetRef ref,
    String url,
    bool isEditing,
  ) {
    final isValidUrl = url.isNotEmpty && CommonUtils.isValidUrl(url);
    final theme = Theme.of(context);
    final color = isValidUrl
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;
    
    return ZoeInlineTextEditWidget(
      hintText: L10n.of(context).linkUrlPlaceholder,
      isEditing: isEditing,
      text: url,
      textStyle: theme.textTheme.bodyMedium?.copyWith(
        color: color,
        decoration: isValidUrl
            ? TextDecoration.underline
            : TextDecoration.none,
      ),
      onTextChanged: (value) =>
          ref.read(linkListProvider.notifier).updateLinkUrl(linkId, value),
      onTapText: isValidUrl
          ? () async {
              try {
                final success = await CommonUtils.openUrl(url, context);
                if (!success) {
                  if (context.mounted) {
                    CommonUtils.showSnackBar(
                      context,
                      L10n.of(context).couldNotOpenLink,
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  CommonUtils.showSnackBar(
                    context,
                    L10n.of(context).couldNotOpenLink,
                  );
                }
              }
            }
          : null,
    );
  }
}
