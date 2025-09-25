import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/l10n/generated/l10n.dart';

/// Shows the event menu popup using the generic component
void showEventMenu({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEditing,
  required String eventId,
  bool isDetailScreen = false,
}) {
  final menuItems = [
    ZoeCommonMenuItems.copy(
      onTapCopy: () => EventActions.copyEvent(context, ref, eventId),
      subtitle: L10n.of(context).copyEventContent,
    ),
    ZoeCommonMenuItems.share(
      onTapShare: () => EventActions.shareEvent(context, eventId),
      subtitle: L10n.of(context).shareThisEvent,
    ),
    if (!isEditing)
      ZoeCommonMenuItems.edit(
        onTapEdit: () => EventActions.editEvent(ref, eventId),
        subtitle: L10n.of(context).editThisEvent,
      ),
    ZoeCommonMenuItems.delete(
      onTapDelete: () {
        EventActions.deleteEvent(context, ref, eventId);
        if (context.mounted && context.canPop() && isDetailScreen) {
          context.pop();
        }
      },
      subtitle: L10n.of(context).deleteThisEvent,
    ),
  ];

  ZoePopupMenuWidget.show(context: context, items: menuItems);
}

/// Event-specific actions that can be performed on event content
class EventActions {
  /// Copies event content to clipboard
  static void copyEvent(BuildContext context, WidgetRef ref, String eventId) {
    final eventContent = ShareUtils.getEventContentShareMessage(
      ref: ref,
      parentId: eventId,
    );
    Clipboard.setData(ClipboardData(text: eventContent));
    CommonUtils.showSnackBar(context, L10n.of(context).copiedToClipboard);
  }

  /// Shares event content using the platform share functionality
  static void shareEvent(BuildContext context, String eventId) {
    showShareItemsBottomSheet(context: context, parentId: eventId);
  }

  /// Enables edit mode for the specified event
  static void editEvent(WidgetRef ref, String eventId) {
    ref.read(editContentIdProvider.notifier).state = eventId;
  }

  /// Deletes the specified event content
  static void deleteEvent(BuildContext context, WidgetRef ref, String eventId) {
    ref.read(eventListProvider.notifier).deleteEvent(eventId);
    CommonUtils.showSnackBar(context, L10n.of(context).eventDeleted);
  }
}
