import 'package:zoey/features/contents/events/models/events_content_model.dart';

final eventsContentList = [
  EventsContentModel(
    parentId: 'sheet-1',
    id: 'events-list-1',
    title: 'Learning Schedule',
    events: [
      EventItem(
        title: 'Explore Getting Started Guide',
        description: 'Read through this guide and try the features',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(minutes: 30)),
      ),
      EventItem(
        title: 'Practice Session',
        description: 'Create your first custom sheet and add content',
        startDate: DateTime.now().add(const Duration(hours: 1)),
        endDate: DateTime.now().add(const Duration(hours: 2)),
      ),
      EventItem(
        title: 'Team Review Meeting',
        description: 'Review progress and discuss next steps',
        startDate: DateTime.now().add(const Duration(days: 1, hours: 10)),
        endDate: DateTime.now().add(const Duration(days: 1, hours: 11)),
      ),
    ],
  ),
  EventsContentModel(
    parentId: 'sheet-1',
    id: 'events-list-2',
    title: 'Meeting Schedule',
    events: [
      EventItem(
        title: 'Daily Standup',
        description: 'Review progress and discuss next steps',
        startDate: DateTime.now().add(const Duration(days: 1, hours: 10)),
        endDate: DateTime.now().add(const Duration(days: 1, hours: 11)),
      ),
      EventItem(
        title: 'Team Review Meeting',
        description: 'Review progress and discuss next steps',
        startDate: DateTime.now().add(const Duration(days: 1, hours: 10)),
        endDate: DateTime.now().add(const Duration(days: 1, hours: 11)),
      ),
    ],
  ),
];
