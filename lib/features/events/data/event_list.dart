import 'package:Zoe/features/events/models/events_model.dart';

final eventList = [
  // Getting Started Guide (sheet-1) events
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
    createdBy: 'user_1',
    rsvpResponses: {  
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
    },
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
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
    },
  ),

  // Community Organization (sheet-2) events
  EventModel(
    sheetId: 'sheet-2',
    parentId: 'list-events-community-1',
    id: 'event-community-1',
    title: 'Saturday Game vs. Lightning Bolts',
    orderIndex: 1,
    description: (
      plainText:
          'Home game at Lincoln Elementary field. Arrive 30 minutes early for warm-up. Snacks provided by volunteer parents.',
      htmlText:
          '<p>Home game at Lincoln Elementary field. Arrive 30 minutes early for warm-up. Snacks provided by volunteer parents.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 2)),
    endDate: DateTime.now().add(const Duration(days: 2, hours: 2)),
    createdBy: 'user_3',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.no,
      'user_3': RsvpStatus.maybe,
      'user_4': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-2',
    parentId: 'list-events-community-1',
    id: 'event-community-2',
    title: 'Weekly Practice',
    orderIndex: 2,
    description: (
      plainText:
          'Regular team practice at Riverside Park. Focus on passing drills and scrimmage play. Bring water bottles and shin guards.',
      htmlText:
          '<p>Regular team practice at Riverside Park. Focus on passing drills and scrimmage play. Bring water bottles and shin guards.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 5)),
    endDate: DateTime.now().add(const Duration(days: 5, hours: 1, minutes: 30)),
    createdBy: 'user_4',
    rsvpResponses: {
      'user_1': RsvpStatus.no,
      'user_2': RsvpStatus.no,
      'user_3': RsvpStatus.maybe,
      'user_4': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-2',
    parentId: 'list-events-community-1',
    id: 'event-community-3',
    title: 'Parent Meeting - Season Planning',
    orderIndex: 3,
    description: (
      plainText:
          'Discuss end-of-season party, tournament schedules, and volunteer coordination for remaining games.',
      htmlText:
          '<p>Discuss end-of-season party, tournament schedules, and volunteer coordination for remaining games.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 7)),
    endDate: DateTime.now().add(const Duration(days: 7, hours: 1)),
    createdBy: 'user_5',
    rsvpResponses: {},
  ),
  EventModel(
    sheetId: 'sheet-2',
    parentId: 'list-events-community-1',
    id: 'event-community-4',
    title: 'Equipment Check & Distribution',
    orderIndex: 4,
    description: (
      plainText:
          'Annual equipment inspection and distribution of new uniforms. Parents should bring any damaged equipment for replacement.',
      htmlText:
          '<p>Annual equipment inspection and distribution of new uniforms. Parents should bring any damaged equipment for replacement.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 14)),
    endDate: DateTime.now().add(const Duration(days: 14, hours: 2)),
    createdBy: 'user_2',
    rsvpResponses: {},
  ),

  // Group Trip Planning (sheet-8) events
  EventModel(
    sheetId: 'sheet-8',
    parentId: 'list-events-trip-1',
    id: 'event-trip-1',
    title: 'Flight Booking Deadline',
    orderIndex: 1,
    description: (
      plainText:
          'Final deadline to book group flights to Tokyo. Jake is coordinating group discounts - confirm your participation by this date.',
      htmlText:
          '<p>Final deadline to book group flights to Tokyo. Jake is coordinating group discounts - confirm your participation by this date.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 14)),
    endDate: DateTime.now().add(const Duration(days: 14, hours: 1)),
    createdBy: 'user_6',
    rsvpResponses: {},
  ),
  EventModel(
    sheetId: 'sheet-8',
    parentId: 'list-events-trip-1',
    id: 'event-trip-2',
    title: 'Pre-Trip Planning Meeting',
    orderIndex: 2,
    description: (
      plainText:
          'Final coordination meeting to review itinerary, confirm accommodations, and discuss travel day logistics.',
      htmlText:
          '<p>Final coordination meeting to review itinerary, confirm accommodations, and discuss travel day logistics.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 21)),
    endDate: DateTime.now().add(const Duration(days: 21, hours: 2)),
    createdBy: 'user_7',
    rsvpResponses: {},
  ),
  EventModel(
    sheetId: 'sheet-8',
    parentId: 'list-events-trip-1',
    id: 'event-trip-3',
    title: 'Travel Day - Departure',
    orderIndex: 3,
    description: (
      plainText:
          'Group departure to Tokyo! Meet at airport 3 hours before international flight. Bring passports, tickets, and excitement!',
      htmlText:
          '<p>Group departure to Tokyo! Meet at airport 3 hours before international flight. Bring passports, tickets, and excitement!</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 45)),
    endDate: DateTime.now().add(const Duration(days: 45, hours: 18)),
    createdBy: 'user_8',
    rsvpResponses: {},
  ),
  EventModel(
    sheetId: 'sheet-8',
    parentId: 'list-events-trip-1',
    id: 'event-trip-4',
    title: 'Tokyo Cherry Blossom Festival',
    orderIndex: 4,
    description: (
      plainText:
          'Experience peak cherry blossom season in Tokyo parks. Perfect timing for hanami parties and incredible photos.',
      htmlText:
          '<p>Experience peak cherry blossom season in Tokyo parks. Perfect timing for hanami parties and incredible photos.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 47)),
    endDate: DateTime.now().add(const Duration(days: 47, hours: 8)),
    createdBy: 'user_9',
    rsvpResponses: {},
  ),
  EventModel(
    sheetId: 'sheet-8',
    parentId: 'list-events-trip-1',
    id: 'event-trip-5',
    title: 'Kyoto Temple Tour',
    orderIndex: 5,
    description: (
      plainText:
          'Guided tour of historic temples in Kyoto including Fushimi Inari and Kinkaku-ji. Transportation via JR Rail Pass.',
      htmlText:
          '<p>Guided tour of historic temples in Kyoto including Fushimi Inari and Kinkaku-ji. Transportation via JR Rail Pass.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 49)),
    endDate: DateTime.now().add(const Duration(days: 49, hours: 6)),
    createdBy: 'user_10',
    rsvpResponses: {},
  ),
  EventModel(
    sheetId: 'sheet-8',
    parentId: 'list-events-trip-1',
    id: 'event-trip-6',
    title: 'Group Farewell Dinner',
    orderIndex: 6,
    description: (
      plainText:
          'Traditional kaiseki dinner at acclaimed Tokyo restaurant. Celebration of amazing trip and lifelong memories made.',
      htmlText:
          '<p>Traditional kaiseki dinner at acclaimed Tokyo restaurant. Celebration of amazing trip and lifelong memories made.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 51)),
    endDate: DateTime.now().add(const Duration(days: 51, hours: 3)),
    createdBy: 'user_2',
    rsvpResponses: {},
  ),
];
