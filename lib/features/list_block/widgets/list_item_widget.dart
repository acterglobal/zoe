import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/list_block/providers/list_item_provider.dart';

class ListItemWidget extends ConsumerWidget {
  final String listItemId;
  final bool isEditing;

  const ListItemWidget({
    super.key,
    required this.listItemId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listItem = ref.watch(listItemProvider(listItemId));
    if (listItem == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildListItemIcon(context),
          const SizedBox(width: 10),
          Expanded(child: _buildListItemTitle(context, ref, listItem.title)),
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
  Widget _buildListItemTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'List item',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) {},
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
              listItemId,
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
        ZoeCloseButtonWidget(onTap: () {}),
      ],
    );
  }
}
