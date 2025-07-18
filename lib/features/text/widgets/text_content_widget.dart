import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/text/providers/text_content_item_proivder.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(
                Icons.text_fields,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'Text content title',
                isEditing: isEditing,
                controller: ref.watch(
                  textContentTitleControllerProvider(textContentId),
                ),
                textStyle: Theme.of(context).textTheme.bodyLarge,
                onTextChanged: (value) => ref
                    .read(textContentUpdateProvider)
                    .call(textContentId, 'title', value),
              ),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () {
                  final textContent = ref.read(
                    textContentItemProvider(textContentId),
                  );
                  ref
                      .read(sheetDetailProvider(textContent.parentId).notifier)
                      .deleteContent(textContentId);
                },
              ),
          ],
        ),
        const SizedBox(height: 6),
        ZoeInlineTextEditWidget(
          hintText: 'Type something...',
          isEditing: isEditing,
          controller: ref.watch(
            textContentDataControllerProvider(textContentId),
          ),
          textStyle: Theme.of(context).textTheme.bodyMedium,
          onTextChanged: (value) => ref
              .read(textContentUpdateProvider)
              .call(textContentId, 'data', value),
        ),
      ],
    );
  }
}
