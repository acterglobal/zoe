import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/text/providers/text_block_proivder.dart';

class TextBlockWidget extends ConsumerWidget {
  final String textBlockId;
  final bool isEditing;
  const TextBlockWidget({
    super.key,
    required this.textBlockId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the text block provider
    final textBlock = ref.watch(textBlockProvider(textBlockId));
    if (textBlock == null) return const SizedBox.shrink();

    /// Builds the text block widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextBlockIcon(context),
            Expanded(
              child: _buildTextBlockTitle(context, ref, textBlock.title),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () => ref
                    .read(sheetDetailProvider(textBlock.parentId).notifier)
                    .deleteBlock(textBlockId),
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildTextBlockDescription(context, ref, textBlock.description),
      ],
    );
  }

  /// Builds the text block icon
  Widget _buildTextBlockIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 6),
      child: Icon(
        Icons.text_fields,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  /// Builds the text block title
  Widget _buildTextBlockTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'Text block title',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      onTextChanged: (value) =>
          ref.read(textBlockTitleUpdateProvider).call(textBlockId, value),
    );
  }

  /// Builds the text block description
  Widget _buildTextBlockDescription(
    BuildContext context,
    WidgetRef ref,
    String description,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'Type something...',
      isEditing: isEditing,
      text: description,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) =>
          ref.read(textBlockDescriptionUpdateProvider).call(textBlockId, value),
    );
  }
}
