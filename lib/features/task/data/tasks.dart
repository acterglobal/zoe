import 'package:zoe/features/task/models/task_model.dart';

final tasks = [
  
  // Getting Started Guide Tasks
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
  
   // Mobile App Development Tasks
  TaskModel(
    id: 'task-app-1',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-app-1',
    title: 'Implement User Authentication',
    orderIndex: 1,
    description: (
      plainText:
          'Set up OAuth2 authentication flow with social login options. Include email verification and password reset functionality.',
      htmlText:
          '<p>Set up OAuth2 authentication flow with social login options. Include email verification and password reset functionality.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2'],
  ),
  TaskModel(
    id: 'task-app-2',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-app-1',
    title: 'Design System Implementation',
    orderIndex: 2,
    description: (
      plainText:
          'Create reusable UI components following our design system. Include theme support, accessibility features, and responsive layouts.',
      htmlText:
          '<p>Create reusable UI components following our design system. Include theme support, accessibility features, and responsive layouts.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    createdBy: 'user_2',
    assignedUsers: ['user_2', 'user_3'],
  ),

  // Community Garden Tasks
  TaskModel(
    id: 'task-garden-1',
    sheetId: 'sheet-3',
    parentId: 'list-tasks-garden-1',
    title: 'Prepare Garden Beds',
    orderIndex: 1,
    description: (
      plainText:
          'Clear weeds, add compost, and prepare soil in all garden beds. Mark out planting areas and install irrigation system.',
      htmlText:
          '<p>Clear weeds, add compost, and prepare soil in all garden beds. Mark out planting areas and install irrigation system.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2', 'user_3'],
  ),
  TaskModel(
    id: 'task-garden-2',
    sheetId: 'sheet-3',
    parentId: 'list-tasks-garden-1',
    title: 'Order Seeds and Supplies',
    orderIndex: 2,
    description: (
      plainText:
          'Purchase seasonal vegetable seeds, organic fertilizer, and gardening tools. Check inventory and restock as needed.',
      htmlText:
          '<p>Purchase seasonal vegetable seeds, organic fertilizer, and gardening tools. Check inventory and restock as needed.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_2',
    assignedUsers: ['user_2'],
  ),

  // Wedding Planning Tasks
  TaskModel(
    id: 'task-wedding-1',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-wedding-1',
    title: 'Book Wedding Venue',
    orderIndex: 1,
    description: (
      plainText:
          'Research and visit potential venues, compare prices, check availability for our preferred dates, and review contract terms before making final decision.',
      htmlText:
          '<p>Research and visit potential venues, compare prices, check availability for our preferred dates, and review contract terms before making final decision.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 30)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2'],
  ),
  TaskModel(
    id: 'task-wedding-2',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-wedding-1',
    title: 'Create Guest List',
    orderIndex: 2,
    description: (
      plainText:
          'Compile names and addresses of all potential guests, categorize by must-invite and maybe-invite, and determine plus-one policies.',
      htmlText:
          '<p>Compile names and addresses of all potential guests, categorize by must-invite and maybe-invite, and determine plus-one policies.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 14)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2', 'user_3'],
  ),
  TaskModel(
    id: 'task-wedding-3',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-wedding-2',
    title: 'Schedule Catering Tastings',
    orderIndex: 1,
    description: (
      plainText:
          'Contact potential caterers, schedule tasting sessions, compare menu options and pricing, consider dietary restrictions.',
      htmlText:
          '<p>Contact potential caterers, schedule tasting sessions, compare menu options and pricing, consider dietary restrictions.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 45)),
    createdBy: 'user_2',
    assignedUsers: ['user_1', 'user_2'],
  ),

  // Fitness Journey Tasks
  TaskModel(
    id: 'task-fitness-1',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-fitness-1',
    title: 'Complete Upper Body Workout',
    orderIndex: 1,
    description: (
      plainText:
          'Today\'s Focus:\n- 4 sets of bench press\n- 3 sets of shoulder press\n- 3 sets of pull-ups\n- 3 sets of tricep dips\nTarget: Progressive overload from last session',
      htmlText:
          '<p>Today\'s Focus:</p><ul><li>4 sets of bench press</li><li>3 sets of shoulder press</li><li>3 sets of pull-ups</li><li>3 sets of tricep dips</li></ul><p>Target: Progressive overload from last session</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1'],
  ),
  TaskModel(
    id: 'task-fitness-2',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-fitness-1',
    title: 'Meal Prep for the Week',
    orderIndex: 2,
    description: (
      plainText:
          'Prepare:\n- Grilled chicken breasts\n- Roasted vegetables\n- Brown rice\n- Protein smoothie packs\nDivide into 5 portions for the week',
      htmlText:
          '<p>Prepare:</p><ul><li>Grilled chicken breasts</li><li>Roasted vegetables</li><li>Brown rice</li><li>Protein smoothie packs</li></ul><p>Divide into 5 portions for the week</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_1',
    assignedUsers: ['user_1'],
  ),
  TaskModel(
    id: 'task-fitness-3',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-fitness-2',
    title: 'Track Body Measurements',
    orderIndex: 1,
    description: (
      plainText:
          'Monthly measurements:\n- Weight\n- Body fat percentage\n- Chest, waist, hips\n- Arms and legs\nTake progress photos from front, side, and back',
      htmlText:
          '<p>Monthly measurements:</p><ul><li>Weight</li><li>Body fat percentage</li><li>Chest, waist, hips</li><li>Arms and legs</li></ul><p>Take progress photos from front, side, and back</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 7)),
    createdBy: 'user_1',
    assignedUsers: ['user_1'],
  ),

   // Home Renovation Tasks
  TaskModel(
    id: 'task-renovation-1',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-renovation-1',
    title: 'Finalize Kitchen Design',
    orderIndex: 1,
    description: (
      plainText:
          'Create detailed kitchen layout with measurements, select cabinet style, countertop material, and appliance specifications.',
      htmlText:
          '<p>Create detailed kitchen layout with measurements, select cabinet style, countertop material, and appliance specifications.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 14)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2'],
  ),
  TaskModel(
    id: 'task-renovation-2',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-renovation-1',
    title: 'Get Contractor Quotes',
    orderIndex: 2,
    description: (
      plainText:
          'Contact and schedule meetings with at least three licensed contractors. Get detailed quotes for all renovation work.',
      htmlText:
          '<p>Contact and schedule meetings with at least three licensed contractors. Get detailed quotes for all renovation work.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 21)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_2', 'user_3'],
  ),
  TaskModel(
    id: 'task-renovation-3',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-renovation-2',
    title: 'Schedule Inspections',
    orderIndex: 1,
    description: (
      plainText:
          'Book appointments for electrical, plumbing, and structural inspections. Ensure all necessary permits are obtained.',
      htmlText:
          '<p>Book appointments for electrical, plumbing, and structural inspections. Ensure all necessary permits are obtained.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 7)),
    createdBy: 'user_2',
    assignedUsers: ['user_2'],
  ),
];
