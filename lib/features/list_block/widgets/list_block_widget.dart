import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/list_block_proivder.dart';
import 'package:zoey/features/list_block/providers/list_item_list_providers.dart';
import 'package:zoey/features/list_block/widgets/list_item_widget.dart';
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
    final listBlock = ref.watch(listBlockProvider(listBlockId));
    if (listBlock == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildListBlockIcon(context),
            Expanded(
              child: _buildListBlockTitle(context, ref, listBlock.title),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () {
                  final listBlock = ref.read(listBlockProvider(listBlockId));
                  if (listBlock != null) {
                    ref
                        .read(sheetDetailProvider(listBlock.parentId).notifier)
                        .deleteBlock(listBlockId);
                  }
                },
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildListBlockItemList(context, ref),
        if (isEditing) _buildAddListItemButton(context, ref),
      ],
    );
  }

  // Builds the list block icon
  Widget _buildListBlockIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 6),
      child: Icon(
        Icons.list,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  // Builds the list block title
  Widget _buildListBlockTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'List title',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      onTextChanged: (value) =>
          ref.read(listBlockTitleUpdateProvider).call(listBlockId, value),
    );
  }

  Widget _buildListBlockItemList(BuildContext context, WidgetRef ref) {
    final listItems = ref.watch(listItemListProvider(listBlockId));
    if (listItems.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listItems.length,
      itemBuilder: (context, index) =>
          ListItemWidget(listItemId: listItems[index].id, isEditing: isEditing),
    );
  }

  // Builds the add list item button
  Widget _buildAddListItemButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: () {
          final currentListBlock = ref.read(listBlockProvider(listBlockId));
          if (currentListBlock != null) {
            final updatedBullets = [
              ...currentListBlock.listItems,
              ListItem(title: ''),
            ];
            ref
                .read(listBlockListUpdateProvider)
                .call(listBlockId, updatedBullets);
          }
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
    );
  }
}
