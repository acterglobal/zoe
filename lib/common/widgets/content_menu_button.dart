import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/models/menu_item_data_model.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/sheet/actions/delete_sheet.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ContentMenuButton extends ConsumerWidget {
  final String parentId;
  final bool showConnectOption;

  const ContentMenuButton({
    super.key,
    required this.parentId,
    this.showConnectOption = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(editContentIdProvider) == parentId;
    final colorScheme = Theme.of(context).colorScheme;

    final items = _buildMenuItems(context, isEditing);

    return PopupMenuButton<ContentMenuAction>(
      onSelected: (action) => _handleMenuSelection(context, ref, action),
      offset: const Offset(2, 50),
      elevation: 10,
      shadowColor: colorScheme.primary.withValues(alpha: 0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => items.map((item) {
        return PopupMenuItem<ContentMenuAction>(
          value: item.action,
          child: _buildMenuItem(context, item),
        );
      }).toList(),
      child: StyledIconContainer(
        icon: Icons.more_vert_rounded,
        size: 40,
        iconSize: 20,
        primaryColor: colorScheme.onSurface,
        secondaryColor: colorScheme.onSurface.withValues(alpha: 0.4),
        backgroundOpacity: 0.08,
        borderOpacity: 0.15,
        shadowOpacity: 0.1,
      ),
    );
  }

  List<MenuItemDataModel> _buildMenuItems(
    BuildContext context,
    bool isEditing,
  ) {
    final items = <MenuItemDataModel>[];

    // Add other menu items
    items.addAll([
      if (showConnectOption)
        MenuItemDataModel(
          action: ContentMenuAction.connect,
          icon: Icons.link_rounded,
          title: L10n.of(context).connect,
          subtitle: L10n.of(context).connectWithWhatsAppGroup,
        ),
      MenuItemDataModel(
        action: ContentMenuAction.share,
        icon: Icons.share_rounded,
        title: L10n.of(context).share,
        subtitle: L10n.of(context).shareThisContent,
      ),
      MenuItemDataModel(
        action: ContentMenuAction.delete,
        icon: Icons.delete_rounded,
        title: L10n.of(context).delete,
        subtitle: L10n.of(context).deleteThisContent,
        isDestructive: true,
      ),
    ]);

    return items;
  }

  Widget _buildMenuItem(BuildContext context, MenuItemDataModel item) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = item.isDestructive ? colorScheme.error : colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Icon(item.icon, size: 20, color: color),
          const SizedBox(width: 16),
          _buildMenuTitleSubtitle(context, item),
        ],
      ),
    );
  }

  Widget _buildMenuTitleSubtitle(BuildContext context, MenuItemDataModel item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
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
    );
  }

  void _handleMenuSelection(
    BuildContext context,
    WidgetRef ref,
    ContentMenuAction action,
  ) => switch (action) {
    ContentMenuAction.connect => context.push(
      AppRoutes.whatsappGroupConnect.route.replaceAll(':sheetId', parentId),
    ),
    ContentMenuAction.share => showShareItemsBottomSheet(
      context: context,
      parentId: parentId,
      isSheet: showConnectOption,
    ),
    ContentMenuAction.delete => showDeleteSheetConfirmation(
      context,
      ref,
      parentId,
    ),
  };
}
