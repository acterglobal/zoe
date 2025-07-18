import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/bullet-lists/models/bullets_content_model.dart';
import 'package:zoey/features/bullet-lists/providers/bullets_content_item_proivder.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

class BulletsContentWidget extends ConsumerWidget {
  final String bulletsContentId;
  final bool isEditing;
  const BulletsContentWidget({
    super.key,
    required this.bulletsContentId,
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
              child: Icon(Icons.list, size: 16),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'List title',
                isEditing: isEditing,
                controller: ref.watch(
                  bulletsContentTitleControllerProvider(bulletsContentId),
                ),
                textStyle: Theme.of(context).textTheme.titleMedium,
                onTextChanged: (value) => ref
                    .read(bulletsContentUpdateProvider)
                    .call(bulletsContentId, title: value),
              ),
            ),
            if (isEditing) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  final bulletsContent = ref.read(
                    bulletsContentItemProvider(bulletsContentId),
                  );
                  ref
                      .read(
                        sheetDetailProvider(bulletsContent.parentId).notifier,
                      )
                      .deleteContent(bulletsContentId);
                },
                child: const Icon(Icons.delete_outlined, size: 16),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        _buildBulletsList(context, ref),
      ],
    );
  }

  Widget _buildBulletsList(BuildContext context, WidgetRef ref) {
    final bulletsContent = ref.watch(
      bulletsContentItemProvider(bulletsContentId),
    );
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bulletsContent.bullets.length,
      itemBuilder: (context, index) =>
          _buildBulletItem(context, ref, bulletsContent, index),
    );
  }

  Widget _buildBulletItem(
    BuildContext context,
    WidgetRef ref,
    BulletsContentModel bulletsContent,
    int index,
  ) {
    final controllerKey = '$bulletsContentId-$index';
    final titleController = ref.watch(
      bulletsContentBulletControllerProvider(controllerKey),
    );
    return Row(
      children: [
        Icon(Icons.circle, size: 8),
        const SizedBox(width: 6),
        Expanded(
          child: ZoeInlineTextEditWidget(
            hintText: 'List item',
            isEditing: isEditing,
            controller: titleController,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            onTextChanged: (value) => ref
                .read(bulletsContentUpdateProvider)
                .call(
                  bulletsContentId,
                  bullets: [
                    ...bulletsContent.bullets.asMap().entries.map(
                      (entry) => entry.key == index ? value : entry.value,
                    ),
                  ],
                ),
          ),
        ),
        if (isEditing) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              final updatedItems = [...bulletsContent.bullets];
              updatedItems.removeAt(index);
              ref
                  .read(bulletsContentUpdateProvider)
                  .call(bulletsContentId, bullets: updatedItems);
            },
            child: const Icon(Icons.close, size: 16),
          ),
        ],
      ],
    );
  }
}
