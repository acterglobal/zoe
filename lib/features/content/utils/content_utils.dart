import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_list_providers.dart';
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
  ref.read(contentNotifierProvider.notifier).addContent(textContentModel);
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
  ref.read(contentNotifierProvider.notifier).addContent(eventContentModel);
}

void addNewBulletedListContent(WidgetRef ref, parentId, String sheetId) {
  final bulletedListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ListType.bulleted,
  );
  ref
      .read(contentNotifierProvider.notifier)
      .addContent(bulletedListContentModel);
}

void addNewTaskListContent(WidgetRef ref, parentId, String sheetId) {
  final toDoListContentModel = ListModel(
    parentId: parentId,
    sheetId: sheetId,
    title: '',
    listType: ListType.task,
  );
  ref.read(contentNotifierProvider.notifier).addContent(toDoListContentModel);
}
