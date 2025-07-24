import 'package:zoey/features/events/models/events_model.dart';

final eventList = [
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'list-events-1',
    id: 'event-1',
    title: 'Team Meeting',
    orderIndex: 1,
    description: (
      plainText:
          'Weekly team sync to discuss project progress, upcoming deadlines, and coordinate tasks.',
      htmlText:
          '<p>Weekly team sync to discuss project progress, upcoming deadlines, and coordinate tasks.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 1, hours: 1)),
  ),
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'list-events-1',
    id: 'event-2',
    title: 'Product Demo',
    orderIndex: 2,
    description: (
      plainText:
          'Demo of new features to stakeholders and gather feedback for future improvements.',
      htmlText:
          '<p>Demo of new features to stakeholders and gather feedback for future improvements.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 2)),
    endDate: DateTime.now().add(const Duration(days: 2, hours: 2)),
  ),
];
