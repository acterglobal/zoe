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
  EventModel(
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    id: 'event-5',
    title: 'Digital Cleanup & Organization Session',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s tackle our digital mess together! We\'ll organize photos, clean up chat history, and create a system to keep important details accessible. Bring your devices and let\'s make digital life manageable!',
      htmlText:
          '<p>Let\'s tackle our <strong>digital mess together</strong>! We\'ll organize photos, clean up chat history, and create a system to keep important details accessible. Bring your devices and let\'s make digital life manageable!</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 1, hours: 3)),
    createdBy: 'user_3',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.yes,
      'user_5': RsvpStatus.maybe,
      'user_6': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    id: 'event-6',
    title: 'Community Coordination & Strategy Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s get our community organized! We\'ll consolidate all our scattered tools, create a system to track important clients, and ensure we never miss another important meeting or opportunity.',
      htmlText:
          '<p>Let\'s get our <strong>community organized</strong>! We\'ll consolidate all our scattered tools, create a system to track important clients, and ensure we never miss another important meeting or opportunity.</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 4)),
    endDate: DateTime.now().add(const Duration(hours: 6)),
    createdBy: 'user_4',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.yes,
      'user_5': RsvpStatus.yes,
      'user_6': RsvpStatus.maybe,
      'user_7': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-6',
    parentId: 'sheet-6',
    id: 'event-7',
    title: 'Group Chat Decision Making Session',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s put an end to endless "Friday or Sunday?" debates! We\'ll use polls to make quick decisions, organize who\'s coming, and create a system to avoid future chat chaos.',
      htmlText:
          '<p>Let\'s put an end to endless <strong>"Friday or Sunday?" debates</strong>! We\'ll use polls to make quick decisions, organize who\'s coming, and create a system to avoid future chat chaos.</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 2)),
    endDate: DateTime.now().add(const Duration(hours: 3)),
    createdBy: 'user_2',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.maybe,
      'user_5': RsvpStatus.yes,
      'user_6': RsvpStatus.yes,
      'user_7': RsvpStatus.maybe,
      'user_8': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-7',
    parentId: 'sheet-7',
    id: 'event-8',
    title: 'Exhibition Planning Coordination Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s organize this exhibition properly! We\'ll consolidate all scattered tools, create a system for food stalls, guest lists, and stage management. No more panic and confusion!',
      htmlText:
          '<p>Let\'s organize this <strong>exhibition properly</strong>! We\'ll consolidate all scattered tools, create a system for food stalls, guest lists, and stage management. No more panic and confusion!</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 6)),
    endDate: DateTime.now().add(const Duration(hours: 8)),
    createdBy: 'user_3',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.yes,
      'user_5': RsvpStatus.maybe,
      'user_6': RsvpStatus.yes,
      'user_7': RsvpStatus.yes,
      'user_8': RsvpStatus.maybe,
      'user_9': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-8',
    parentId: 'sheet-8',
    id: 'event-9',
    title: 'School Fundraiser Coordination Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s organize this fundraiser properly! We\'ll consolidate all the scattered cupcakes, ticket lists, volunteer signups, and calendar chaos. No more "Who\'s bringing cookies?" confusion!',
      htmlText:
          '<p>Let\'s organize this <strong>fundraiser properly</strong>! We\'ll consolidate all the scattered cupcakes, ticket lists, volunteer signups, and calendar chaos. No more "Who\'s bringing cookies?" confusion!</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 4)),
    endDate: DateTime.now().add(const Duration(hours: 6)),
    createdBy: 'user_4',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.yes,
      'user_5': RsvpStatus.yes,
      'user_6': RsvpStatus.maybe,
      'user_7': RsvpStatus.yes,
      'user_8': RsvpStatus.yes,
      'user_9': RsvpStatus.maybe,
      'user_10': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-9',
    parentId: 'sheet-9',
    id: 'event-10',
    title: 'BBQ Planning Coordination Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s organize this BBQ properly! We\'ll consolidate all the scattered messages, coordinate who\'s bringing what, handle dietary restrictions, and set a clear meeting time. No more endless group chat confusion!',
      htmlText:
          '<p>Let\'s organize this <strong>BBQ properly</strong>! We\'ll consolidate all the scattered messages, coordinate who\'s bringing what, handle dietary restrictions, and set a clear meeting time. No more endless group chat confusion!</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 3)),
    endDate: DateTime.now().add(const Duration(hours: 5)),
    createdBy: 'user_5',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.yes,
      'user_5': RsvpStatus.yes,
      'user_6': RsvpStatus.yes,
      'user_7': RsvpStatus.maybe,
      'user_8': RsvpStatus.yes,
      'user_9': RsvpStatus.yes,
      'user_10': RsvpStatus.maybe,
      'user_11': RsvpStatus.yes,
    },
  ),
];