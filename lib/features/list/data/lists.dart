import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/list/models/list_model.dart';

final lists = [
  ListModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'list-bulleted-1',
    title: 'Key Features at a Glance',
    emoji: '✨',
    type: ContentType.bullet,
    orderIndex: 4,
  ),
  ListModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'list-tasks-1',
    title: 'Your Onboarding Checklist',
    emoji: '🚀',
    type: ContentType.task,
    orderIndex: 5,
  ),
  ListModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'list-bulleted-2',
    title: 'Best Practices & Pro Tips',
    emoji: '🎯',
    type: ContentType.bullet,
    orderIndex: 7,
  ),
  ListModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'list-bulleted-3',
    title: 'What You Can Do Next',
    emoji: '🔗',
    type: ContentType.bullet,
    orderIndex: 8,
  ),
];
