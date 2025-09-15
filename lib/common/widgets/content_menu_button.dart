import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/models/menu_item_data_model.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/events/providers/events_proivder.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/sheet/actions/delete_sheet.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ContentMenuButton extends ConsumerWidget {
  final String parentId;
  final bool isSheetDetailScreen;

  const ContentMenuButton({
    super.key,
    required this.parentId,
    this.isSheetDetailScreen = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = _buildMenuItems(context, ref);

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

  List<MenuItemDataModel> _buildMenuItems(BuildContext context, WidgetRef ref) {
    final items = <MenuItemDataModel>[];

    // Add other menu items
    items.addAll([
      if (isSheetDetailScreen)
        MenuItemDataModel(
          action: ContentMenuAction.connect,
          icon: Icons.link_rounded,
          title: L10n.of(context).connect,
          subtitle: L10n.of(context).connectWithWhatsAppGroup,
        ),
      MenuItemDataModel(
        action: ContentMenuAction.edit,
        icon: Icons.edit_rounded,
        title: isSheetDetailScreen
            ? L10n.of(context).editSheet
            : L10n.of(context).edit,
        subtitle: L10n.of(context).editThisContent,
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
    ContentMenuAction.edit =>
      ref.read(editContentIdProvider.notifier).state = parentId,
    ContentMenuAction.share => showShareItemsBottomSheet(
      context: context,
      parentId: parentId,
      isSheet: isSheetDetailScreen,
    ),
    ContentMenuAction.delete => _handleDelete(context, ref),
  };

  void _handleDelete(BuildContext context, WidgetRef ref) {
    if (isSheetDetailScreen) {
      showDeleteSheetConfirmation(context, ref, parentId);
    } else {
      _handleDeleteContent(context, ref);
    }
  }

  void _handleDeleteContent(BuildContext context, WidgetRef ref) {
    final content = ref.read(contentProvider(parentId));
    if (!context.mounted || content == null) return;
    switch (content.type) {
      case ContentType.text:
        ref.read(textListProvider.notifier).deleteText(parentId);
        break;
      case ContentType.event:
        ref.read(eventListProvider.notifier).deleteEvent(parentId);
        break;
      case ContentType.list:
        ref.read(listsrovider.notifier).deleteList(parentId);
        break;
      case ContentType.task:
        ref.read(taskListProvider.notifier).deleteTask(parentId);
        break;
      case ContentType.bullet:
        ref.read(bulletListProvider.notifier).deleteBullet(parentId);
        break;
      case ContentType.link:
        ref.read(linkListProvider.notifier).deleteLink(parentId);
        break;
      case ContentType.document:
        ref.read(documentListProvider.notifier).deleteDocument(parentId);
        break;
      case ContentType.poll:
        ref.read(pollListProvider.notifier).deletePoll(parentId);
        break;
    }
    if (!context.mounted) return;
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
}
