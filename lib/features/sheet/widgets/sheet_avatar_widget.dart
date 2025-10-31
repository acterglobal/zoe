import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_network_local_image_view.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

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

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: _buildBackground(context, sheet),
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
    if (sheet.sheetAvatar.image != null) {
      return _buildImage(context, sheet);
    } else if (sheet.sheetAvatar.emoji != null) {
      return _buildEmoji(context, sheet);
    } else {
      return _buildIcon(context, sheet);
    }
  }

  Widget _buildImage(BuildContext context, SheetModel sheet) {
    final double effectiveSize = imageSize ?? (isCompact ? 24 : 40);
    return ZoeNetworkLocalImageView(
      imageUrl: sheet.sheetAvatar.image!,
      height: effectiveSize,
      width: effectiveSize,
    );
  }

  Widget _buildEmoji(BuildContext context, SheetModel sheet) {
    final effectiveEmojiSize = emojiSize ?? (isCompact ? 18 : 32);
    return Text(
      sheet.sheetAvatar.emoji!,
      style: TextStyle(fontSize: effectiveEmojiSize),
    );
  }

  Widget _buildIcon(BuildContext context, SheetModel sheet) {
    final theme = Theme.of(context);
    final effectiveIconSize = iconSize ?? (isCompact ? 24 : 34);
    final effectiveIconColor =
        sheet.sheetAvatar.color ?? theme.colorScheme.primary;

    return Icon(
      sheet.sheetAvatar.icon,
      size: effectiveIconSize,
      color: effectiveIconColor,
    );
  }
}
