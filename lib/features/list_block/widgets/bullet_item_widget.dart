import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/list_block/providers/bullet_item_provider.dart';

class BulletItemWidget extends ConsumerWidget {
  final String bulletItemId;
  final bool isEditing;

  const BulletItemWidget({
    super.key,
    required this.bulletItemId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulletItem = ref.watch(bulletItemProvider(bulletItemId));
    if (bulletItem == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildBulletItemIcon(context),
          const SizedBox(width: 10),
          Expanded(
            child: _buildBulletItemTitle(context, ref, bulletItem.title),
          ),
          const SizedBox(width: 6),
          if (isEditing) _buildBulletItemActions(context, ref),
        ],
      ),
    );
  }

  // Builds the list item icon
  Widget _buildBulletItemIcon(BuildContext context) {
    return Icon(
      Icons.circle,
      size: 8,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }

  // Builds the list item title
  Widget _buildBulletItemTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'Bullet item',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) {},
    );
  }

  Widget _buildBulletItemActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Edit list item
        GestureDetector(
          onTap: () => context.push(
            AppRoutes.listItemDetail.route.replaceAll(
              ':bulletItemId',
              bulletItemId,
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
