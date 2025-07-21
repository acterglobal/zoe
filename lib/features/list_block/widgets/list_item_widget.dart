import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/list_block/models/list_block_model.dart';
import 'package:zoey/features/list_block/providers/list_block_proivder.dart';

class ListItemWidget extends ConsumerWidget {
  final String listBlockId;
  final ListItem listItem;
  final bool isEditing;

  const ListItemWidget({
    super.key,
    required this.listBlockId,
    required this.listItem,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildListItemIcon(context),
          const SizedBox(width: 10),
          Expanded(child: _buildListItemTitle(context, ref)),
          const SizedBox(width: 6),
          if (isEditing) _buildListItemActions(context, ref),
        ],
      ),
    );
  }

  // Builds the list item icon
  Widget _buildListItemIcon(BuildContext context) {
    return Icon(
      Icons.circle,
      size: 8,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }

  // Builds the list item title
  Widget _buildListItemTitle(BuildContext context, WidgetRef ref) {
    final listBlock = ref.watch(listBlockProvider(listBlockId));
    if (listBlock == null) return const SizedBox.shrink();

    return ZoeInlineTextEditWidget(
      hintText: 'List item',
      isEditing: isEditing,
      text: listItem.title,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) =>
          ref.read(listBlockListUpdateProvider).call(listBlockId, [
            ...listBlock.listItems.map(
              (listItem) => listItem.id == listItem.id
                  ? listItem.copyWith(title: value)
                  : listItem,
            ),
          ]),
    );
  }

  Widget _buildListItemActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Edit list item
        GestureDetector(
          onTap: () => context.push(
            AppRoutes.listItemDetail.route.replaceAll(
              ':listItemId',
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

        // Delete list item
        ZoeCloseButtonWidget(
          onTap: () {
            final listBlock = ref.read(listBlockProvider(listBlockId));
            if (listBlock == null) return;

            final updatedItems = listBlock.listItems
                .where((item) => item.id != listItem.id)
                .toList();
            ref
                .read(listBlockListUpdateProvider)
                .call(listBlockId, updatedItems);
          },
        ),
      ],
    );
  }
}
