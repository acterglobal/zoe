import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_network_local_image_view.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_type_bottom_sheet.dart';

class SheetAvatarWidget extends ConsumerWidget {
  final String sheetId;
  final bool isWithBackground;
  final bool isCompact;
  final EdgeInsetsGeometry? padding;
  final double? size;
  final double? iconSize;
  final double? imageSize;
  final double? emojiSize;

  const SheetAvatarWidget({
    super.key,
    required this.sheetId,
    this.isWithBackground = true,
    this.isCompact = false,
    this.padding,
    this.size,
    this.iconSize,
    this.imageSize,
    this.emojiSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(sheetProvider(sheetId));
    if (sheet == null) return const SizedBox.shrink();
    final isEditing = ref.watch(editContentIdProvider) == sheetId;

    return GestureDetector(
      onTap: isEditing
          ? () => SheetAvatarTypeBottomSheet.show(context, sheetId)
          : null,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: _buildBackground(context, sheet),
      ),
    );
  }

  Widget _buildBackground(BuildContext context, SheetModel sheet) {
    final theme = Theme.of(context);
    final effectiveSize = size ?? (isCompact ? 34 : 56);
    final effectivePrimaryColor =
        sheet.sheetAvatar.color ?? theme.colorScheme.primary;

    if (isWithBackground) {
      return StyledContentContainer(
        size: effectiveSize,
        primaryColor: effectivePrimaryColor,
        backgroundOpacity: 0.1,
        borderOpacity: 0.10,
        shadowOpacity: 0.06,
        child: _buildAvatar(context, sheet),
      );
    } else {
      return _buildAvatar(context, sheet);
    }
  }

  Widget _buildAvatar(BuildContext context, SheetModel sheet) {
    switch (sheet.sheetAvatar.type) {
      case AvatarType.image:
        return _buildImage(context, sheet);
      case AvatarType.emoji:
        return _buildEmoji(context, sheet);
      case AvatarType.icon:
        return _buildIcon(context, sheet);
    }
  }

  Widget _buildImage(BuildContext context, SheetModel sheet) {
    final double effectiveSize = imageSize ?? (isCompact ? 24 : 40);
    final double placeholderIconSize = isCompact ? 24 : 40;
    return ZoeNetworkLocalImageView(
      imageUrl: sheet.sheetAvatar.data,
      height: effectiveSize,
      width: effectiveSize,
      placeholderIconSize: placeholderIconSize,
    );
  }

  Widget _buildEmoji(BuildContext context, SheetModel sheet) {
    final effectiveEmojiSize = emojiSize ?? (isCompact ? 18 : 32);
    return Text(
      sheet.sheetAvatar.data,
      style: TextStyle(fontSize: effectiveEmojiSize),
    );
  }

  Widget _buildIcon(BuildContext context, SheetModel sheet) {
    final theme = Theme.of(context);
    final effectiveIconSize = iconSize ?? (isCompact ? 24 : 34);
    final effectiveIconColor =
        sheet.sheetAvatar.color ?? theme.colorScheme.primary;
    final icon = ZoeIcon.iconFor(sheet.sheetAvatar.data);

    return Icon(icon?.data, size: effectiveIconSize, color: effectiveIconColor);
  }
}
