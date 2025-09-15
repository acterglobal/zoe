import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/events/providers/events_proivder.dart';
import 'package:zoe/features/sheet/actions/delete_sheet.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';

// Sheet actions
void editSheetAction({required WidgetRef ref, required String sheetId}) {
  ref.read(editContentIdProvider.notifier).state = sheetId;
}

void deleteSheetAction({
  required BuildContext context,
  required WidgetRef ref,
  required String sheetId,
}) {
  showDeleteSheetConfirmation(context, ref, sheetId);
  // Clear edit mode if this sheet was being edited
  final editContentId = ref.read(editContentIdProvider);
  if (editContentId == sheetId) {
    ref.read(editContentIdProvider.notifier).state = null;
  }
}

// Content actions
void editContentAction({required WidgetRef ref, required String contentId}) {
  ref.read(editContentIdProvider.notifier).state = contentId;
}

void deleteContentAction({
  required BuildContext context,
  required WidgetRef ref,
  required String contentId,
}) {
  try {
    // Get the content from the provider
    final content = ref.watch(contentProvider(contentId));
    if (content == null) return;

    final editContentIdNotifier = ref.read(editContentIdProvider.notifier);

    switch (content.type) {
      case ContentType.text:
        ref.read(textListProvider.notifier).deleteText(content.id);
        break;
      case ContentType.event:
        ref.read(eventListProvider.notifier).deleteEvent(content.id);
        break;
      case ContentType.list:
        ref.read(listsrovider.notifier).deleteList(content.id);
        break;
      case ContentType.task:
        ref.read(taskListProvider.notifier).deleteTask(content.id);
        break;
      case ContentType.bullet:
        ref.read(bulletListProvider.notifier).deleteBullet(content.id);
        break;
      case ContentType.link:
        ref.read(linkListProvider.notifier).deleteLink(content.id);
        break;
      case ContentType.document:
        ref.read(documentListProvider.notifier).deleteDocument(content.id);
        break;
      case ContentType.poll:
        ref.read(pollListProvider.notifier).deletePoll(content.id);
        break;
    }

    // Clear edit mode if this content was being deleted
    if (editContentIdNotifier.state == content.id) {
      editContentIdNotifier.state = null;
    }
  } catch (e) {
    debugPrint("Error deleting content: $e");
  }
}
