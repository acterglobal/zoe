import 'package:zoe/features/events/models/events_model.dart';

final eventList = [
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'event-1',
    title: 'Team Meeting',
    orderIndex: 6,
    description: (
      plainText:
          'Weekly team sync to discuss project progress, upcoming deadlines, and coordinate tasks.',
      htmlText:
          '<p>Weekly team sync to discuss project progress, upcoming deadlines, and coordinate tasks.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 1, hours: 1)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'event-2',
    title: 'Product Demo',
    orderIndex: 7,
    description: (
      plainText:
          'Demo of new features to stakeholders and gather feedback for future improvements.',
      htmlText:
          '<p>Demo of new features to stakeholders and gather feedback for future improvements.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 2)),
    endDate: DateTime.now().add(const Duration(days: 2, hours: 2)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.no,
      'user_3': RsvpStatus.maybe,
      'user_4': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    id: 'event-3',
    title: 'Trip Date Confirmation Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s finalize our trip dates! We need to confirm the exact dates, check everyone\'s availability, and book flights before prices go up.',
      htmlText:
          '<p>Let\'s finalize our <strong>trip dates</strong>! We need to confirm the exact dates, check everyone\'s availability, and book flights before prices go up.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 3)),
    endDate: DateTime.now().add(const Duration(days: 3, hours: 1)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.maybe,
      'user_4': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    id: 'event-4',
    title: 'Christmas Date Confirmation Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s finalize our Christmas celebration date! We need to confirm the exact date, check everyone\'s availability, and plan the timeline for preparations.',
      htmlText:
          '<p>Let\'s finalize our <strong>Christmas celebration date</strong>! We need to confirm the exact date, check everyone\'s availability, and plan the timeline for preparations.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 2)),
    endDate: DateTime.now().add(const Duration(days: 2, hours: 1)),
    createdBy: 'user_2',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.maybe,
      'user_5': RsvpStatus.yes,
    },
  ),
];