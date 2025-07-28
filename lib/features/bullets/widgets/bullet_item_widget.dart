import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/bullets/model/bullet_model.dart';
import 'package:zoey/features/bullets/providers/bullet_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class BulletItemWidget extends ConsumerWidget {
  final String bulletId;
  final bool isEditing;

  const BulletItemWidget({
    super.key,
    required this.bulletId,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulletItem = ref.watch(bulletProvider(bulletId));

    if (bulletItem == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 2, top: 2, left: 12),
      child: _buildBulletItemContent(context, ref, bulletItem, isEditing),
    );
  }

  Widget _buildBulletItemContent(
    BuildContext context,
    WidgetRef ref,
    BulletModel bulletItem,
    bool isEditing,
  ) {
    return Row(
      children: [
        _buildBulletItemIcon(context),
        const SizedBox(width: 10),
        Expanded(
          child: _buildBulletItemTitle(
            context,
            ref,
            bulletItem.title,
            isEditing,
          ),
        ),
        const SizedBox(width: 6),
        if (isEditing) _buildBulletItemActions(context, ref),
      ],
    );
  }

  // Builds the bullet item icon
  Widget _buildBulletItemIcon(BuildContext context) {
    return Icon(
      Icons.circle,
      size: 8,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }

  // Builds the bullet item title
  Widget _buildBulletItemTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: L10n.of(context).bulletItem,
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) {
        ref
            .read(bulletListProvider.notifier)
            .updateBulletTitle(bulletId, value);
      },
      onBackspaceEmptyText: () =>
          ref.read(bulletListProvider.notifier).deleteBullet(bulletId),
      onTapText: () => context.push(
        AppRoutes.bulletDetail.route.replaceAll(':bulletId', bulletId),
      ),
    );
  }

  // Builds the bullet item actions
  Widget _buildBulletItemActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Edit list item
        GestureDetector(
          onTap: () => context.push(
            AppRoutes.bulletDetail.route.replaceAll(':bulletId', bulletId),
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
            ref.read(bulletListProvider.notifier).deleteBullet(bulletId);
          },
        ),
      ],
    );
  }
}
