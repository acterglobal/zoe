import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/list/models/list_model.dart';
import 'package:zoey/features/text/models/text_model.dart';

final contentList = [
  TextModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'text-content-1',
    title: 'Welcome to Zoey!',
    description: (
      plainText:
          'Zoey is your personal workspace for organizing thoughts, tasks, and ideas. This guide will help you understand all the features and get the most out of your experience.',
      htmlText:
          '<p>Zoey is your personal workspace for organizing thoughts, tasks, and ideas. This guide will help you understand all the features and get the most out of your experience.</p>',
    ),
  ),
  TextModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'text-content-2',
    title: 'How to Use Text Content',
    description: (
      plainText:
          'Text contents are the building contents of your sheets. Tap the + button to add new contents:\n\n• Text Contents: For notes, ideas, and documentation\n• Task Lists: For to-dos with descriptions and due dates\n• Event Contents: For scheduling with start and end dates\n• List Contents: For simple bullet points and collections\n\nYou can drag and drop contents to reorder them, and edit any text by tapping on it.',
      htmlText:
          '<p>Text contents are the building contents of your sheets. Tap the + button to add new contents:</p><ul><li>Text Contents: For notes, ideas, and documentation</li><li>Task Lists: For to-dos with descriptions and due dates</li><li>Event Contents: For scheduling with start and end dates</li><li>List Contents: For simple bullet points and collections</li></ul><p>You can drag and drop contents to reorder them, and edit any text by tapping on it.</p>',
    ),
  ),
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'events-1',
    title: 'Learning Schedule',
    description: (
      plainText: 'Learn about the latest trends in the industry',
      htmlText: '<p>Learn about the latest trends in the industry</p>',
    ),
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(minutes: 30)),
  ),
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'events-2',
    title: 'Meeting Schedule',
    description: (
      plainText: 'Learn about the latest trends in the industry',
      htmlText: '<p>Learn about the latest trends in the industry</p>',
    ),
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(minutes: 30)),
  ),
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'events-3',
    title: 'Practice Session',
    description: (
      plainText: 'Learn about the latest trends in the industry',
      htmlText: '<p>Learn about the latest trends in the industry</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 1)),
    endDate: DateTime.now().add(const Duration(hours: 2)),
  ),
  ListModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'list-bulleted-1',
    title: 'Key Features Overview',
    listType: ListType.bulleted,
  ),
  ListModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'list-tasks-1',
    title: 'Quick Start Checklist',
    listType: ListType.task,
  ),
  ListModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'list-bulleted-2',
    title: 'Pro Tips',
    listType: ListType.bulleted,
  ),
];
