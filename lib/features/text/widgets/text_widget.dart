import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/common/widgets/emoji_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/text/models/text_model.dart';
import 'package:zoey/features/text/providers/text_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class TextWidget extends ConsumerWidget {
  final String textId;
  const TextWidget({super.key, required this.textId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the content edit mode provider
    final isEditing = ref.watch(isEditValueProvider);

    /// Watch the text content provider
    final textContent = ref.watch(textProvider(textId));
    if (textContent == null) return const SizedBox.shrink();

    /// Builds the text content widget
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _buildTextContent(context, ref, textContent, isEditing),
    );
  }

  Widget _buildTextContent(
    BuildContext context,
    WidgetRef ref,
    TextModel textContent,
    bool isEditing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextContentEmoji(context, ref, textContent.emoji),
            Expanded(
              child: _buildTextContentTitle(
                context,
                ref,
                textContent.title,
                isEditing,
              ),
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
  ) {
    return EmojiWidget(
      emoji: emoji ?? '𝑻',
      onTap: (currentEmoji) => ref
          .read(textListProvider.notifier)
          .updateTextEmoji(textId, CommonUtils.getNextEmoji(currentEmoji)),
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
      textStyle: Theme.of(context).textTheme.bodyLarge,
      onTextChanged: (value) =>
          ref.read(textListProvider.notifier).updateTextTitle(textId, value),
    );
  }

  /// Builds the text content description
  Widget _buildTextContentDescription(
    BuildContext context,
    WidgetRef ref,
    Description? description,
    bool isEditing,
  ) {
    return ZoeHtmlTextEditWidget(
      hintText: L10n.of(context).typeSomething,
      isEditing: isEditing,
      description: description,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      editorId: 'text-content-$textId', // Add unique editor ID
      onContentChanged: (description) =>
          ref.read(textListProvider.notifier).updateTextDescription(textId, description),
    );
  }
}
