import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/list_block_proivder.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

class ListBlockWidget extends ConsumerWidget {
  final String listBlockId;
  final bool isEditing;
  const ListBlockWidget({
    super.key,
    required this.listBlockId,
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
                Icons.list,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'List title',
                isEditing: isEditing,
                text: ref.watch(bulletsContentItemProvider(listBlockId)).title,
                textStyle: Theme.of(context).textTheme.bodyLarge,
                onTextChanged: (value) => ref
                    .read(bulletsContentUpdateProvider)
                    .call(listBlockId, title: value),
              ),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () {
                  final bulletsContent = ref.read(
                    bulletsContentItemProvider(listBlockId),
                  );
                  ref
                      .read(
                        sheetDetailProvider(bulletsContent.parentId).notifier,
                      )
                      .deleteBlock(listBlockId);
                },
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildBulletsList(context, ref),
        if (isEditing)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () {
                final currentBulletsContent = ref.read(
                  bulletsContentItemProvider(listBlockId),
                );
                final updatedBullets = [
                  ...currentBulletsContent.listItems,
                  ListItem(title: ''),
                ];
                ref
                    .read(bulletsContentUpdateProvider)
                    .call(listBlockId, listItems: updatedBullets);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Add item',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBulletsList(BuildContext context, WidgetRef ref) {
    final bulletsContent = ref.watch(bulletsContentItemProvider(listBlockId));
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bulletsContent.listItems.length,
      itemBuilder: (context, index) =>
          _buildListItem(context, ref, bulletsContent, index),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    WidgetRef ref,
    ListBlockModel listBlock,
    int index,
  ) {
    final listItem = listBlock.listItems[index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ZoeInlineTextEditWidget(
              hintText: 'List item',
              isEditing: isEditing,
              text: listItem.title,
              textStyle: Theme.of(context).textTheme.bodyMedium,
              onTextChanged: (value) => ref
                  .read(bulletsContentUpdateProvider)
                  .call(
                    listBlockId,
                    listItems: [
                      ...listBlock.listItems.map(
                        (listItem) => listItem.id == listItem.id
                            ? listItem.copyWith(title: value)
                            : listItem,
                      ),
                    ],
                  ),
            ),
          ),
          const SizedBox(width: 6),
          if (isEditing) ...[
            GestureDetector(
              onTap: () => context.push(
                AppRoutes.listBlockDetail.route.replaceAll(
                  ':listBlockId',
                  listItem.id,
                ),
              ),
              child: Icon(
                Icons.edit,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(width: 6),
            ZoeCloseButtonWidget(
              onTap: () {
                final updatedItems = listBlock.listItems
                    .where((item) => item.id != listItem.id)
                    .toList();
                ref
                    .read(bulletsContentUpdateProvider)
                    .call(listBlockId, listItems: updatedItems);
              },
            ),
          ],
        ],
      ),
    );
  }
}
