import 'package:zoe/features/task/models/task_model.dart';

final tasks = [
  TaskModel(
    id: 'task-1',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Read through this Getting Started Guide',
    orderIndex: 1,
    description: (
      plainText:
          'Take your time to understand Zoe\'s features and capabilities. This foundation will help you use the app more effectively.',
      htmlText:
          '<p>Take your time to understand Zoe\'s features and capabilities. This foundation will help you use the app more effectively.</p>',
    ),
    isCompleted: true,
    dueDate: DateTime.now().add(const Duration(minutes: 15)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2', 'user_3'],
  ),
  TaskModel(
    id: 'task-2',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Try editing some text in this guide',
    orderIndex: 2,
    description: (
      plainText:
          'Tap on any text block title or description to see how inline editing works. Don\'t worry - you can always change it back!',
      htmlText:
          '<p>Tap on any text block title or description to see how inline editing works. Don\'t worry - you can always change it back!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(minutes: 30)),
    createdBy: 'user_1',
    assignedUsers: [
      'user_2',
      'user_3',
      'user_4',
      'user_5',
      'user_6',
      'user_7',
      'user_8',
      'user_9',
      'user_10',
    ],
  ),
  TaskModel(
    id: 'task-3',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Mark a task as complete (like this one!)',
    orderIndex: 3,
    description: (
      plainText:
          'Tap the checkbox next to any task to mark it as done. Try it with this task to see how completion tracking works.',
      htmlText:
          '<p>Tap the checkbox next to any task to mark it as done. Try it with this task to see how completion tracking works.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(hours: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_2', 'user_3'],
  ),
  TaskModel(
    id: 'task-4',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Explore the home dashboard',
    orderIndex: 4,
    description: (
      plainText:
          'Go back to the home screen to see how sheets are displayed. Notice how this Getting Started Guide appears as a sheet tile.',
      htmlText:
          '<p>Go back to the home screen to see how sheets are displayed. Notice how this Getting Started Guide appears as a sheet tile.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(hours: 2)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2', 'user_3'],
  ),
  TaskModel(
    id: 'task-5',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Create your first custom sheet',
    orderIndex: 5,
    description: (
      plainText:
          'Use the + button to create a new sheet. Try making one for a personal project, hobby, or goal you\'re working on.',
      htmlText:
          '<p>Use the + button to create a new sheet. Try making one for a personal project, hobby, or goal you\'re working on.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(hours: 4)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3'],
  ),
  TaskModel(
    id: 'task-6',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Add content blocks to your new sheet',
    orderIndex: 6,
    description: (
      plainText:
          'Practice adding different types of content: text for notes, tasks for to-dos, events for scheduling, and lists for organizing ideas.',
      htmlText:
          '<p>Practice adding different types of content: text for notes, tasks for to-dos, events for scheduling, and lists for organizing ideas.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(hours: 6)),
    createdBy: 'user_2',
    assignedUsers: ['user_1', 'user_2'],
  ),
  TaskModel(
    id: 'task-7',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Customize your sheet with icons and descriptions',
    orderIndex: 7,
    description: (
      plainText:
          'Edit your new sheet to add a meaningful icon and description. This helps you identify and understand your sheets at a glance.',
      htmlText:
          '<p>Edit your new sheet to add a meaningful icon and description. This helps you identify and understand your sheets at a glance.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(hours: 8)),
    createdBy: 'user_3',
    assignedUsers: ['user_1'],
  ),
  TaskModel(
    id: 'task-8',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Explore the settings and preferences',
    orderIndex: 8,
    description: (
      plainText:
          'Check out the settings screen to see how you can customize your Zoe experience with themes and other preferences.',
      htmlText:
          '<p>Check out the settings screen to see how you can customize your Zoe experience with themes and other preferences.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1'],
  ),
  TaskModel(
    id: 'task-9',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Plan your next steps with Zoe',
    orderIndex: 9,
    description: (
      plainText:
          'Think about how you want to use Zoe in your daily life. Consider creating sheets for work projects, personal goals, or areas of interest.',
      htmlText:
          '<p>Think about how you want to use Zoe in your daily life. Consider creating sheets for work projects, personal goals, or areas of interest.</p>',
    ),
    isCompleted: true,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2', 'user_3'],
  ),
  // Trip Planning Tasks
  TaskModel(
    id: 'trip-task-1',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-2',
    title: 'Research local attractions and activities',
    orderIndex: 1,
    description: (
      plainText:
          'Find the best tourist spots, local experiences, and hidden gems in our chosen destination. Create a must-visit list.',
      htmlText:
          '<p>Find the best <strong>tourist spots</strong>, local experiences, and hidden gems in our chosen destination. Create a must-visit list.</p>',
    ),
    isCompleted: true,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_3'],
  ),
  TaskModel(
    id: 'trip-task-2',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-2',
    title: 'Book accommodation and check-in details',
    orderIndex: 2,
    description: (
      plainText:
          'Compare hotel options, read reviews, and make reservations. Get confirmation details and check-in instructions.',
      htmlText:
          '<p>Compare <strong>hotel options</strong>, read reviews, and make reservations. Get confirmation details and check-in instructions.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_4'],
  ),
  TaskModel(
    id: 'trip-task-3',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-2',
    title: 'Arrange transportation and travel documents',
    orderIndex: 3,
    description: (
      plainText:
          'Book flights, arrange airport transfers, and ensure all travel documents (passports, visas) are ready.',
      htmlText:
          '<p>Book <strong>flights</strong>, arrange airport transfers, and ensure all travel documents (passports, visas) are ready.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_3',
    assignedUsers: ['user_3'],
  ),
  TaskModel(
    id: 'trip-task-4',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-2',
    title: 'Plan daily schedule and restaurant reservations',
    orderIndex: 4,
    description: (
      plainText:
          'Create a detailed daily itinerary with activities, meal times, and make restaurant reservations for special dinners.',
      htmlText:
          '<p>Create a detailed <strong>daily itinerary</strong> with activities, meal times, and make restaurant reservations for special dinners.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 6)),
    createdBy: 'user_4',
    assignedUsers: ['user_1', 'user_2', 'user_3', 'user_4'],
  ),
  // Christmas Planning Tasks
  TaskModel(
    id: 'christmas-task-1',
    sheetId: 'sheet-3',
    parentId: 'list-tasks-3',
    title: 'Who\'s getting the cake?',
    orderIndex: 1,
    description: (
      plainText:
          'We need to decide who will handle the Christmas cake order. Check local bakeries, compare prices, and place the order in advance.',
      htmlText:
          '<p>We need to decide who will handle the <strong>Christmas cake order</strong>. Check local bakeries, compare prices, and place the order in advance.</p>',
    ),
    isCompleted: true,
    dueDate: DateTime.now().add(const Duration(days: 7)),
    createdBy: 'user_3',
    assignedUsers: ['user_3', 'user_5'],
  ),
  TaskModel(
    id: 'christmas-task-2',
    sheetId: 'sheet-3',
    parentId: 'list-tasks-3',
    title: 'Food menu decided?',
    orderIndex: 2,
    description: (
      plainText:
          'Plan the complete Christmas menu including appetizers, main course, desserts, and drinks. Consider dietary restrictions and preferences.',
      htmlText:
          '<p>Plan the complete <strong>Christmas menu</strong> including appetizers, main course, desserts, and drinks. Consider dietary restrictions and preferences.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2', 'user_4'],
  ),
  TaskModel(
    id: 'christmas-task-3',
    sheetId: 'sheet-3',
    parentId: 'list-tasks-3',
    title: 'Secret Santa budget',
    orderIndex: 3,
    description: (
      plainText:
          'Set the Secret Santa gift budget and organize the gift exchange. Create a list of participants and assign names.',
      htmlText:
          '<p>Set the <strong>Secret Santa gift budget</strong> and organize the gift exchange. Create a list of participants and assign names.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_3'],
  ),
  TaskModel(
    id: 'christmas-task-4',
    sheetId: 'sheet-3',
    parentId: 'list-tasks-3',
    title: 'Need timing before flight booking?',
    orderIndex: 4,
    description: (
      plainText:
          'Check if anyone needs to book flights for Christmas. Coordinate travel plans and ensure everyone can make it to the celebration.',
      htmlText:
          '<p>Check if anyone needs to <strong>book flights for Christmas</strong>. Coordinate travel plans and ensure everyone can make it to the celebration.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 6)),
    createdBy: 'user_4',
    assignedUsers: ['user_4', 'user_5'],
  ),
  // Digital Organization Tasks
  TaskModel(
    id: 'organize-task-1',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-4',
    title: 'Organize 10,000+ photos into albums',
    orderIndex: 1,
    description: (
      plainText:
          'Create organized photo albums by date, event, and people. Delete duplicates and blurry photos. Use cloud storage for backup.',
      htmlText:
          '<p>Create organized <strong>photo albums</strong> by date, event, and people. Delete duplicates and blurry photos. Use cloud storage for backup.</p>',
    ),
    isCompleted: true,
    dueDate: DateTime.now().add(const Duration(days: 7)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4'],
  ),
  TaskModel(
    id: 'organize-task-2',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-4',
    title: 'Clean up endless chat history',
    orderIndex: 2,
    description: (
      plainText:
          'Archive old conversations, pin important messages, and create a system to find important details quickly without endless scrolling.',
      htmlText:
          '<p>Archive old conversations, <strong>pin important messages</strong>, and create a system to find important details quickly without endless scrolling.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3'],
  ),
  TaskModel(
    id: 'organize-task-3',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-4',
    title: 'Create system for important details',
    orderIndex: 3,
    description: (
      plainText:
          'Set up a centralized system to store and quickly access important information like passwords, contacts, and key details.',
      htmlText:
          '<p>Set up a <strong>centralized system</strong> to store and quickly access important information like passwords, contacts, and key details.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_3', 'user_5'],
  ),
  TaskModel(
    id: 'organize-task-4',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-4',
    title: 'Consolidate multiple apps and platforms',
    orderIndex: 4,
    description: (
      plainText:
          'Review all apps and platforms, delete unused ones, and consolidate similar functions into fewer, more efficient tools.',
      htmlText:
          '<p>Review all apps and platforms, <strong>delete unused ones</strong>, and consolidate similar functions into fewer, more efficient tools.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 10)),
    createdBy: 'user_4',
    assignedUsers: ['user_4', 'user_6'],
  ),
  // Community Management Tasks
  TaskModel(
    id: 'community-task-1',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-5',
    title: 'Consolidate 100+ notifications into priority system',
    orderIndex: 1,
    description: (
      plainText:
          'Create a system to filter and prioritize notifications so important client messages don\'t get lost in the noise. Set up alerts for VIP clients and urgent matters.',
      htmlText:
          '<p>Create a system to <strong>filter and prioritize notifications</strong> so important client messages don\'t get lost in the noise. Set up alerts for VIP clients and urgent matters.</p>',
    ),
    isCompleted: true,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3'],
  ),
  TaskModel(
    id: 'community-task-2',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-5',
    title: 'Create centralized client tracking system',
    orderIndex: 2,
    description: (
      plainText:
          'Build a unified system to track all important clients across different platforms. No more losing clients in scattered tools!',
      htmlText:
          '<p>Build a <strong>unified system to track all important clients</strong> across different platforms. No more losing clients in scattered tools!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_7'],
  ),
  TaskModel(
    id: 'community-task-3',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-5',
    title: 'Migrate scattered tasks to one platform',
    orderIndex: 3,
    description: (
      plainText:
          'Consolidate all tasks from note apps, todo lists, and other scattered tools into one centralized system. Stop the chaos!',
      htmlText:
          '<p>Consolidate all tasks from <strong>note apps, todo lists, and other scattered tools</strong> into one centralized system. Stop the chaos!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_5',
    assignedUsers: ['user_5', 'user_6'],
  ),
  TaskModel(
    id: 'community-task-4',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-5',
    title: 'Set up meeting coordination system',
    orderIndex: 4,
    description: (
      plainText:
          'Create a system to never miss important meetings again. Coordinate schedules, send reminders, and track attendance.',
      htmlText:
          '<p>Create a system to <strong>never miss important meetings again</strong>. Coordinate schedules, send reminders, and track attendance.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    createdBy: 'user_3',
    assignedUsers: ['user_3', 'user_7'],
  ),
  // Chat Management Tasks
  TaskModel(
    id: 'chat-task-1',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-6',
    title: 'Create poll for every group decision',
    orderIndex: 1,
    description: (
      plainText:
          'Stop endless debates! Create polls for meeting days, venues, activities, and any group decisions. No more "Friday or Sunday?" chaos!',
      htmlText:
          '<p>Stop endless debates! Create <strong>polls for meeting days, venues, activities</strong>, and any group decisions. No more "Friday or Sunday?" chaos!</p>',
    ),
    isCompleted: true,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2'],
  ),
  TaskModel(
    id: 'chat-task-2',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-6',
    title: 'Track who\'s coming to events',
    orderIndex: 2,
    description: (
      plainText:
          'Set up a system to track attendance for every event. No more "who\'s even coming?" confusion!',
      htmlText:
          '<p>Set up a system to <strong>track attendance for every event</strong>. No more "who\'s even coming?" confusion!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_3',
    assignedUsers: ['user_3', 'user_4'],
  ),
  TaskModel(
    id: 'chat-task-3',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-6',
    title: 'Organize chat topics and discussions',
    orderIndex: 3,
    description: (
      plainText:
          'Create organized threads for different topics. Keep random chat separate from important decisions and planning.',
      htmlText:
          '<p>Create <strong>organized threads for different topics</strong>. Keep random chat separate from important decisions and planning.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_5',
    assignedUsers: ['user_5', 'user_6'],
  ),
  TaskModel(
    id: 'chat-task-4',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-6',
    title: 'Set up quick decision-making rules',
    orderIndex: 4,
    description: (
      plainText:
          'Establish rules for group decisions: use polls, set deadlines, and stick to majority votes. End the chaos!',
      htmlText:
          '<p>Establish <strong>rules for group decisions</strong>: use polls, set deadlines, and stick to majority votes. End the chaos!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_7',
    assignedUsers: ['user_7', 'user_8'],
  ),
  // Exhibition Management Tasks
  TaskModel(
    id: 'exhibition-task-1',
    sheetId: 'sheet-7',
    parentId: 'list-tasks-7',
    title: 'Consolidate scattered tools and apps',
    orderIndex: 1,
    description: (
      plainText:
          'Stop the chaos! Consolidate note apps, chat groups, calendars, and paper flyers into one organized system. No more scattered confusion!',
      htmlText:
          '<p>Stop the chaos! Consolidate <strong>note apps, chat groups, calendars, and paper flyers</strong> into one organized system. No more scattered confusion!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_5'],
  ),
  TaskModel(
    id: 'exhibition-task-2',
    sheetId: 'sheet-7',
    parentId: 'list-tasks-7',
    title: 'Organize food stall coordination',
    orderIndex: 2,
    description: (
      plainText:
          'Create a system to manage all food stalls, vendors, and catering. Track menus, payments, and logistics in one place.',
      htmlText:
          '<p>Create a system to <strong>manage all food stalls, vendors, and catering</strong>. Track menus, payments, and logistics in one place.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_6'],
  ),
  TaskModel(
    id: 'exhibition-task-3',
    sheetId: 'sheet-7',
    parentId: 'list-tasks-7',
    title: 'Create comprehensive guest list system',
    orderIndex: 3,
    description: (
      plainText:
          'Build a complete guest list management system. Track RSVPs, VIP guests, and attendance. No more "where\'s the guest list?" panic!',
      htmlText:
          '<p>Build a complete <strong>guest list management system</strong>. Track RSVPs, VIP guests, and attendance. No more "where\'s the guest list?" panic!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_3',
    assignedUsers: ['user_3', 'user_7', 'user_9'],
  ),
  TaskModel(
    id: 'exhibition-task-4',
    sheetId: 'sheet-7',
    parentId: 'list-tasks-7',
    title: 'Set up stage management coordination',
    orderIndex: 4,
    description: (
      plainText:
          'Organize stage management, sound systems, lighting, and performance schedules. Clear communication and coordination!',
      htmlText:
          '<p>Organize <strong>stage management, sound systems, lighting, and performance schedules</strong>. Clear communication and coordination!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    createdBy: 'user_4',
    assignedUsers: ['user_4', 'user_5', 'user_8'],
  ),
  // School Fundraiser Management Tasks
  TaskModel(
    id: 'fundraiser-task-1',
    sheetId: 'sheet-8',
    parentId: 'list-tasks-8',
    title: 'Organize cupcake chaos - who\'s bringing what?',
    orderIndex: 1,
    description: (
      plainText:
          'Stop the cupcake chaos! Create a system to track who\'s bringing what, when, and where. No more scattered cupcakes everywhere!',
      htmlText:
          '<p>Stop the <strong>cupcake chaos</strong>! Create a system to track who\'s bringing what, when, and where. No more scattered cupcakes everywhere!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_5', 'user_7'],
  ),
  TaskModel(
    id: 'fundraiser-task-2',
    sheetId: 'sheet-8',
    parentId: 'list-tasks-8',
    title: 'Consolidate flying ticket lists',
    orderIndex: 2,
    description: (
      plainText:
          'Gather all the scattered ticket lists and create one organized system. Track who has what tickets and prevent the flying chaos!',
      htmlText:
          '<p>Gather all the <strong>scattered ticket lists</strong> and create one organized system. Track who has what tickets and prevent the flying chaos!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_6', 'user_8'],
  ),
  TaskModel(
    id: 'fundraiser-task-3',
    sheetId: 'sheet-8',
    parentId: 'list-tasks-8',
    title: 'Track volunteer signups properly',
    orderIndex: 3,
    description: (
      plainText:
          'Create a proper volunteer tracking system. No more lost signups! Know who\'s volunteering for what and when.',
      htmlText:
          '<p>Create a proper <strong>volunteer tracking system</strong>. No more lost signups! Know who\'s volunteering for what and when.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_3', 'user_5', 'user_7', 'user_9'],
  ),
  TaskModel(
    id: 'fundraiser-task-4',
    sheetId: 'sheet-8',
    parentId: 'list-tasks-8',
    title: 'Organize overflowing calendar and meetings',
    orderIndex: 4,
    description: (
      plainText:
          'Consolidate all the scattered meetings and calendar chaos. Create one organized schedule that everyone can follow!',
      htmlText:
          '<p>Consolidate all the <strong>scattered meetings and calendar chaos</strong>. Create one organized schedule that everyone can follow!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_4',
    assignedUsers: ['user_4', 'user_6', 'user_8', 'user_10'],
  ),
  // BBQ Management Tasks
  TaskModel(
    id: 'bbq-task-1',
    sheetId: 'sheet-9',
    parentId: 'list-tasks-9',
    title: 'Organize endless group chat messages',
    orderIndex: 1,
    description: (
      plainText:
          'Stop the endless group chat chaos! Consolidate all the scattered messages about chips, drinks, plates, and timing into one organized system.',
      htmlText:
          '<p>Stop the <strong>endless group chat chaos</strong>! Consolidate all the scattered messages about chips, drinks, plates, and timing into one organized system.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(hours: 1)) ,
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_5', 'user_7', 'user_9'],
  ),
  TaskModel(
    id: 'bbq-task-2',
    sheetId: 'sheet-9',
    parentId: 'list-tasks-9',
    title: 'Coordinate equipment - who\'s bringing the grill?',
    orderIndex: 2,
    description: (
      plainText:
          'Create a clear system to track who\'s bringing what equipment. No more "who\'s bringing the grill?" confusion!',
      htmlText:
          '<p>Create a clear system to <strong>track who\'s bringing what equipment</strong>. No more "who\'s bringing the grill?" confusion!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_6', 'user_8', 'user_10'],
  ),
  TaskModel(
    id: 'bbq-task-3',
    sheetId: 'sheet-9',
    parentId: 'list-tasks-9',
    title: 'Handle dietary restrictions - veggie options, no pork!',
    orderIndex: 3,
    description: (
      plainText:
          'Organize all dietary restrictions and preferences. Ensure veggie options, no pork, and accommodate everyone\'s needs!',
      htmlText:
          '<p>Organize all <strong>dietary restrictions and preferences</strong>. Ensure veggie options, no pork, and accommodate everyone\'s needs!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_3',
    assignedUsers: ['user_3', 'user_5', 'user_7', 'user_9', 'user_11'],
  ),
  TaskModel(
    id: 'bbq-task-4',
    sheetId: 'sheet-9',
    parentId: 'list-tasks-9',
    title: 'Set clear meeting time and location',
    orderIndex: 4,
    description: (
      plainText:
          'End the timing confusion! Set a clear meeting time and location that everyone can follow. No more "what time are we meeting?" questions!',
      htmlText:
          '<p>End the <strong>timing confusion</strong>! Set a clear meeting time and location that everyone can follow. No more "what time are we meeting?" questions!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(hours: 4)),
    createdBy: 'user_4',
    assignedUsers: ['user_4', 'user_6', 'user_8', 'user_10', 'user_11'],
  ),
  // University Hangout Management Tasks
  TaskModel(
    id: 'university-task-1',
    sheetId: 'sheet-10',
    parentId: 'list-tasks-10',
    title: 'Coordinate different timetables and schedules',
    orderIndex: 1,
    description: (
      plainText:
          'Create a system to manage different university timetables. No more "not free Tuesday, change the time" chaos!',
      htmlText:
          '<p>Create a system to <strong>manage different university timetables</strong>. No more "not free Tuesday, change the time" chaos!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_5', 'user_7'],
  ),
  TaskModel(
    id: 'university-task-2',
    sheetId: 'sheet-10',
    parentId: 'list-tasks-10',
    title: 'Find the right places to meet',
    orderIndex: 2,
    description: (
      plainText:
          'Organize a list of great hangout spots around campus. No more "which place?" confusion!',
      htmlText:
          '<p>Organize a <strong>list of great hangout spots around campus</strong>. No more "which place?" confusion!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_6',
    assignedUsers: ['user_6', 'user_8'],
  ),
  TaskModel(
    id: 'university-task-3',
    sheetId: 'sheet-10',
    parentId: 'list-tasks-10',
    title: 'Track who\'s actually coming to hangouts',
    orderIndex: 3,
    description: (
      plainText:
          'Create a system to track attendance and RSVPs. No more "who\'s even coming?" confusion!',
      htmlText:
          '<p>Create a system to <strong>track attendance and RSVPs</strong>. No more "who\'s even coming?" confusion!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(hours: 3)),
    createdBy: 'user_7',
    assignedUsers: ['user_1', 'user_5', 'user_7'],
  ),
  TaskModel(
    id: 'university-task-4',
    sheetId: 'sheet-10',
    parentId: 'list-tasks-10',
    title: 'Create one place for all - calendar, checklist, poll, attendance',
    orderIndex: 4,
    description: (
      plainText:
          'Build the ultimate university hangout hub! One place for calendar, checklist, polls, and attendance tracking!',
      htmlText:
          '<p>Build the <strong>ultimate university hangout hub</strong>! One place for calendar, checklist, polls, and attendance tracking!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_8',
    assignedUsers: ['user_6', 'user_8'],
  ),
  // Book Club Management Tasks
  TaskModel(
    id: 'bookclub-task-1',
    sheetId: 'sheet-11',
    parentId: 'list-tasks-11',
    title: 'Organize monthly meeting scheduling',
    orderIndex: 1,
    description: (
      plainText:
          'Create a system to coordinate monthly book club meetings. No more "I\'m busy Friday, can we do next week?" chaos!',
      htmlText:
          '<p>Create a system to <strong>coordinate monthly book club meetings</strong>. No more "I\'m busy Friday, can we do next week?" chaos!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_5', 'user_7'],
  ),
  TaskModel(
    id: 'bookclub-task-2',
    sheetId: 'sheet-11',
    parentId: 'list-tasks-11',
    title: 'Set up hosting rotation system',
    orderIndex: 2,
    description: (
      plainText:
          'Organize a fair hosting rotation so everyone knows who\'s hosting each month. No more "Who\'s hosting?" confusion!',
      htmlText:
          '<p>Organize a <strong>fair hosting rotation</strong> so everyone knows who\'s hosting each month. No more "Who\'s hosting?" confusion!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_6', 'user_8'],
  ),
  TaskModel(
    id: 'bookclub-task-3',
    sheetId: 'sheet-11',
    parentId: 'list-tasks-11',
    title: 'Create book selection process',
    orderIndex: 3,
    description: (
      plainText:
          'Build a system for choosing books together. No more "Which book this time?" stress - make it fun and democratic!',
      htmlText:
          '<p>Build a system for <strong>choosing books together</strong>. No more "Which book this time?" stress - make it fun and democratic!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_1', 'user_2', 'user_5', 'user_6'],
  ),
  TaskModel(
    id: 'bookclub-task-4',
    sheetId: 'sheet-11',
    parentId: 'list-tasks-11',
    title: 'Organize one place for book, task, calendar',
    orderIndex: 4,
    description: (
      plainText:
          'Create the ultimate book club hub! One place for book selection, task management, and calendar coordination with Zoe!',
      htmlText:
          '<p>Create the <strong>ultimate book club hub</strong>! One place for book selection, task management, and calendar coordination with Zoe!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_4',
    assignedUsers: ['user_3', 'user_4', 'user_7', 'user_8'],
  ),
  // Softball Club BBQ Party Management Tasks
  TaskModel(
    id: 'softball-task-1',
    sheetId: 'sheet-12',
    parentId: 'list-tasks-12',
    title: 'Find a date that works for everyone',
    orderIndex: 1,
    description: (
      plainText:
          'Create a system to coordinate everyone\'s availability. No more "someone is busy" chaos - find the perfect date!',
      htmlText:
          '<p>Create a system to <strong>coordinate everyone\'s availability</strong>. No more "someone is busy" chaos - find the perfect date!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_5', 'user_7', 'user_9'],
  ),
  TaskModel(
    id: 'softball-task-2',
    sheetId: 'sheet-12',
    parentId: 'list-tasks-12',
    title: 'Stop endless talking and make clear decisions',
    orderIndex: 2,
    description: (
      plainText:
          'Organize decision-making process. No more "everyone talking, nobody decide" - create clear choices and votes!',
      htmlText:
          '<p>Organize <strong>decision-making process</strong>. No more "everyone talking, nobody decide" - create clear choices and votes!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_6', 'user_8', 'user_10'],
  ),
  TaskModel(
    id: 'softball-task-3',
    sheetId: 'sheet-12',
    parentId: 'list-tasks-12',
    title: 'Create clarity in planning process',
    orderIndex: 3,
    description: (
      plainText:
          'Build a clear planning system. No more "endless planning with no clarity" - make everything organized and transparent!',
      htmlText:
          '<p>Build a <strong>clear planning system</strong>. No more "endless planning with no clarity" - make everything organized and transparent!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_1', 'user_2', 'user_5', 'user_6', 'user_9'],
  ),
  TaskModel(
    id: 'softball-task-4',
    sheetId: 'sheet-12',
    parentId: 'list-tasks-12',
    title: 'Ensure everyone attends and plan succeeds',
    orderIndex: 4,
    description: (
      plainText:
          'Create a system to track attendance and ensure success. No more "everyone missing, plan gone wrong" - make it happen!',
      htmlText:
          '<p>Create a system to <strong>track attendance and ensure success</strong>. No more "everyone missing, plan gone wrong" - make it happen!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_4',
    assignedUsers: ['user_3', 'user_4', 'user_7', 'user_8', 'user_10'],
  ),
  // Bachelorette Party Management Tasks
  TaskModel(
    id: 'bachelorette-task-1',
    sheetId: 'sheet-13',
    parentId: 'list-tasks-13',
    title: 'Stop non-stop group chat buzzing and organize decisions',
    orderIndex: 1,
    description: (
      plainText:
          'Create a system to organize all the buzzing questions. No more endless "When we are doing it? Vegas or local? Too expensive, who\'s booking the Airbnb?" chaos!',
      htmlText:
          '<p>Create a system to <strong>organize all the buzzing questions</strong>. No more endless "When we are doing it? Vegas or local? Too expensive, who\'s booking the Airbnb?" chaos!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3'],
  ),
  TaskModel(
    id: 'bachelorette-task-2',
    sheetId: 'sheet-13',
    parentId: 'list-tasks-13',
    title: 'Set fixed budget and date decisions',
    orderIndex: 2,
    description: (
      plainText:
          'Establish clear budget limits and finalize the date. No more "no fix budget, no fix date" confusion - make concrete decisions!',
      htmlText:
          '<p>Establish <strong>clear budget limits and finalize the date</strong>. No more "no fix budget, no fix date" confusion - make concrete decisions!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4'],
  ),
  TaskModel(
    id: 'bachelorette-task-3',
    sheetId: 'sheet-13',
    parentId: 'list-tasks-13',
    title: 'Create comprehensive bachelorette party checklist',
    orderIndex: 3,
    description: (
      plainText:
          'Build a complete checklist for theme, activities, transportation, and coordination. No more "empty checklist" - make it organized and fun!',
      htmlText:
          '<p>Build a <strong>complete checklist for theme, activities, transportation, and coordination</strong>. No more "empty checklist" - make it organized and fun!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_1', 'user_2'],
  ),
  TaskModel(
    id: 'bachelorette-task-4',
    sheetId: 'sheet-13',
    parentId: 'list-tasks-13',
    title: 'Transform stress into fun celebration planning',
    orderIndex: 4,
    description: (
      plainText:
          'Create a system that makes bachelorette party planning enjoyable. No more "stress steals the fun" - make it a celebration from start to finish!',
      htmlText:
          '<p>Create a system that <strong>makes bachelorette party planning enjoyable</strong>. No more "stress steals the fun" - make it a celebration from start to finish!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_4',
    assignedUsers: ['user_3', 'user_4'],
  ),
  // Church Summer Fest 2026 Management Tasks
  TaskModel(
    id: 'church-task-1',
    sheetId: 'sheet-14',
    parentId: 'list-tasks-14',
    title: 'Organize food coordination and cooking assignments',
    orderIndex: 1,
    description: (
      plainText:
          'Create a system to coordinate who\'s cooking what. No more "who\'s cooking?" chaos - organize food assignments clearly!',
      htmlText:
          '<p>Create a system to <strong>coordinate who\'s cooking what</strong>. No more "who\'s cooking?" chaos - organize food assignments clearly!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_5', 'user_7'],
  ),
  TaskModel(
    id: 'church-task-2',
    sheetId: 'sheet-14',
    parentId: 'list-tasks-14',
    title: 'Set clear budget and cost planning',
    orderIndex: 2,
    description: (
      plainText:
          'Establish a clear budget for the summer fest. No more "what\'s the budget?" confusion - create organized cost planning!',
      htmlText:
          '<p>Establish a <strong>clear budget for the summer fest</strong>. No more "what\'s the budget?" confusion - create organized cost planning!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_6', 'user_8'],
  ),
  TaskModel(
    id: 'church-task-3',
    sheetId: 'sheet-14',
    parentId: 'list-tasks-14',
    title: 'Coordinate dates and resolve scheduling conflicts',
    orderIndex: 3,
    description: (
      plainText:
          'Find dates that work for everyone. No more "which date works?" and "busy lives, clashing schedules" - create clear coordination!',
      htmlText:
          '<p>Find <strong>dates that work for everyone</strong>. No more "which date works?" and "busy lives, clashing schedules" - create clear coordination!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_1', 'user_2', 'user_5', 'user_6'],
  ),
  TaskModel(
    id: 'church-task-4',
    sheetId: 'sheet-14',
    parentId: 'list-tasks-14',
    title: 'Organize equipment and setup coordination',
    orderIndex: 4,
    description: (
      plainText:
          'Create a system for equipment coordination. No more "who brings chair?" confusion - organize setup and equipment clearly!',
      htmlText:
          '<p>Create a system for <strong>equipment coordination</strong>. No more "who brings chair?" confusion - organize setup and equipment clearly!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_4',
    assignedUsers: ['user_3', 'user_4', 'user_7', 'user_8'],
  ),
  // PTA Bake Sale Management Tasks
  TaskModel(
    id: 'pta-task-1',
    sheetId: 'sheet-15',
    parentId: 'list-tasks-15',
    title: 'Organize baking assignments and coordination',
    orderIndex: 1,
    description: (
      plainText:
          'Create a clear system for baking assignments. No more "who brings brownies? I will do cupcakes" chaos - organize baking tasks clearly!',
      htmlText:
          '<p>Create a clear system for <strong>baking assignments</strong>. No more "who brings brownies? I will do cupcakes" chaos - organize baking tasks clearly!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_5', 'user_7', 'user_9'],
  ),
  TaskModel(
    id: 'pta-task-2',
    sheetId: 'sheet-15',
    parentId: 'list-tasks-15',
    title: 'Handle dietary restrictions and special needs',
    orderIndex: 2,
    description: (
      plainText:
          'Organize gluten-free and other dietary requirements. No more "need gluten-free too!" confusion - create clear dietary planning!',
      htmlText:
          '<p>Organize <strong>gluten-free and other dietary requirements</strong>. No more "need gluten-free too!" confusion - create clear dietary planning!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_6', 'user_8', 'user_10'],
  ),
  TaskModel(
    id: 'pta-task-3',
    sheetId: 'sheet-15',
    parentId: 'list-tasks-15',
    title: 'Resolve scheduling conflicts and availability',
    orderIndex: 3,
    description: (
      plainText:
          'Coordinate schedules and find dates that work. No more "can\'t do Saturday, out this week" conflicts - create clear scheduling!',
      htmlText:
          '<p>Coordinate <strong>schedules and find dates that work</strong>. No more "can\'t do Saturday, out this week" conflicts - create clear scheduling!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_1', 'user_2', 'user_5', 'user_6', 'user_9'],
  ),
  TaskModel(
    id: 'pta-task-4',
    sheetId: 'sheet-15',
    parentId: 'list-tasks-15',
    title: 'Create clear budget and payment coordination',
    orderIndex: 4,
    description: (
      plainText:
          'Establish organized budget planning and payment system. No more "budget again? who pays? nobody really knows" confusion!',
      htmlText:
          '<p>Establish <strong>organized budget planning and payment system</strong>. No more "budget again? who pays? nobody really knows" confusion!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_4',
    assignedUsers: ['user_3', 'user_4', 'user_7', 'user_8', 'user_10'],
  ),
  // Halloween Planning Management Tasks
  TaskModel(
    id: 'halloween-task-1',
    sheetId: 'sheet-16',
    parentId: 'list-tasks-16',
    title: 'Coordinate meeting locations and clear directions',
    orderIndex: 1,
    description: (
      plainText:
          'Create clear meeting locations and directions. No more "wrong street, nobody on the same place" confusion - organize meeting spots clearly!',
      htmlText:
          '<p>Create clear <strong>meeting locations and directions</strong>. No more "wrong street, nobody on the same place" confusion - organize meeting spots clearly!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_5', 'user_7', 'user_9'],
  ),
  TaskModel(
    id: 'halloween-task-2',
    sheetId: 'sheet-16',
    parentId: 'list-tasks-16',
    title: 'Organize clear communication and group chat',
    orderIndex: 2,
    description: (
      plainText:
          'Fix messy group chat and create clear communication. No more "meet at Maple St? Wait, Elm St right?" confusion - organize communication clearly!',
      htmlText:
          '<p>Fix <strong>messy group chat and create clear communication</strong>. No more "meet at Maple St? Wait, Elm St right?" confusion - organize communication clearly!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_6', 'user_8', 'user_10'],
  ),
  TaskModel(
    id: 'halloween-task-3',
    sheetId: 'sheet-16',
    parentId: 'list-tasks-16',
    title: 'Handle scheduling conflicts and late arrivals',
    orderIndex: 3,
    description: (
      plainText:
          'Coordinate schedules and handle late arrivals. No more "I can only join later, we\'ll just go without u" conflicts - create clear scheduling!',
      htmlText:
          '<p>Coordinate <strong>schedules and handle late arrivals</strong>. No more "I can only join later, we\'ll just go without u" conflicts - create clear scheduling!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_1', 'user_2', 'user_5', 'user_6', 'user_9'],
  ),
  TaskModel(
    id: 'halloween-task-4',
    sheetId: 'sheet-16',
    parentId: 'list-tasks-16',
    title: 'Create clear house locations and meeting points',
    orderIndex: 4,
    description: (
      plainText:
          'Establish clear house locations and meeting points. No more "wait which house again? Nobody is here" confusion - organize locations clearly!',
      htmlText:
          '<p>Establish <strong>clear house locations and meeting points</strong>. No more "wait which house again? Nobody is here" confusion - organize locations clearly!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_4',
    assignedUsers: ['user_3', 'user_4', 'user_7', 'user_8', 'user_10'],
  ),
  // Summer Camp Sign-ups Management Tasks
  TaskModel(
    id: 'camp-task-1',
    sheetId: 'sheet-17',
    parentId: 'list-tasks-17',
    title: 'Organize form submissions and sign-up process',
    orderIndex: 1,
    description: (
      plainText:
          'Create clear form submission process and sign-up coordination. No more "did you fill the form? what\'s do when?" confusion - organize sign-ups clearly!',
      htmlText:
          '<p>Create clear <strong>form submission process and sign-up coordination</strong>. No more "did you fill the form? what\'s do when?" confusion - organize sign-ups clearly!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_5', 'user_7', 'user_9'],
  ),
  TaskModel(
    id: 'camp-task-2',
    sheetId: 'sheet-17',
    parentId: 'list-tasks-17',
    title: 'Handle date conflicts and scheduling confusion',
    orderIndex: 2,
    description: (
      plainText:
          'Resolve date conflicts and create clear scheduling. No more "can we change the date? I thought it\'s July 15? I already booked tickets for Aug" chaos!',
      htmlText:
          '<p>Resolve <strong>date conflicts and create clear scheduling</strong>. No more "can we change the date? I thought it\'s July 15? I already booked tickets for Aug" chaos!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_6', 'user_8', 'user_10'],
  ),
  TaskModel(
    id: 'camp-task-3',
    sheetId: 'sheet-17',
    parentId: 'list-tasks-17',
    title: 'Manage payment handling and financial coordination',
    orderIndex: 3,
    description: (
      plainText:
          'Create organized payment system and financial coordination. No more "who\'s handling payments?" confusion - organize finances clearly!',
      htmlText:
          '<p>Create <strong>organized payment system and financial coordination</strong>. No more "who\'s handling payments?" confusion - organize finances clearly!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_1', 'user_2', 'user_5', 'user_6', 'user_9'],
  ),
  TaskModel(
    id: 'camp-task-4',
    sheetId: 'sheet-17',
    parentId: 'list-tasks-17',
    title: 'Organize equipment and supplies coordination',
    orderIndex: 4,
    description: (
      plainText:
          'Create clear equipment and supplies organization. No more "snacks list? I can\'t find it, tents or not?" confusion - organize supplies clearly!',
      htmlText:
          '<p>Create <strong>clear equipment and supplies organization</strong>. No more "snacks list? I can\'t find it, tents or not?" confusion - organize supplies clearly!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_4',
    assignedUsers: ['user_3', 'user_4', 'user_7', 'user_8', 'user_10'],
  ),
  // Thanksgiving Planning Management Tasks
  TaskModel(
    id: 'thanksgiving-task-1',
    sheetId: 'sheet-18',
    parentId: 'list-tasks-18',
    title: 'Organize cooking assignments and reduce endless stress',
    orderIndex: 1,
    description: (
      plainText:
          'Create clear cooking assignments and reduce weeks of endless stress. No more "weeks of cooking endless stress" - organize cooking tasks clearly!',
      htmlText:
          '<p>Create clear <strong>cooking assignments and reduce weeks of endless stress</strong>. No more "weeks of cooking endless stress" - organize cooking tasks clearly!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_5', 'user_7', 'user_9'],
  ),
  TaskModel(
    id: 'thanksgiving-task-2',
    sheetId: 'sheet-18',
    parentId: 'list-tasks-18',
    title: 'Ensure reliable help and follow through on promises',
    orderIndex: 2,
    description: (
      plainText:
          'Create reliable help system and ensure follow through on promises. No more "they all promised they will help but will they really help?" - organize reliable help!',
      htmlText:
          '<p>Create <strong>reliable help system and ensure follow through on promises</strong>. No more "they all promised they will help but will they really help?" - organize reliable help!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_4', 'user_6', 'user_8', 'user_10'],
  ),
  TaskModel(
    id: 'thanksgiving-task-3',
    sheetId: 'sheet-18',
    parentId: 'list-tasks-18',
    title: 'Handle family group chat chaos and confusion',
    orderIndex: 3,
    description: (
      plainText:
          'Organize family group chat and reduce chaos. No more "who\'s bringing the pie? I can do it. I will get the turkey, shares random meme, what time again? Thursday, dad! Not Friday" confusion!',
      htmlText:
          '<p>Organize <strong>family group chat and reduce chaos</strong>. No more "who\'s bringing the pie? I can do it. I will get the turkey, shares random meme, what time again? Thursday, dad! Not Friday" confusion!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_1', 'user_2', 'user_5', 'user_6', 'user_9'],
  ),
  TaskModel(
    id: 'thanksgiving-task-4',
    sheetId: 'sheet-18',
    parentId: 'list-tasks-18',
    title: 'Prevent everything from falling on mom',
    orderIndex: 4,
    description: (
      plainText:
          'Create balanced workload distribution and prevent everything from falling on mom. No more "at end everything falls on mom" - organize balanced responsibilities!',
      htmlText:
          '<p>Create <strong>balanced workload distribution and prevent everything from falling on mom</strong>. No more "at end everything falls on mom" - organize balanced responsibilities!</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 4)),
    createdBy: 'user_4',
    assignedUsers: ['user_3', 'user_4', 'user_7', 'user_8', 'user_10'],
  ),
];
