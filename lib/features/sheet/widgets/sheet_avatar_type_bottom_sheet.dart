import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/bottom_sheet_option_widget.dart';
import 'package:zoe/common/widgets/emoji_picker/widgets/custom_emoji_picker_widget.dart';
import 'package:zoe/common/widgets/media_selection_bottom_sheet.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/picker/zoe_icon_picker.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/sheet/actions/sheet_data_updates.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class SheetAvatarTypeBottomSheet extends ConsumerWidget {
  final String sheetId;

  const SheetAvatarTypeBottomSheet({super.key, required this.sheetId});

  static Future<void> show(BuildContext context, String sheetId) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SheetAvatarTypeBottomSheet(sheetId: sheetId),
    );
  }

  void selectIcon(BuildContext context, WidgetRef ref) {
    final sheet = ref.read(sheetProvider(sheetId));
    if (sheet == null) return;
    ZoeIconPicker.show(
      context: context,
      selectedColor: sheet.sheetAvatar.color,
      selectedIcon: ZoeIcon.iconFor(sheet.sheetAvatar.data),
      onIconSelection: (color, icon) {
        updateSheetAvatar(
          ref: ref,
          sheetId: sheetId,
          type: AvatarType.icon,
          data: icon.name,
          color: color,
        );
        if (context.mounted) context.pop();
      },
    );
  }

  Future<void> selectImage(BuildContext context, WidgetRef ref) async {
    final l10n = L10n.of(context);

    await showMediaSelectionBottomSheet(
      context,
      title: l10n.selectSheetAvatarImage,
      subtitle: l10n.chooseSheetAvatarImage,
      onTapCamera: (image) {
        updateSheetAvatar(
          ref: ref,
          sheetId: sheetId,
          type: AvatarType.image,
          data: image.path,
        );
        if (context.mounted) context.pop();
      },
      onTapGallery: (images) {
        if (images.isNotEmpty) {
          updateSheetAvatar(
            ref: ref,
            sheetId: sheetId,
            type: AvatarType.image,
            data: images.first.path,
          );
          if (context.mounted) context.pop();
        }
      },
    );
  }

  void selectEmoji(BuildContext context, WidgetRef ref) {
    showCustomEmojiPicker(
      context,
      ref,
      onEmojiSelected: (emoji) {
        updateSheetAvatar(
          ref: ref,
          sheetId: sheetId,
          type: AvatarType.emoji,
          data: emoji,
        );
        if (context.mounted) context.pop();
      },
    );
  }

  void removeAvatar(BuildContext context, WidgetRef ref) {
    updateSheetAvatar(
      ref: ref,
      sheetId: sheetId,
      type: AvatarType.icon,
      data: 'file',
      color: null,
    );
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final sheet = ref.watch(sheetProvider(sheetId));

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.selectSheetAvatarType,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.chooseSheetAvatarType,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          BottomSheetOptionWidget(
            icon: Icons.category_rounded,
            title: l10n.icon,
            subtitle: l10n.chooseIconDescription,
            color: AppColors.brightOrangeColor,
            onTap: () => selectIcon(context, ref),
          ),
          const SizedBox(height: 16),
          // BottomSheetOptionWidget(
          //   icon: Icons.image_rounded,
          //   title: l10n.image,
          //   subtitle: l10n.chooseImageDescription,
          //   color: AppColors.successColor,
          //   onTap: () => selectImage(context, ref),
          // ),
          // const SizedBox(height: 16),
          BottomSheetOptionWidget(
            icon: Icons.emoji_emotions_rounded,
            title: l10n.emoji,
            subtitle: l10n.chooseEmojiDescription,
            color: AppColors.secondaryColor,
            onTap: () => selectEmoji(context, ref),
          ),
          const SizedBox(height: 16),
          if (sheet != null &&
              (sheet.sheetAvatar.type != AvatarType.icon ||
                  sheet.sheetAvatar.data != 'file' ||
                  sheet.sheetAvatar.color != null)) ...[
            BottomSheetOptionWidget(
              icon: Icons.delete_outline_rounded,
              title: l10n.removeAvatar,
              subtitle: l10n.removeAvatarDescription,
              color: AppColors.errorColor,
              onTap: () => removeAvatar(context, ref),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
