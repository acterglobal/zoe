import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/bottom_sheet_option_widget.dart';
import 'package:zoe/common/widgets/emoji_picker/widgets/custom_emoji_picker_widget.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/picker/zoe_icon_picker.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/sheet/actions/sheet_data_updates.dart';
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
    ZoeIconPicker.show(
      context: context,
      selectedColor: Colors.blueGrey,
      selectedIcon: ZoeIcon.list,
      onIconSelection: (color, icon) {
        updateSheetIconAndColor(ref, sheetId, icon, color);
        if (context.mounted) context.pop();
      },
    );
  }

  void selectImage(BuildContext context, WidgetRef ref) {}

  void selectEmoji(BuildContext context, WidgetRef ref) {
    showCustomEmojiPicker(
      context,
      ref,
      onEmojiSelected: (emoji) {
        updateSheetEmoji(ref, sheetId, emoji);
        if (context.mounted) context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

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
          BottomSheetOptionWidget(
            icon: Icons.image_rounded,
            title: l10n.image,
            subtitle: l10n.chooseImageDescription,
            color: AppColors.successColor,
            onTap: () => selectImage(context, ref),
          ),
          const SizedBox(height: 16),
          BottomSheetOptionWidget(
            icon: Icons.emoji_emotions_rounded,
            title: l10n.emoji,
            subtitle: l10n.chooseEmojiDescription,
            color: AppColors.secondaryColor,
            onTap: () => selectEmoji(context, ref),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
