import 'package:zoey/features/events/models/events_content_model.dart';

final eventsBlockList = [
  EventBlockModel(
    sheetId: 'sheet-1',
    title: 'Learning Schedule',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(minutes: 30)),
  ),
  EventBlockModel(
    sheetId: 'sheet-1',
    title: 'Meeting Schedule',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(minutes: 30)),
  ),
  EventBlockModel(
    sheetId: 'sheet-1',
    title: 'Practice Session',
    startDate: DateTime.now().add(const Duration(hours: 1)),
    endDate: DateTime.now().add(const Duration(hours: 2)),
  ),
  EventBlockModel(
    sheetId: 'sheet-1',
    title: 'Team Review Meeting',
    startDate: DateTime.now().add(const Duration(days: 1, hours: 10)),
    endDate: DateTime.now().add(const Duration(days: 1, hours: 11)),
  ),
  EventBlockModel(
    sheetId: 'sheet-1',
    title: 'Daily Standup',
    startDate: DateTime.now().add(const Duration(days: 1, hours: 10)),
    endDate: DateTime.now().add(const Duration(days: 1, hours: 11)),
  ),
];
