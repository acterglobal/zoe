import 'package:zoe/features/text/models/text_model.dart';

final textContent1 = 'text-content-1';
final textContent2 = 'text-content-2';
final testUser = 'test-user';

final mockText1 = TextModel(
  id: textContent1,
  sheetId: 'sheet-1',
  parentId: 'sheet-1',
  title: 'Welcome to Zoe!',
  description: (
    plainText: 'Welcome to Zoe - your intelligent personal workspace!',
    htmlText: '<p>Welcome to Zoe - your intelligent personal workspace!</p>',
  ),
  orderIndex: 1,
  createdBy: testUser,
);

final mockText2 = TextModel(
  id: textContent2,
  sheetId: 'sheet-1',
  parentId: 'sheet-1',
  title: 'Understanding Sheets',
  emoji: '📋',
  description: (
    plainText: 'Sheets are your main workspaces in Zoe',
    htmlText: '<p>Sheets are your main workspaces in Zoe</p>',
  ),
  orderIndex: 2,
  createdBy: testUser,
);
