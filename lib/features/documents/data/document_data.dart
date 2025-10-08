import 'package:zoe/features/documents/models/document_model.dart';

final documentList = [
  DocumentModel(
    id: 'document-1',
    title: 'Project Proposal',
    parentId: 'list-document-1',
    sheetId: 'sheet-1',
    filePath: 'path/to/project_proposal.pdf',
  ),
  DocumentModel(
    id: 'document-2',
    title: 'Meeting Notes',
    parentId: 'list-document-1',
    sheetId: 'sheet-1',
    filePath: 'path/to/meeting_notes.docx',
  ),
  DocumentModel(
    id: 'document-3',
    title: 'Budget Spreadsheet',
    parentId: 'list-document-1',
    sheetId: 'sheet-1',
    filePath: 'path/to/budget.xlsx',
  ),
  DocumentModel(
    id: 'document-4',
    title: 'Design Mockups',
    parentId: 'list-document-2',
    sheetId: 'sheet-1',
    filePath: 'path/to/design_mockups.png',
  ),
  // Trip Planning Documents
  DocumentModel(
    id: 'document-5',
    title: 'Trip Itinerary',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/trip_itinerary.pdf',
  ),
  DocumentModel(
    id: 'document-6',
    title: 'Hotel Booking Confirmation',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/hotel_confirmation.pdf',
  ),
  DocumentModel(
    id: 'document-7',
    title: 'Flight Tickets',
    parentId: 'list-document-2',
    sheetId: 'sheet-2',
    filePath: 'path/to/flight_tickets.pdf',
  ),
  // Christmas Planning Documents
  DocumentModel(
    id: 'document-11',
    title: 'Christmas Party Guest List',
    parentId: 'list-document-3',
    sheetId: 'sheet-3',
    filePath: 'path/to/christmas_guest_list.xlsx',
  ),
  DocumentModel(
    id: 'document-12',
    title: 'Christmas Menu Plan',
    parentId: 'list-document-3',
    sheetId: 'sheet-3',
    filePath: 'path/to/christmas_menu.docx',
  ),
  DocumentModel(
    id: 'document-13',
    title: 'Secret Santa Assignments',
    parentId: 'list-document-3',
    sheetId: 'sheet-3',
    filePath: 'path/to/secret_santa_list.pdf',
  ),
  // Community Management Documents
  DocumentModel(
    id: 'document-23',
    title: 'VIP Client Database',
    parentId: 'list-document-5',
    sheetId: 'sheet-4',
    filePath: 'path/to/vip_client_database.xlsx',
  ),
  DocumentModel(
    id: 'document-24',
    title: 'Community Guidelines & Rules',
    parentId: 'list-document-5',
    sheetId: 'sheet-4',
    filePath: 'path/to/community_guidelines.pdf',
  ),
  DocumentModel(
    id: 'document-25',
    title: 'Notification Management System',
    parentId: 'list-document-5',
    sheetId: 'sheet-4',
    filePath: 'path/to/notification_system.docx',
  ),
  // Exhibition Planning Documents
  DocumentModel(
    id: 'document-35',
    title: 'Exhibition Master Checklist',
    parentId: 'list-document-7',
    sheetId: 'sheet-5',
    filePath: 'path/to/exhibition_checklist.pdf',
  ),
  DocumentModel(
    id: 'document-36',
    title: 'Food Stall Vendor List',
    parentId: 'list-document-7',
    sheetId: 'sheet-5',
    filePath: 'path/to/food_vendors.xlsx',
  ),
  DocumentModel(
    id: 'document-37',
    title: 'Guest List & RSVP Tracker',
    parentId: 'list-document-7',
    sheetId: 'sheet-5',
    filePath: 'path/to/guest_list.xlsx',
  ),
  // School Fundraiser Documents
  DocumentModel(
    id: 'document-41',
    title: 'Fundraiser Master Checklist',
    parentId: 'list-document-8',
    sheetId: 'sheet-6',
    filePath: 'path/to/fundraiser_checklist.pdf',
  ),
  DocumentModel(
    id: 'document-42',
    title: 'Cupcake Coordination List',
    parentId: 'list-document-8',
    sheetId: 'sheet-6',
    filePath: 'path/to/cupcake_list.xlsx',
  ),
  DocumentModel(
    id: 'document-43',
    title: 'Ticket Sales Tracker',
    parentId: 'list-document-8',
    sheetId: 'sheet-6',
    filePath: 'path/to/ticket_tracker.xlsx',
  ),
  // BBQ Planning Documents
  DocumentModel(
    id: 'document-47',
    title: 'BBQ Master Checklist',
    parentId: 'list-document-9',
    sheetId: 'sheet-7',
    filePath: 'path/to/bbq_checklist.pdf',
  ),
  DocumentModel(
    id: 'document-48',
    title: 'Food & Equipment Coordination List',
    parentId: 'list-document-9',
    sheetId: 'sheet-7',
    filePath: 'path/to/bbq_coordination.xlsx',
  ),
  DocumentModel(
    id: 'document-49',
    title: 'Dietary Restrictions & Allergies Tracker',
    parentId: 'list-document-9',
    sheetId: 'sheet-7',
    filePath: 'path/to/dietary_tracker.xlsx',
  ),
  // University Hangout Documents
  DocumentModel(
    id: 'document-53',
    title: 'University Hangout Master Checklist',
    parentId: 'list-document-10',
    sheetId: 'sheet-8',
    filePath: 'path/to/university_hangout_checklist.pdf',
  ),
  DocumentModel(
    id: 'document-54',
    title: 'Student Schedule Coordination Guide',
    parentId: 'list-document-10',
    sheetId: 'sheet-8',
    filePath: 'path/to/schedule_coordination.xlsx',
  ),
  DocumentModel(
    id: 'document-55',
    title: 'Campus Hangout Spots Directory',
    parentId: 'list-document-10',
    sheetId: 'sheet-8',
    filePath: 'path/to/campus_spots.xlsx',
  ),
  // Book Club Documents
  DocumentModel(
    id: 'document-59',
    title: 'Book Club Master Checklist',
    parentId: 'list-document-11',
    sheetId: 'sheet-9',
    filePath: 'path/to/bookclub_checklist.pdf',
  ),
  DocumentModel(
    id: 'document-60',
    title: 'Monthly Meeting Schedule & Hosting Rotation',
    parentId: 'list-document-11',
    sheetId: 'sheet-9',
    filePath: 'path/to/meeting_schedule.xlsx',
  ),
  DocumentModel(
    id: 'document-61',
    title: 'Book Selection & Reading List',
    parentId: 'list-document-11',
    sheetId: 'sheet-9',
    filePath: 'path/to/reading_list.xlsx',
  ),
  // Softball Club BBQ Party Documents
  DocumentModel(
    id: 'document-65',
    title: 'Softball Club BBQ Party Master Checklist',
    parentId: 'list-document-12',
    sheetId: 'sheet-10',
    filePath: 'path/to/softball_bbq_checklist.pdf',
  ),
  DocumentModel(
    id: 'document-66',
    title: 'Date Coordination & Availability Tracker',
    parentId: 'list-document-12',
    sheetId: 'sheet-10',
    filePath: 'path/to/date_coordination.xlsx',
  ),
  DocumentModel(
    id: 'document-67',
    title: 'BBQ Party Menu & Equipment List',
    parentId: 'list-document-12',
    sheetId: 'sheet-10',
    filePath: 'path/to/bbq_menu.xlsx',
  ),
  // Bachelorette Party Documents
  DocumentModel(
    id: 'document-71',
    title: 'Bachelorette Party Master Checklist',
    parentId: 'list-document-13',
    sheetId: 'sheet-11',
    filePath: 'path/to/bachelorette_checklist.pdf',
  ),
  DocumentModel(
    id: 'document-72',
    title: 'Budget Planning & Cost Breakdown',
    parentId: 'list-document-13',
    sheetId: 'sheet-11',
    filePath: 'path/to/budget_planning.xlsx',
  ),
  DocumentModel(
    id: 'document-73',
    title: 'Theme & Activity Planning Guide',
    parentId: 'list-document-13',
    sheetId: 'sheet-11',
    filePath: 'path/to/theme_planning.xlsx',
  ),
  // Church Summer Fest 2026 Documents
  DocumentModel(
    id: 'document-74',
    title: 'Church Summer Fest 2026 Master Checklist',
    parentId: 'list-document-14',
    sheetId: 'sheet-12',
    filePath: 'path/to/church_fest_checklist.pdf',
  ),
  DocumentModel(
    id: 'document-75',
    title: 'Food Coordination & Budget Planning',
    parentId: 'list-document-14',
    sheetId: 'sheet-12',
    filePath: 'path/to/food_budget_planning.xlsx',
  ),
  DocumentModel(
    id: 'document-76',
    title: 'Equipment & Setup Coordination Guide',
    parentId: 'list-document-14',
    sheetId: 'sheet-12',
    filePath: 'path/to/equipment_setup_guide.xlsx',
  ),
  // PTA Bake Sale Documents
  DocumentModel(
    id: 'document-77',
    sheetId: 'sheet-13',
    parentId: 'list-document-15',
    title: 'PTA Bake Sale Planning Guide',
    orderIndex: 1,
    description: (
      plainText:
          'Complete guide for organizing PTA bake sale planning, coordinating baking assignments, and managing dietary restrictions.',
      htmlText:
          '<p>Complete guide for <strong>organizing PTA bake sale planning</strong>, coordinating baking assignments, and managing dietary restrictions.</p>',
    ),
    filePath: '/documents/pta-bake-sale-planning-guide.pdf',
    createdBy: 'user_1',
  ),
  DocumentModel(
    id: 'document-78',
    sheetId: 'sheet-13',
    parentId: 'list-document-15',
    title: 'Baking Assignment Coordination Template',
    orderIndex: 2,
    description: (
      plainText:
          'Template for organizing baking assignments and coordinating who brings what. No more "who brings brownies? I will do cupcakes" chaos!',
      htmlText:
          '<p>Template for <strong>organizing baking assignments and coordinating who brings what</strong>. No more "who brings brownies? I will do cupcakes" chaos!</p>',
    ),
    filePath: '/documents/baking-assignment-coordination-template.xlsx',
    createdBy: 'user_2',
  ),
  DocumentModel(
    id: 'document-79',
    sheetId: 'sheet-13',
    parentId: 'list-document-15',
    title: 'PTA Budget Planning Worksheet',
    orderIndex: 3,
    description: (
      plainText:
          'Worksheet for creating clear budget planning and payment coordination. No more "budget again? who pays? nobody really knows" confusion!',
      htmlText:
          '<p>Worksheet for <strong>creating clear budget planning and payment coordination</strong>. No more "budget again? who pays? nobody really knows" confusion!</p>',
    ),
    filePath: '/documents/pta-budget-planning-worksheet.xlsx',
    createdBy: 'user_3',
  ),
  // Halloween Planning Documents
  DocumentModel(
    id: 'document-80',
    sheetId: 'sheet-14',
    parentId: 'list-document-16',
    title: 'Halloween Planning Guide',
    orderIndex: 1,
    description: (
      plainText:
          'Complete guide for organizing Halloween planning, coordinating meeting locations, and managing group communication.',
      htmlText:
          '<p>Complete guide for <strong>organizing Halloween planning</strong>, coordinating meeting locations, and managing group communication.</p>',
    ),
    filePath: '/documents/halloween-planning-guide.pdf',
    createdBy: 'user_1',
  ),
  DocumentModel(
    id: 'document-81',
    sheetId: 'sheet-14',
    parentId: 'list-document-16',
    title: 'Location Coordination & Maps Template',
    orderIndex: 2,
    description: (
      plainText:
          'Template for organizing meeting locations and providing clear directions. No more "wrong street, nobody on the same place" confusion!',
      htmlText:
          '<p>Template for <strong>organizing meeting locations and providing clear directions</strong>. No more "wrong street, nobody on the same place" confusion!</p>',
    ),
    filePath: '/documents/location-coordination-maps-template.xlsx',
    createdBy: 'user_2',
  ),
  DocumentModel(
    id: 'document-82',
    sheetId: 'sheet-14',
    parentId: 'list-document-16',
    title: 'Halloween Event Coordination Worksheet',
    orderIndex: 3,
    description: (
      plainText:
          'Worksheet for creating clear house locations and meeting points. No more "wait which house again? Nobody is here" confusion!',
      htmlText:
          '<p>Worksheet for <strong>creating clear house locations and meeting points</strong>. No more "wait which house again? Nobody is here" confusion!</p>',
    ),
    filePath: '/documents/halloween-event-coordination-worksheet.xlsx',
    createdBy: 'user_3',
  ),
  // Summer Camp Sign-ups Documents
  DocumentModel(
    id: 'document-83',
    sheetId: 'sheet-15',
    parentId: 'list-document-17',
    title: 'Summer Camp Sign-ups Planning Guide',
    orderIndex: 1,
    description: (
      plainText:
          'Complete guide for organizing summer camp sign-ups, coordinating form submissions, and managing registration process.',
      htmlText:
          '<p>Complete guide for <strong>organizing summer camp sign-ups</strong>, coordinating form submissions, and managing registration process.</p>',
    ),
    filePath: '/documents/summer-camp-signups-planning-guide.pdf',
    createdBy: 'user_1',
  ),
  DocumentModel(
    id: 'document-84',
    sheetId: 'sheet-15',
    parentId: 'list-document-17',
    title: 'Form Submission & Registration Template',
    orderIndex: 2,
    description: (
      plainText:
          'Template for organizing form submissions and registration process. No more "did you fill the form? what\'s do when?" confusion!',
      htmlText:
          '<p>Template for <strong>organizing form submissions and registration process</strong>. No more "did you fill the form? what\'s do when?" confusion!</p>',
    ),
    filePath: '/documents/form-submission-registration-template.xlsx',
    createdBy: 'user_2',
  ),
  DocumentModel(
    id: 'document-85',
    sheetId: 'sheet-15',
    parentId: 'list-document-17',
    title: 'Summer Camp Equipment & Supplies Worksheet',
    orderIndex: 3,
    description: (
      plainText:
          'Worksheet for organizing equipment and supplies coordination. No more "snacks list? I can\'t find it, tents or not?" confusion!',
      htmlText:
          '<p>Worksheet for <strong>organizing equipment and supplies coordination</strong>. No more "snacks list? I can\'t find it, tents or not?" confusion!</p>',
    ),
    filePath: '/documents/summer-camp-equipment-supplies-worksheet.xlsx',
    createdBy: 'user_3',
  ),
  // Thanksgiving Planning Documents
  DocumentModel(
    id: 'document-86',
    sheetId: 'sheet-16',
    parentId: 'list-document-18',
    title: 'Thanksgiving Planning Guide',
    orderIndex: 1,
    description: (
      plainText:
          'Complete guide for organizing Thanksgiving planning, coordinating cooking assignments, and managing family communication.',
      htmlText:
          '<p>Complete guide for <strong>organizing Thanksgiving planning</strong>, coordinating cooking assignments, and managing family communication.</p>',
    ),
    filePath: '/documents/thanksgiving-planning-guide.pdf',
    createdBy: 'user_1',
  ),
  DocumentModel(
    id: 'document-87',
    sheetId: 'sheet-16',
    parentId: 'list-document-18',
    title: 'Cooking Assignment & Recipe Coordination Template',
    orderIndex: 2,
    description: (
      plainText:
          'Template for organizing cooking assignments and reducing endless stress. No more "weeks of cooking endless stress" - organize cooking tasks clearly!',
      htmlText:
          '<p>Template for <strong>organizing cooking assignments and reducing endless stress</strong>. No more "weeks of cooking endless stress" - organize cooking tasks clearly!</p>',
    ),
    filePath: '/documents/cooking-assignment-recipe-coordination-template.xlsx',
    createdBy: 'user_2',
  ),
  DocumentModel(
    id: 'document-88',
    sheetId: 'sheet-16',
    parentId: 'list-document-18',
    title: 'Thanksgiving Workload Distribution Worksheet',
    orderIndex: 3,
    description: (
      plainText:
          'Worksheet for preventing everything from falling on mom. No more "at end everything falls on mom" - organize balanced responsibilities!',
      htmlText:
          '<p>Worksheet for <strong>preventing everything from falling on mom</strong>. No more "at end everything falls on mom" - organize balanced responsibilities!</p>',
    ),
    filePath: '/documents/thanksgiving-workload-distribution-worksheet.xlsx',
    createdBy: 'user_3',
  ),
];