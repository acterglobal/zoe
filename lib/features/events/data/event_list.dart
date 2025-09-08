import 'package:zoe/features/events/models/events_model.dart';

final eventList = [
  
  // Getting Started Guide Events
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

  // Mobile App Development Events
  EventModel(
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    id: 'event-app-1',
    title: 'Sprint Planning Meeting',
    orderIndex: 1,
    description: (
      plainText:
          'Plan upcoming sprint tasks, review backlog, and assign priorities for the next two weeks.',
      htmlText:
          '<p>Plan upcoming sprint tasks, review backlog, and assign priorities for the next two weeks.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 1)),
    endDate: DateTime.now().add(const Duration(days: 1, hours: 2)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    id: 'event-app-2',
    title: 'UI/UX Design Review',
    orderIndex: 2,
    description: (
      plainText:
          'Review latest design mockups, discuss user feedback, and plan next iteration of the interface.',
      htmlText:
          '<p>Review latest design mockups, discuss user feedback, and plan next iteration of the interface.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 3)),
    endDate: DateTime.now().add(const Duration(days: 3, hours: 1)),
    createdBy: 'user_2',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
    },
  ),

  // Community Garden Events
  EventModel(
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    id: 'event-garden-1',
    title: 'Spring Planting Day',
    orderIndex: 1,
    description: (
      plainText:
          'Community gathering to plant spring vegetables and flowers. Bring your gardening tools and enthusiasm!',
      htmlText:
          '<p>Community gathering to plant spring vegetables and flowers. Bring your gardening tools and enthusiasm!</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 5)),
    endDate: DateTime.now().add(const Duration(days: 5, hours: 4)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.maybe,
    },
  ),
  EventModel(
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    id: 'event-garden-2',
    title: 'Garden Education Workshop',
    orderIndex: 2,
    description: (
      plainText:
          'Learn about sustainable gardening practices, composting, and natural pest control methods.',
      htmlText:
          '<p>Learn about sustainable gardening practices, composting, and natural pest control methods.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 7)),
    endDate: DateTime.now().add(const Duration(days: 7, hours: 2)),
    createdBy: 'user_2',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
    },
  ),

  // Wedding Planning Events
  EventModel(
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    id: 'event-wedding-1',
    title: 'Venue Tour - Crystal Gardens',
    orderIndex: 1,
    description: (
      plainText:
          'Tour of potential wedding venue. Meeting with venue coordinator to discuss packages, pricing, and available dates.',
      htmlText:
          '<p>Tour of potential wedding venue. Meeting with venue coordinator to discuss packages, pricing, and available dates.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 7)),
    endDate: DateTime.now().add(const Duration(days: 7, hours: 2)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    id: 'event-wedding-2',
    title: 'Wedding Dress Shopping',
    orderIndex: 2,
    description: (
      plainText:
          'Bridal boutique appointment. Trying on wedding dresses with bridesmaids. Appointment at Elegant Bridal.',
      htmlText:
          '<p>Bridal boutique appointment. Trying on wedding dresses with bridesmaids. Appointment at Elegant Bridal.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 14)),
    endDate: DateTime.now().add(const Duration(days: 14, hours: 3)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    id: 'event-wedding-3',
    title: 'Catering Tasting',
    orderIndex: 3,
    description: (
      plainText:
          'Menu tasting session with Gourmet Caterers. Sample potential wedding menu items and discuss service options.',
      htmlText:
          '<p>Menu tasting session with Gourmet Caterers. Sample potential wedding menu items and discuss service options.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 21)),
    endDate: DateTime.now().add(const Duration(days: 21, hours: 2)),
    createdBy: 'user_2',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
    },
  ),

  // Fitness Journey Events
  EventModel(
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    id: 'event-fitness-1',
    title: 'Personal Training Session',
    orderIndex: 1,
    description: (
      plainText:
          'One-on-one training session with Coach Mike. Focus on form correction and establishing baseline measurements.',
      htmlText:
          '<p>One-on-one training session with Coach Mike. Focus on form correction and establishing baseline measurements.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 3)),
    endDate: DateTime.now().add(const Duration(days: 3, hours: 1)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    id: 'event-fitness-2',
    title: 'Group HIIT Class',
    orderIndex: 2,
    description: (
      plainText:
          'High-intensity interval training class. Cardio and strength combination for maximum calorie burn.',
      htmlText:
          '<p>High-intensity interval training class. Cardio and strength combination for maximum calorie burn.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 5)),
    endDate: DateTime.now().add(const Duration(days: 5, minutes: 45)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.maybe,
      'user_3': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    id: 'event-fitness-3',
    title: 'Monthly Progress Check',
    orderIndex: 3,
    description: (
      plainText:
          'Monthly fitness assessment with trainer. Measure progress, adjust goals, and update training program as needed.',
      htmlText:
          '<p>Monthly fitness assessment with trainer. Measure progress, adjust goals, and update training program as needed.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 30)),
    endDate: DateTime.now().add(const Duration(days: 30, minutes: 30)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
    },
  ),

 // Home Renovation Events
  EventModel(
    sheetId: 'sheet-6',
    parentId: 'sheet-6',
    id: 'event-renovation-1',
    title: 'Kitchen Design Consultation',
    orderIndex: 1,
    description: (
      plainText:
          'Meeting with kitchen designer to finalize layout, materials, and appliance selections.',
      htmlText:
          '<p>Meeting with kitchen designer to finalize layout, materials, and appliance selections.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 5)),
    endDate: DateTime.now().add(const Duration(days: 5, hours: 2)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
    },
  ),
  EventModel(
    sheetId: 'sheet-6',
    parentId: 'sheet-6',
    id: 'event-renovation-2',
    title: 'Contractor Interview - ABC Construction',
    orderIndex: 2,
    description: (
      plainText:
          'Initial meeting with contractor to discuss project scope, timeline, and get detailed quote.',
      htmlText:
          '<p>Initial meeting with contractor to discuss project scope, timeline, and get detailed quote.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 7)),
    endDate: DateTime.now().add(const Duration(days: 7, hours: 1)),
    createdBy: 'user_1',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
      'user_3': RsvpStatus.maybe,
    },
  ),
  EventModel(
    sheetId: 'sheet-6',
    parentId: 'sheet-6',
    id: 'event-renovation-3',
    title: 'Pre-Construction Meeting',
    orderIndex: 3,
    description: (
      plainText:
          'Final planning meeting with chosen contractor. Review timeline, permits, and logistics.',
      htmlText:
          '<p>Final planning meeting with chosen contractor. Review timeline, permits, and logistics.</p>',
    ),
    startDate: DateTime.now().add(const Duration(days: 14)),
    endDate: DateTime.now().add(const Duration(days: 14, hours: 2)),
    createdBy: 'user_2',
    rsvpResponses: {
      'user_1': RsvpStatus.yes,
      'user_2': RsvpStatus.yes,
    },
  ),

];