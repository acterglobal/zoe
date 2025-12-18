import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows the bullet menu popup using the generic component
void showBulletMenu({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEditing,
  required String bulletId,
  bool isDetailScreen = false,
  bool isAppBarAction = false,
}) {
  final currentUserId = ref.read(currentUserProvider)?.id;
  final createdBy = ref.read(bulletProvider(bulletId))?.createdBy;
  final isOwner = currentUserId == createdBy;

  final menuItems = [
    ZoeCommonMenuItems.copy(
      onTapCopy: () => BulletActions.copyBullet(context, ref, bulletId),
      subtitle: L10n.of(context).copyBulletContent,
    ),
    ZoeCommonMenuItems.share(
      onTapShare: () => BulletActions.shareBullet(context, ref, bulletId),
      subtitle: L10n.of(context).shareThisBullet,
    ),
    if (!isEditing && isOwner)
      ZoeCommonMenuItems.edit(
        onTapEdit: () => BulletActions.editBullet(ref, bulletId),
        subtitle: L10n.of(context).editThisBullet,
      ),
    if (isOwner)
      ZoeCommonMenuItems.delete(
        onTapDelete: () {
          BulletActions.deleteBullet(context, ref, bulletId);
          if (context.mounted && context.canPop() && isDetailScreen) {
            context.pop();
          }
        },
        subtitle: L10n.of(context).deleteThisBullet,
      ),
  ];

  ZoePopupMenuWidget.show(
    context: context,
    items: menuItems,
    isAppBarAction: isAppBarAction,
  );
}

/// Bullet-specific actions that can be performed on bullet content
class BulletActions {
  /// Copies bullet content to clipboard
  static void copyBullet(BuildContext context, WidgetRef ref, String bulletId) {
    final bulletContent = ShareUtils.getBulletContentShareMessage(
      ref: ref,
      parentId: bulletId,
    );
    Clipboard.setData(ClipboardData(text: bulletContent));
    CommonUtils.showSnackBar(context, L10n.of(context).copiedToClipboard);
  }

  /// Shares bullet content using the platform share functionality
  static void shareBullet(
    BuildContext context,
    WidgetRef ref,
    String bulletId,
  ) {
    final bulletContent = ref.read(bulletProvider(bulletId));
    if (bulletContent == null) return;
    if (bulletContent.title.isEmpty) {
      CommonUtils.showSnackBar(context, L10n.of(context).pleaseAddBulletTitle);
      return;
    }
    showShareItemsBottomSheet(context: context, parentId: bulletId);
  }

  /// Enables edit mode for the specified bullet
  static void editBullet(WidgetRef ref, String bulletId) {
    ref.read(editContentIdProvider.notifier).state = bulletId;
  }

  /// Deletes the specified bullet content
  static void deleteBullet(
    BuildContext context,
    WidgetRef ref,
    String bulletId,
  ) {
    ref.read(bulletListProvider.notifier).deleteBullet(bulletId);
    CommonUtils.showSnackBar(context, L10n.of(context).bulletDeleted);
  }
}
