import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/events/providers/events_proivder.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/text/models/text_model.dart';

// Helper function to get the next orderIndex for a parent
int _getNextOrderIndex(WidgetRef ref, String parentId) {
  final contentList = ref.read(contentListProvider);
  final parentContent = contentList
      .where((c) => c.parentId == parentId)
      .toList();

  if (parentContent.isEmpty) return 0;

  final maxOrderIndex = parentContent
      .map((c) => c.orderIndex)
      .reduce((max, current) => current > max ? current : max);

  return maxOrderIndex + 1;
}

// Helper function to reorder content within a parent
void reorderContent(WidgetRef ref, String contentId, int newOrderIndex) {
  final contentList = ref.read(contentListProvider);
  final content = contentList.where((c) => c.id == contentId).firstOrNull;

  if (content == null) return;

  // Update the content with new orderIndex based on its type
  switch (content.type) {
    case ContentType.text:
      ref
          .read(textListProvider.notifier)
          .updateTextOrderIndex(contentId, newOrderIndex);
      break;
    case ContentType.event:
      ref
          .read(eventListProvider.notifier)
          .updateEventOrderIndex(contentId, newOrderIndex);
      break;
    case ContentType.list:
      ref
          .read(listsrovider.notifier)
          .updateListOrderIndex(contentId, newOrderIndex);
      break;
    case ContentType.task:
      ref
          .read(taskListProvider.notifier)
          .updateTaskOrderIndex(contentId, newOrderIndex);
      break;
    case ContentType.bullet:
      ref
          .read(bulletListProvider.notifier)
          .updateBulletOrderIndex(contentId, newOrderIndex);
      break;
    case ContentType.link:
      ref
          .read(linkListProvider.notifier)
          .updateLinkOrderIndex(contentId, newOrderIndex);
      break;
    case ContentType.document:
      ref
          .read(documentListProvider.notifier)
          .updateDocumentOrderIndex(contentId, newOrderIndex);
      break;
    case ContentType.poll:
      ref
          .read(pollListProvider.notifier)
          .updatePollOrderIndex(contentId, newOrderIndex);
      break;
  }
}

void addNewTextContent(WidgetRef ref, parentId, String sheetId) {
  final orderIndex = _getNextOrderIndex(ref, parentId);
  final textContentModel = TextModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    description: (plainText: '', htmlText: ''),
    orderIndex: orderIndex,
  );
  ref.read(textListProvider.notifier).addText(textContentModel);
}

void addNewEventContent(WidgetRef ref, parentId, String sheetId) {
  final orderIndex = _getNextOrderIndex(ref, parentId);
  final eventContentModel = EventModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    description: (plainText: '', htmlText: ''),
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    orderIndex: orderIndex,
  );
  ref.read(eventListProvider.notifier).addEvent(eventContentModel);
}

void addNewEventListContent(WidgetRef ref, parentId, String sheetId) {
  final orderIndex = _getNextOrderIndex(ref, parentId);
  final eventListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ContentType.event,
    orderIndex: orderIndex,
  );
  ref.read(listsrovider.notifier).addList(eventListContentModel);

  // Add a default event item to the new list
  ref
      .read(eventListProvider.notifier)
      .addEvent(
        EventModel(
          parentId: eventListContentModel.id,
          sheetId: sheetId,
          title: '',
          description: (plainText: '', htmlText: ''),
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          orderIndex: 0,
        ),
      );
}

void addNewBulletedListContent(WidgetRef ref, parentId, String sheetId) {
  final orderIndex = _getNextOrderIndex(ref, parentId);
  final bulletedListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ContentType.bullet,
    orderIndex: orderIndex,
  );
  ref.read(listsrovider.notifier).addList(bulletedListContentModel);

  // Add a default bullet item to the new list
  ref
      .read(bulletListProvider.notifier)
      .addBullet(parentId: bulletedListContentModel.id, sheetId: sheetId);
}

void addNewTaskListContent(WidgetRef ref, parentId, String sheetId) {
  final orderIndex = _getNextOrderIndex(ref, parentId);
  final toDoListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ContentType.task,
    orderIndex: orderIndex,
  );
  ref.read(listsrovider.notifier).addList(toDoListContentModel);

  // Add a default task item to the new list
  ref
      .read(taskListProvider.notifier)
      .addTask(parentId: toDoListContentModel.id, sheetId: sheetId);
}

void addNewLinkContent(WidgetRef ref, parentId, String sheetId) {
  final orderIndex = _getNextOrderIndex(ref, parentId);
  final linkContentModel = LinkModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    url: '',
    orderIndex: orderIndex,
  );
  ref.read(linkListProvider.notifier).addLink(linkContentModel);
}

void addNewDocumentContent(WidgetRef ref, parentId, String sheetId) {
  final orderIndex = _getNextOrderIndex(ref, parentId);
  final documentListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ContentType.document,
    orderIndex: orderIndex,
  );
  ref.read(listsrovider.notifier).addList(documentListContentModel);
}

void addNewPollContent(WidgetRef ref, parentId, String sheetId) {
  final orderIndex = _getNextOrderIndex(ref, parentId);
  ref
      .read(pollListProvider.notifier)
      .addPoll(
        parentId: parentId,
        sheetId: sheetId,
        orderIndex: orderIndex,
        question: '',
      );
}
