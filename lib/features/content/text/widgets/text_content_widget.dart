import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/content/text/providers/text_content_proivder.dart';

class TextContentWidget extends ConsumerWidget {
  final String textContentId;
  final bool isEditing;
  const TextContentWidget({
    super.key,
    required this.textContentId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the text content provider
    final textContent = ref.watch(textContentProvider(textContentId));
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
              child: _buildTextContentTitle(context, ref, textContent.title),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () => ref
                    .read(sheetDetailProvider(textContent.parentId).notifier)
                    .deleteContent(textContentId),
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildTextContentDescription(
          context,
          ref,
          textContent.plainTextDescription,
          textContent.htmlDescription,
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
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'Text content title',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      onTextChanged: (value) =>
          ref.read(textContentTitleUpdateProvider).call(textContentId, value),
    );
  }

  /// Builds the text content description
  Widget _buildTextContentDescription(
    BuildContext context,
    WidgetRef ref,
    String plainTextDescription,
    String htmlDescription,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'Type something...',
      isEditing: isEditing,
      text: plainTextDescription,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) => ref
          .read(textContentDescriptionUpdateProvider)
          .call(textContentId, value, htmlDescription),
    );
  }
}
