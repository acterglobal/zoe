import 'package:zoey/features/events/models/events_model.dart';

final eventsList = [
  EventModel(
    sheetId: 'sheet-1',
    id: 'events-1',
    title: 'Learning Schedule',
    plainTextDescription: 'Learn about the latest trends in the industry',
    htmlDescription: '<p>Learn about the latest trends in the industry</p>',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(minutes: 30)),
  ),
  EventModel(
    sheetId: 'sheet-1',
    id: 'events-2',
    title: 'Meeting Schedule',
    plainTextDescription: 'Learn about the latest trends in the industry',
    htmlDescription: '<p>Learn about the latest trends in the industry</p>',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(minutes: 30)),
  ),
  EventModel(
    sheetId: 'sheet-1',
    id: 'events-3',
    title: 'Practice Session',
    plainTextDescription: 'Learn about the latest trends in the industry',
    htmlDescription: '<p>Learn about the latest trends in the industry</p>',
    startDate: DateTime.now().add(const Duration(hours: 1)),
    endDate: DateTime.now().add(const Duration(hours: 2)),
  ),
];
