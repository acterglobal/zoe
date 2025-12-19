import 'package:flutter/material.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Generic popup menu item data model
class ZoePopupMenuItem {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback? onTap;

  const ZoePopupMenuItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isDestructive = false,
    this.onTap,
  });
}

/// Generic popup menu widget that can be reused across the app
class ZoePopupMenuWidget extends StatelessWidget {
  final List<ZoePopupMenuItem> items;
  final Offset? position;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;

  const ZoePopupMenuWidget({
    super.key,
    required this.items,
    this.position,
    this.elevation = 10,
    this.shadowColor,
    this.shape,
  });

  /// Shows the popup menu at the specified position
  static Future<void> show({
    required BuildContext context,
    required List<ZoePopupMenuItem> items,
    Offset? position,
    double elevation = 10,
    Color? shadowColor,
    ShapeBorder? shape,
    bool isAppBarAction = false,
    Color? menuIconColor,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final renderBox = context.findRenderObject() as RenderBox?;
    final offset =
        position ?? renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    // Filter out items that don't have onTap callbacks
    final activeItems = items.where((item) => item.onTap != null).toList();

    if (activeItems.isEmpty) return;

    final selectedItem = await showMenu<ZoePopupMenuItem>(
      context: context,
      position: isAppBarAction
          ? RelativeRect.fromLTRB(
              offset.dx - 40, // Position to the left of the button
              offset.dy + 45, // Slightly below the button
              offset.dx + 40,
              offset.dy + 200,
            )
          : RelativeRect.fromLTRB(
              offset.dx,
              offset.dy + 50,
              offset.dx + 200,
              offset.dy + 200,
            ),
      elevation: elevation,
      shadowColor:
          shadowColor ??
          (menuIconColor ?? colorScheme.primary).withValues(alpha: 0.6),
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: activeItems.map((item) {
        return PopupMenuItem<ZoePopupMenuItem>(
          value: item,
          child: _buildMenuItem(context, item, menuIconColor),
        );
      }).toList(),
    );

    if (selectedItem != null && context.mounted) {
      selectedItem.onTap?.call();
    }
  }

  /// Builds a menu item widget
  static Widget _buildMenuItem(
    BuildContext context,
    ZoePopupMenuItem item, [
    Color? menuIconColor,
  ]) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = item.isDestructive
        ? colorScheme.error
        : (menuIconColor ?? colorScheme.primary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Icon(item.icon, size: 20, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This widget is primarily used as a static utility
    // The actual menu is shown using the static show method
    return const SizedBox.shrink();
  }
}

/// Predefined common menu items with nullable callbacks
class ZoeCommonMenuItems {
  /// Connect menu item
  static ZoePopupMenuItem connect({
    required BuildContext context,
    VoidCallback? onTapConnect,
    String? title,
    String? subtitle,
  }) => ZoePopupMenuItem(
    id: 'connect',
    icon: Icons.link_rounded,
    title: title ?? L10n.of(context).connect,
    subtitle: subtitle ?? L10n.of(context).connectToWhatsAppGroup,
    onTap: onTapConnect,
  );

  /// Remove cover image menu item
  static ZoePopupMenuItem removeCoverImage({
    required BuildContext context,
    VoidCallback? onTapRemoveCoverImage,
    String? title,
    String? subtitle,
  }) => ZoePopupMenuItem(
    id: 'remove_cover_image',
    icon: Icons.delete_rounded,
    title: title ?? L10n.of(context).removeCoverImage,
    subtitle: subtitle ?? L10n.of(context).removeCoverImageDescription,
    onTap: onTapRemoveCoverImage,
  );

  /// Copy menu item
  static ZoePopupMenuItem copy({
    required BuildContext context,
    VoidCallback? onTapCopy,
    String? title,
    String? subtitle,
  }) => ZoePopupMenuItem(
    id: 'copy',
    icon: Icons.copy_rounded,
    title: title ?? L10n.of(context).copy,
    subtitle: subtitle ?? L10n.of(context).copyContentToClipboard,
    onTap: onTapCopy,
  );

  /// Share menu item
  static ZoePopupMenuItem share({
    required BuildContext context,
    VoidCallback? onTapShare,
    String? title,
    String? subtitle,
  }) => ZoePopupMenuItem(
    id: 'share',
    icon: Icons.share_rounded,
    title: title ?? L10n.of(context).share,
    subtitle: subtitle ?? L10n.of(context).shareThisContent,
    onTap: onTapShare,
  );

  /// Edit menu item
  static ZoePopupMenuItem edit({
    required BuildContext context,
    VoidCallback? onTapEdit,
    String? title,
    String? subtitle,
  }) => ZoePopupMenuItem(
    id: 'edit',
    icon: Icons.edit_rounded,
    title: title ?? L10n.of(context).edit,
    subtitle: subtitle ?? L10n.of(context).editThisContent,
    onTap: onTapEdit,
  );

  /// Delete menu item
  static ZoePopupMenuItem delete({
    required BuildContext context,
    VoidCallback? onTapDelete,
    String? title,
    String? subtitle,
  }) => ZoePopupMenuItem(
    id: 'delete',
    icon: Icons.delete_rounded,
    title: title ?? L10n.of(context).delete,
    subtitle: subtitle ?? L10n.of(context).deleteThisContent,
    isDestructive: true,
    onTap: onTapDelete,
  );

  /// Choose theme menu item
  static ZoePopupMenuItem chooseTheme({
    required BuildContext context,
    VoidCallback? onTapChooseTheme,
    String? title,
    String? subtitle,
  }) => ZoePopupMenuItem(
    id: 'choose_theme',
    icon: Icons.color_lens,
    title: title ?? L10n.of(context).chooseTheme,
    subtitle: subtitle ?? L10n.of(context).chooseThemeForSheet,
    onTap: onTapChooseTheme,
  );
}
