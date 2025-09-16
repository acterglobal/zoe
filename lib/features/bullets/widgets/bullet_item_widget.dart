import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_chip_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/bullets/widgets/bullet_added_by_header_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class BulletItemWidget extends ConsumerWidget {
  final String bulletId;
  final bool isEditing;
  final bool showUserName;

  const BulletItemWidget({
    super.key,
    required this.bulletId,
    required this.isEditing,
    this.showUserName = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulletItem = ref.watch(bulletProvider(bulletId));
    final focusedBulletId = ref.watch(bulletFocusProvider);
    final shouldFocus = focusedBulletId == bulletId;

    if (bulletItem == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 2, top: 2, left: 12),
      child: _buildBulletItemContent(context, ref, bulletItem, shouldFocus),
    );
  }

  Widget _buildBulletItemContent(
    BuildContext context,
    WidgetRef ref,
    BulletModel bulletItem,
    bool autoFocus,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildBulletItemIcon(context),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBulletItemTitle(context, ref, bulletItem, autoFocus),
                  if(!showUserName)
                    _buildAddedByAvatarWidget(context, ref, bulletItem)
                ],
              ),
            ),

            const SizedBox(width: 6),
            if (isEditing) _buildBulletItemActions(context, ref),
          ],
        ),
        if (showUserName) ...[
          const SizedBox(height: 2),
          _buildDisplayAddedByUserViewWidget(context, ref, bulletItem),
          const SizedBox(height: 6),

        ],
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
    BulletModel bulletItem,
    bool autoFocus,
  ) {
    return Flexible(
      child: ZoeInlineTextEditWidget(
        hintText: L10n.of(context).bulletItem,
        isEditing: isEditing,
        text: bulletItem.title,
        textStyle: Theme.of(context).textTheme.bodyMedium,
        textInputAction: TextInputAction.next,
        autoFocus: autoFocus,
        onTextChanged: (value) {
          ref
              .read(bulletListProvider.notifier)
              .updateBulletTitle(bulletId, value);
        },
        onEnterPressed: () {
          ref
              .read(bulletListProvider.notifier)
              .addBullet(
                parentId: bulletItem.parentId,
                sheetId: bulletItem.sheetId,
                orderIndex: bulletItem.orderIndex + 1,
              );
        },
        onBackspaceEmptyText: () =>
            ref.read(bulletListProvider.notifier).deleteBullet(bulletId),
        onTapText: () => context.push(
          AppRoutes.bulletDetail.route.replaceAll(':bulletId', bulletId),
        ),
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

  // Builds the added by user avatar
  Widget _buildAddedByAvatarWidget(
    BuildContext context,
    WidgetRef ref,
    BulletModel bulletItem,
  ) {
    final user = ref.watch(getUserByIdProvider(bulletItem.createdBy));
    if (user == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ZoeUserChipWidget(user: user,type: ZoeUserChipType.userAvatarOnly,),
    );
  }

  // Builds the added by user view
  Widget _buildDisplayAddedByUserViewWidget(
    BuildContext context,
    WidgetRef ref,
    BulletModel bulletItem,
  ) {
    final user = ref.watch(getUserByIdProvider(bulletItem.createdBy));
    if (user == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(children: [
        BulletAddedByHeaderWidget(iconSize: 16, textSize: 12),
        const SizedBox(width: 8),
        ZoeUserChipWidget(user: user,type: ZoeUserChipType.userNameOnly,)
      ]),
    );
  }
}
