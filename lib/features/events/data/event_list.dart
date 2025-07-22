import 'package:zoey/features/events/models/events_model.dart';

final eventList = [
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
];
