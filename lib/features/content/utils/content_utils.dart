import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

// Helper function to get the new orderIndex for a parent
int _getNewOrderIndex({
  required WidgetRef ref,
  required String parentId,
  bool addAtTop = false,
}) {
  final contentList = ref.read(contentListProvider);
  final parentContent = contentList
      .where((c) => c.parentId == parentId)
      .toList();

  if (parentContent.isEmpty) return 0;

  if (addAtTop) {
    // Get minimum order index and subtract 1 to add at top
    final minOrderIndex = parentContent
        .map((c) => c.orderIndex)
        .reduce((min, current) => current < min ? current : min);
    return minOrderIndex - 1;
  } else {
    // Get maximum order index and add 1 to add at bottom
    final maxOrderIndex = parentContent
        .map((c) => c.orderIndex)
        .reduce((max, current) => current > max ? current : max);
    return maxOrderIndex + 1;
  }
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
          .read(listsProvider.notifier)
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

void addNewTextContent({
  required WidgetRef ref,
  required String parentId,
  required String sheetId,
  bool addAtTop = false,
}) {
  final userId = ref.read(loggedInUserProvider).value;
  if (userId == null) return;

  final orderIndex = _getNewOrderIndex(
    ref: ref,
    parentId: parentId,
    addAtTop: addAtTop,
  );
  final textContentModel = TextModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    description: (plainText: '', htmlText: ''),
    orderIndex: orderIndex,
    createdBy: userId,
  );
  ref.read(textListProvider.notifier).addText(textContentModel);
  ref.read(editContentIdProvider.notifier).state = textContentModel.id;
}

void addNewEventContent({
  required WidgetRef ref,
  required String parentId,
  required String sheetId,
  bool addAtTop = false,
}) {
  final userId = ref.read(loggedInUserProvider).value;
  if (userId == null) return;

  final orderIndex = _getNewOrderIndex(
    ref: ref,
    parentId: parentId,
    addAtTop: addAtTop,
  );
  final eventContentModel = EventModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    description: (plainText: '', htmlText: ''),
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    orderIndex: orderIndex,
    createdBy: userId,
  );
  ref.read(eventListProvider.notifier).addEvent(eventContentModel);
  ref.read(editContentIdProvider.notifier).state = eventContentModel.id;
}

void addNewBulletedListContent({
  required WidgetRef ref,
  required String parentId,
  required String sheetId,
  bool addAtTop = false,
}) {
  final userId = ref.read(loggedInUserProvider).value;
  if (userId == null) return;

  final orderIndex = _getNewOrderIndex(
    ref: ref,
    parentId: parentId,
    addAtTop: addAtTop,
  );
  final bulletedListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ContentType.bullet,
    orderIndex: orderIndex,
    createdBy: userId,
  );
  ref.read(listsProvider.notifier).addList(bulletedListContentModel);
  ref.read(editContentIdProvider.notifier).state = bulletedListContentModel.id;
  // Add a default bullet item to the new list
  ref
      .read(bulletListProvider.notifier)
      .addBullet(parentId: bulletedListContentModel.id, sheetId: sheetId);
}

void addNewTaskListContent({
  required WidgetRef ref,
  required String parentId,
  required String sheetId,
  bool addAtTop = false,
}) {
  final userId = ref.read(loggedInUserProvider).value;
  if (userId == null) return;

  final orderIndex = _getNewOrderIndex(
    ref: ref,
    parentId: parentId,
    addAtTop: addAtTop,
  );
  final toDoListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ContentType.task,
    orderIndex: orderIndex,
    createdBy: userId,
  );
  ref.read(listsProvider.notifier).addList(toDoListContentModel);
  ref.read(editContentIdProvider.notifier).state = toDoListContentModel.id;

  // Add a default task item to the new list
  ref
      .read(taskListProvider.notifier)
      .addTask(parentId: toDoListContentModel.id, sheetId: sheetId);
}

void addNewLinkContent({
  required WidgetRef ref,
  required String parentId,
  required String sheetId,
  bool addAtTop = false,
}) {
  final userId = ref.read(loggedInUserProvider).value;
  if (userId == null) return;

  final orderIndex = _getNewOrderIndex(
    ref: ref,
    parentId: parentId,
    addAtTop: addAtTop,
  );
  final linkContentModel = LinkModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    url: '',
    orderIndex: orderIndex,
    createdBy: userId,
  );
  ref.read(linkListProvider.notifier).addLink(linkContentModel);
  ref.read(editContentIdProvider.notifier).state = linkContentModel.id;
}

void addNewDocumentContent({
  required WidgetRef ref,
  required String parentId,
  required String sheetId,
  bool addAtTop = false,
}) {
  final userId = ref.read(loggedInUserProvider).value;
  if (userId == null) return;

  final orderIndex = _getNewOrderIndex(
    ref: ref,
    parentId: parentId,
    addAtTop: addAtTop,
  );
  final documentListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ContentType.document,
    orderIndex: orderIndex,
    createdBy: userId,
  );
  ref.read(listsProvider.notifier).addList(documentListContentModel);
  ref.read(editContentIdProvider.notifier).state = documentListContentModel.id;
}

Future<void> addNewPollContent({
  required WidgetRef ref,
  required String parentId,
  required String sheetId,
  bool addAtTop = false,
}) async {
  final userId = ref.read(loggedInUserProvider).value;
  if (userId == null) return;

  final orderIndex = _getNewOrderIndex(
    ref: ref,
    parentId: parentId,
    addAtTop: addAtTop,
  );
  final newPoll = PollModel(
    parentId: parentId,
    question: '',
    sheetId: sheetId,
    orderIndex: orderIndex,
    options: [
      PollOption(id: CommonUtils.generateRandomId(), title: ''),
      PollOption(id: CommonUtils.generateRandomId(), title: ''),
    ],
    createdBy: userId,
  );

  ref.read(pollListProvider.notifier).addPoll(newPoll);
  ref.read(editContentIdProvider.notifier).state = newPoll.id;
}
