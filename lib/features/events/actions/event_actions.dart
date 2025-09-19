import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/share/utils/share_utils.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/events/providers/events_proivder.dart';
import 'package:zoe/l10n/generated/l10n.dart';

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
