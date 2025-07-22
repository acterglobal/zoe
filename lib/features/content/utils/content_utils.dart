import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/text/providers/text_providers.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/list/providers/list_providers.dart';
import 'package:zoey/features/bullets/providers/bullet_providers.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/list/models/list_model.dart';
import 'package:zoey/features/text/models/text_model.dart';

void addNewTextContent(WidgetRef ref, parentId, String sheetId) {
  final textContentModel = TextModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    description: (plainText: '', htmlText: ''),
  );
  ref.read(textListProvider.notifier).addText(textContentModel);
}

void addNewEventContent(WidgetRef ref, parentId, String sheetId) {
  final eventContentModel = EventModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    description: (plainText: '', htmlText: ''),
    startDate: DateTime.now(),
    endDate: DateTime.now(),
  );
  ref.read(eventListProvider.notifier).addEvent(eventContentModel);
}

void addNewBulletedListContent(WidgetRef ref, parentId, String sheetId) {
  final bulletedListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ListType.bulleted,
  );
  ref.read(listsrovider.notifier).addList(bulletedListContentModel);

  // Add a default bullet item to the new list
  ref
      .read(bulletListProvider.notifier)
      .addBullet('', bulletedListContentModel.id);
}

void addNewTaskListContent(WidgetRef ref, parentId, String sheetId) {
  final toDoListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ListType.task,
  );
  ref.read(listsrovider.notifier).addList(toDoListContentModel);

  // Add a default task item to the new list
  ref.read(taskListProvider.notifier).addTask('', toDoListContentModel.id);
}
