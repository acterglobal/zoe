import 'package:zoe/features/link/models/link_model.dart';

final linkList = [
  LinkModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'link-1',
    title: 'Zoe Official Documentation',
    url: 'https://docs.hellozoe.app',
    emoji: '📚',
    orderIndex: 1,
    createdBy: 'user_1',
  ),
  LinkModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'link-2',
    title: 'Video Tutorials',
    url: 'https://tutorials.hellozoe.app',
    emoji: '🎥',
    orderIndex: 2,
    createdBy: 'user_1',
  ),
  LinkModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'link-3',
    title: 'Community Forum',
    url: 'https://community.hellozoe.app',
    emoji: '💬',
    orderIndex: 3,
    createdBy: 'user_1',
  ),
];
