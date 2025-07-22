import 'package:zoey/features/list/models/list_model.dart';

final lists = [
  ListModel(
    sheetId: 'sheet-1',
    id: 'list-bulleted-1',
    title: 'Key Features Overview',
    listType: ListType.bulleted,
  ),
  ListModel(
    sheetId: 'sheet-1',
    id: 'list-tasks-1',
    title: 'Quick Start Checklist',
    listType: ListType.task,
  ),
  ListModel(
    sheetId: 'sheet-1',
    id: 'list-bulleted-2',
    title: 'Pro Tips',
    listType: ListType.bulleted,
  ),
];
