import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_providers.dart';
import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/text/providers/text_providers.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/list/providers/list_providers.dart';
import 'package:zoey/features/bullets/providers/bullet_providers.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/list/models/list_model.dart';
import 'package:zoey/features/text/models/text_model.dart';

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

void addNewBulletedListContent(WidgetRef ref, parentId, String sheetId) {
  final orderIndex = _getNextOrderIndex(ref, parentId);
  final bulletedListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ListType.bulleted,
    orderIndex: orderIndex,
  );
  ref.read(listsrovider.notifier).addList(bulletedListContentModel);

  // Add a default bullet item to the new list
  ref
      .read(bulletListProvider.notifier)
      .addBullet('', bulletedListContentModel.id);
}

void addNewTaskListContent(WidgetRef ref, parentId, String sheetId) {
  final orderIndex = _getNextOrderIndex(ref, parentId);
  final toDoListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ListType.task,
    orderIndex: orderIndex,
  );
  ref.read(listsrovider.notifier).addList(toDoListContentModel);

  // Add a default task item to the new list
  ref.read(taskListProvider.notifier).addTask('', toDoListContentModel.id);
}
