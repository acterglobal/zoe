import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/text/providers/text_providers.dart';

class TextWidget extends ConsumerWidget {
  final String textContentId;
  const TextWidget({super.key, required this.textContentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the content edit mode provider
    final isEditing = ref.watch(isEditValueProvider);

    /// Watch the text content provider
    final textContent = ref.watch(textProvider(textContentId));
    if (textContent == null) return const SizedBox.shrink();

    /// Builds the text content widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextContentIcon(context),
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
                onTap: () => ref
                    .read(textListProvider.notifier)
                    .deleteText(textContentId),
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildTextContentDescription(
          context,
          ref,
          textContent.description?.plainText ?? '',
          textContent.description?.htmlText ?? '',
          isEditing,
        ),
      ],
    );
  }

  /// Builds the text content icon
  Widget _buildTextContentIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 6),
      child: Icon(
        Icons.text_fields,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
      hintText: 'Text content title',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      onTextChanged: (value) => ref
          .read(textListProvider.notifier)
          .updateTextTitle(textContentId, value),
    );
  }

  /// Builds the text content description
  Widget _buildTextContentDescription(
    BuildContext context,
    WidgetRef ref,
    String plainTextDescription,
    String htmlDescription,
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'Type something...',
      isEditing: isEditing,
      text: plainTextDescription,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) =>
          ref.read(textListProvider.notifier).updateTextDescription(
            textContentId,
            (plainText: value, htmlText: htmlDescription),
          ),
    );
  }
}
