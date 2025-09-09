import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/emoji_picker/widgets/custom_emoji_picker_widget.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class TextWidget extends ConsumerWidget {
  final String textId;

  const TextWidget({super.key, required this.textId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the text content provider
    final textContent = ref.watch(textProvider(textId));
    if (textContent == null) return const SizedBox.shrink();

    /// Builds the text content widget
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _buildTextContent(context, ref, textContent),
    );
  }

  Widget _buildTextContent(
    BuildContext context,
    WidgetRef ref,
    TextModel textContent,
  ) {
    final editContentId = ref.watch(editContentIdProvider);
    final isEditing = editContentId == textId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextContentEmoji(context, ref, textContent.emoji, isEditing),
            Expanded(
              child: _buildTextContentTitle(context, ref, textContent.title, isEditing),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () =>
                    ref.read(textListProvider.notifier).deleteText(textId),
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildTextContentDescription(
          context,
          ref,
          textContent.description?.plainText ?? '',
          textContent.description?.htmlText ?? '',
          textContent.description,
          isEditing,
        ),
      ],
    );
  }

  /// Builds the text content icon
  Widget _buildTextContentEmoji(
    BuildContext context,
    WidgetRef ref,
    String? emoji,
    bool isEditing,
  ) {
    return EmojiWidget(
      isEditing: isEditing,
      emoji: emoji ?? '𝑻',
      onTap: (currentEmoji) => showCustomEmojiPicker(
        context,
        ref,
        onEmojiSelected: (emoji) {
          ref.read(textListProvider.notifier).updateTextEmoji(textId, emoji);
        },
      ),
    );
  }

  /// Builds the text content title
  Widget _buildTextContentTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: L10n.of(context).textContentTitle,
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      onTextChanged: (value) =>
          ref.read(textListProvider.notifier).updateTextTitle(textId, value),
      onTapText: () => context.push(
        AppRoutes.textBlockDetails.route.replaceAll(':textBlockId', textId),
      ),
    );
  }

  /// Builds the text content description
  Widget _buildTextContentDescription(
    BuildContext context,
    WidgetRef ref,
    String plainTextDescription,
    String htmlDescription,
    Description? description,
    bool isEditing,
  ) {
    return ZoeHtmlTextEditWidget(
      hintText: L10n.of(context).typeSomething,
      isEditing: isEditing,
      description: description,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      editorId: 'text-content-$textId', // Add unique editor ID
      onContentChanged: (description) => ref
          .read(textListProvider.notifier)
          .updateTextDescription(textId, description),
      onTap: () => context.push(
        AppRoutes.textBlockDetails.route.replaceAll(':textBlockId', textId),
      ),
    );
  }
}
