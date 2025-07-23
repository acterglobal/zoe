import 'package:zoey/features/events/models/events_model.dart';

final eventList = [
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'events-1',
    title: 'Complete Zoey Onboarding',
    orderIndex: 6,
    description: (
      plainText:
          'Dedicated time to work through this Getting Started Guide and familiarize yourself with all of Zoey\'s features. Take your time to explore and experiment!',
      htmlText:
          '<p>Dedicated time to work through this Getting Started Guide and familiarize yourself with all of Zoey\'s features. Take your time to explore and experiment!</p>',
    ),
    startDate: DateTime.now().add(const Duration(minutes: 5)),
    endDate: DateTime.now().add(const Duration(minutes: 45)),
  ),
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'events-2',
    title: 'Create Your First Custom Sheet',
    orderIndex: 10,
    description: (
      plainText:
          'Block time to create your first personal sheet in Zoey. Think about a current project or goal you\'re working on and set up a workspace for it.',
      htmlText:
          '<p>Block time to create your first personal sheet in Zoey. Think about a current project or goal you\'re working on and set up a workspace for it.</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 2)),
    endDate: DateTime.now().add(const Duration(hours: 2, minutes: 30)),
  ),
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'events-3',
    title: 'Weekly Zoey Review & Planning',
    orderIndex: 11,
    description: (
      plainText:
          'Schedule regular time to review your sheets, update tasks, and plan ahead. This helps you stay organized and make the most of your Zoey workspace.',
      htmlText:
          '<p>Schedule regular time to review your sheets, update tasks, and plan ahead. This helps you stay organized and make the most of your Zoey workspace.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 7)),
    endDate: DateTime.now().add(const Duration(days: 7, minutes: 30)),
  ),
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'events-4',
    title: 'Explore Advanced Features',
    orderIndex: 12,
    description: (
      plainText:
          'Time to dive deeper into Zoey\'s capabilities. Experiment with different content arrangements, try various organization strategies, and discover what works best for you.',
      htmlText:
          '<p>Time to dive deeper into Zoey\'s capabilities. Experiment with different content arrangements, try various organization strategies, and discover what works best for you.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 3)),
    endDate: DateTime.now().add(const Duration(days: 3, minutes: 45)),
  ),
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'list-events-1',
    id: 'events-5',
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
    id: 'events-6',
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
