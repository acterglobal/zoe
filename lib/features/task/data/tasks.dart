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
    isCompleted: false,
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
    assignedUsers: ['user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
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
    isCompleted: false,
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
    isCompleted: false,
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
    isCompleted: false,
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
];
