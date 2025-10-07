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
  EventModel(
    sheetId: 'sheet-10',
    parentId: 'sheet-10',
    id: 'event-11',
    title: 'University Hangout Coordination Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s organize our university hangouts properly! We\'ll coordinate different timetables, find the right places to meet, track who\'s actually coming, and create a system that works for everyone!',
      htmlText:
          '<p>Let\'s organize our <strong>university hangouts properly</strong>! We\'ll coordinate different timetables, find the right places to meet, track who\'s actually coming, and create a system that works for everyone!</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 2)).subtract(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(hours: 4)).subtract(const Duration(days: 1)),
    createdBy: 'user_6',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_5': RsvpStatus.yes,
      'user_6': RsvpStatus.yes,
      'user_7': RsvpStatus.maybe,
      'user_8': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-11',
    parentId: 'sheet-11',
    id: 'event-12',
    title: 'Book Club Planning Coordination Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s organize our book club properly! We\'ll coordinate monthly meetings, decide on hosting rotation, choose books together, and create a system that makes planning fun instead of stressful!',
      htmlText:
          '<p>Let\'s organize our <strong>book club properly</strong>! We\'ll coordinate monthly meetings, decide on hosting rotation, choose books together, and create a system that makes planning fun instead of stressful!</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 1)),
    endDate: DateTime.now().add(const Duration(hours: 3)),
    createdBy: 'user_7',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.maybe,
      'user_5': RsvpStatus.yes,
      'user_6': RsvpStatus.yes,
      'user_7': RsvpStatus.yes,
      'user_8': RsvpStatus.maybe,
    },
  ),
  EventModel(
    sheetId: 'sheet-12',
    parentId: 'sheet-12',
    id: 'event-13',
    title: 'Softball Club BBQ Party Coordination Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s organize our softball club BBQ party properly! We\'ll find a date that works for everyone, make clear decisions, and create a plan that actually happens! No more endless planning with no clarity!',
      htmlText:
          '<p>Let\'s organize our <strong>softball club BBQ party properly</strong>! We\'ll find a date that works for everyone, make clear decisions, and create a plan that actually happens! No more endless planning with no clarity!</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 30)),
    endDate: DateTime.now().add(const Duration(hours: 32)),
    createdBy: 'user_8',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.yes,
      'user_5': RsvpStatus.maybe,
      'user_6': RsvpStatus.yes,
      'user_7': RsvpStatus.yes,
      'user_8': RsvpStatus.yes,
      'user_9': RsvpStatus.maybe,
      'user_10': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-13',
    parentId: 'sheet-13',
    id: 'event-14',
    title: 'Bachelorette Party Planning Coordination Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s organize her bachelorette party properly! We\'ll stop the non-stop group chat buzzing, set a fixed budget and date, create a proper checklist, and make planning fun instead of stressful!',
      htmlText:
          '<p>Let\'s organize her <strong>bachelorette party properly</strong>! We\'ll stop the non-stop group chat buzzing, set a fixed budget and date, create a proper checklist, and make planning fun instead of stressful!</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 24)),
    endDate: DateTime.now().add(const Duration(hours: 26)),
    createdBy: 'user_9',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.maybe,
    },
  ),
  EventModel(
    sheetId: 'sheet-14',
    parentId: 'sheet-14',
    id: 'event-15',
    title: 'Church Summer Fest 2026 Planning Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s organize our church summer fest properly! We\'ll coordinate food planning, set clear budgets, find dates that work for everyone, and organize equipment setup. No more planning chaos!',
      htmlText:
          '<p>Let\'s organize our <strong>church summer fest properly</strong>! We\'ll coordinate food planning, set clear budgets, find dates that work for everyone, and organize equipment setup. No more planning chaos!</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 12)),
    endDate: DateTime.now().add(const Duration(hours: 14)),
    createdBy: 'user_10',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
      'user_4': RsvpStatus.yes,
      'user_5': RsvpStatus.maybe,
      'user_6': RsvpStatus.yes,
      'user_7': RsvpStatus.yes,
      'user_8': RsvpStatus.maybe,
    },
  ),
  EventModel(
    sheetId: 'sheet-15',
    parentId: 'sheet-15',
    id: 'event-16',
    title: 'PTA Bake Sale Planning Coordination Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s organize our PTA bake sale properly! We\'ll coordinate baking assignments, handle dietary restrictions, resolve scheduling conflicts, and create clear budget planning. No more group chat chaos!',
      htmlText:
          '<p>Let\'s organize our <strong>PTA bake sale properly</strong>! We\'ll coordinate baking assignments, handle dietary restrictions, resolve scheduling conflicts, and create clear budget planning. No more group chat chaos!</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 18)),
    endDate: DateTime.now().add(const Duration(hours: 20)),
    createdBy: 'user_11',
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
    sheetId: 'sheet-16',
    parentId: 'sheet-16',
    id: 'event-17',
    title: 'Halloween Planning Coordination Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Let\'s organize our Halloween planning properly! We\'ll coordinate meeting locations, handle scheduling conflicts, create clear communication, and ensure everyone knows where to meet. No more "wrong street, nobody is here" chaos!',
      htmlText:
          '<p>Let\'s organize our <strong>Halloween planning properly</strong>! We\'ll coordinate meeting locations, handle scheduling conflicts, create clear communication, and ensure everyone knows where to meet. No more "wrong street, nobody is here" chaos!</p>',
    ),
    startDate: DateTime.now().add(const Duration(hours: 20)),
    endDate: DateTime.now().add(const Duration(hours: 22)),
    createdBy: 'user_2',
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
      'user_10': RsvpStatus.yes,
    },
  ),
];