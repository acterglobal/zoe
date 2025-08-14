import 'package:zoe/features/task/models/task_model.dart';

final tasks = [
  // Getting Started Guide (sheet-1) tasks
  TaskModel(
    id: 'task-1',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Read through this Getting Started Guide',
    orderIndex: 1,
    description: (
      plainText:
          'Take your time to understand Zoey\'s features and capabilities. This foundation will help you use the app more effectively.',
      htmlText:
          '<p>Take your time to understand Zoey\'s features and capabilities. This foundation will help you use the app more effectively.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(minutes: 15)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_3', 'user_7'],
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
    assignedUsers: ['user_2', 'user_5', 'user_8'],
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
    assignedUsers: ['user_4', 'user_9'],
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
    assignedUsers: ['user_1', 'user_6', 'user_10'],
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
    assignedUsers: ['user_1', 'user_6', 'user_10'],
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
    assignedUsers: ['user_1', 'user_6', 'user_10'],
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
    assignedUsers: ['user_1', 'user_6', 'user_10'],
  ),
  TaskModel(
    id: 'task-8',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Explore the settings and preferences',
    orderIndex: 8,
    description: (
      plainText:
          'Check out the settings screen to see how you can customize your Zoey experience with themes and other preferences.',
      htmlText:
          '<p>Check out the settings screen to see how you can customize your Zoey experience with themes and other preferences.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_9',
    assignedUsers: ['user_1'],
  ),
  TaskModel(
    id: 'task-9',
    sheetId: 'sheet-1',
    parentId: 'list-tasks-1',
    title: 'Plan your next steps with Zoey',
    orderIndex: 9,
    description: (
      plainText:
          'Think about how you want to use Zoey in your daily life. Consider creating sheets for work projects, personal goals, or areas of interest.',
      htmlText:
          '<p>Think about how you want to use Zoey in your daily life. Consider creating sheets for work projects, personal goals, or areas of interest.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_6', 'user_10'],
  ),

  // Community Organization (sheet-2) tasks
  TaskModel(
    id: 'task-community-snacks-1',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-community-1',
    title: 'Orange slices for halftime',
    orderIndex: 1,
    description: (
      plainText:
          'Bring pre-cut orange slices for 16 kids. Please bring them in a cooler to keep fresh.',
      htmlText:
          '<p>Bring pre-cut orange slices for 16 kids. Please bring them in a cooler to keep fresh.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_6', 'user_10'],
  ),
  TaskModel(
    id: 'task-community-snacks-2',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-community-1',
    title: 'Water bottles for the team',
    orderIndex: 2,
    description: (
      plainText:
          'Individual water bottles for 16 kids plus coaches. Any brand is fine, but make sure they\'re cold.',
      htmlText:
          '<p>Individual water bottles for 16 kids plus coaches. Any brand is fine, but make sure they\'re cold.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_4',
    assignedUsers: ['user_7', 'user_8', 'user_9'],
  ),
  TaskModel(
    id: 'task-community-snacks-3',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-community-1',
    title: 'Granola bars or energy snacks',
    orderIndex: 3,
    description: (
      plainText:
          'Post-game snacks for energy. Individual wrapped bars work best. Please avoid nuts due to allergies.',
      htmlText:
          '<p>Post-game snacks for energy. Individual wrapped bars work best. Please avoid nuts due to allergies.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_10',
    assignedUsers: ['user_10'],
  ),
  TaskModel(
    id: 'task-community-snacks-4',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-community-1',
    title: 'Paper towels and napkins',
    orderIndex: 4,
    description: (
      plainText:
          'For cleanup after snacks. A couple rolls of paper towels should be plenty.',
      htmlText:
          '<p>For cleanup after snacks. A couple rolls of paper towels should be plenty.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_9',
    assignedUsers: ['user_9'],
  ),

  TaskModel(
    id: 'task-community-equipment-1',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-community-2',
    title: 'Set up team bench and shade tent',
    orderIndex: 1,
    description: (
      plainText:
          'Arrive 30 minutes early to set up the portable bench and shade tent on our sideline.',
      htmlText:
          '<p>Arrive 30 minutes early to set up the portable bench and shade tent on our sideline.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_1',
    assignedUsers: ['user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  TaskModel(
    id: 'task-community-equipment-2',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-community-2',
    title: 'Bring first aid kit and ice packs',
    orderIndex: 2,
    description: (
      plainText:
          'Standard first aid supplies plus instant cold packs for any minor injuries during the game.',
      htmlText:
          '<p>Standard first aid supplies plus instant cold packs for any minor injuries during the game.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_1',
    assignedUsers: ['user_3', 'user_6', 'user_7'],
  ),
  TaskModel(
    id: 'task-community-equipment-3',
    sheetId: 'sheet-2',
    parentId: 'list-tasks-community-2',
    title: 'Practice cones and training equipment',
    orderIndex: 3,
    description: (
      plainText:
          'Bring the bag of orange cones and agility ladder for pre-game warm-up.',
      htmlText:
          '<p>Bring the bag of orange cones and agility ladder for pre-game warm-up.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_3',
    assignedUsers: ['user_4', 'user_5', 'user_6'],
  ),

  // Inclusive Communication (sheet-3) tasks
  TaskModel(
    id: 'task-inclusive-1',
    sheetId: 'sheet-3',
    parentId: 'list-tasks-inclusive-1',
    title: 'Send welcome message to new members',
    orderIndex: 1,
    description: (
      plainText:
          'Create a warm welcome message explaining group norms, communication style, and how to get involved.',
      htmlText:
          '<p>Create a warm welcome message explaining group norms, communication style, and how to get involved.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_6',
    assignedUsers: ['user_1', 'user_2', 'user_3'],
  ),
  TaskModel(
    id: 'task-inclusive-2',
    sheetId: 'sheet-3',
    parentId: 'list-tasks-inclusive-1',
    title: 'Set up daily summary system',
    orderIndex: 2,
    description: (
      plainText:
          'Create a process to send daily summaries of important decisions and updates for people who miss active chat times.',
      htmlText:
          '<p>Create a process to send daily summaries of important decisions and updates for people who miss active chat times.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_6',
    assignedUsers: ['user_1', 'user_2'],
  ),
  TaskModel(
    id: 'task-inclusive-3',
    sheetId: 'sheet-3',
    parentId: 'list-tasks-inclusive-1',
    title: 'Use simple emoji-based participation',
    orderIndex: 3,
    description: (
      plainText:
          'Implement 👋 for volunteering and ✅ for confirmation - no typing required for basic participation.',
      htmlText:
          '<p>Implement 👋 for volunteering and ✅ for confirmation - no typing required for basic participation.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_6',
    assignedUsers: ['user_6'],
  ),
  TaskModel(
    id: 'task-inclusive-4',
    sheetId: 'sheet-3',
    parentId: 'list-tasks-inclusive-1',
    title: 'Create specific, clear task descriptions',
    orderIndex: 4,
    description: (
      plainText:
          'Replace vague asks like "someone should bring snacks" with specific "bring orange slices for 16 kids".',
      htmlText:
          '<p>Replace vague asks like "someone should bring snacks" with specific "bring orange slices for 16 kids".</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_7',
    assignedUsers: ['user_3'],
  ),

  // Information Management (sheet-4) tasks
  TaskModel(
    id: 'task-info-1',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-info-1',
    title: 'Create master schedule list',
    orderIndex: 1,
    description: (
      plainText:
          'Compile all practice times, game dates, and important deadlines into one organized, accessible list.',
      htmlText:
          '<p>Compile all practice times, game dates, and important deadlines into one organized, accessible list.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_6',
    assignedUsers: ['user_2', 'user_3'],
  ),
  TaskModel(
    id: 'task-info-2',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-info-1',
    title: 'Build contact directory',
    orderIndex: 2,
    description: (
      plainText:
          'Gather all parent contact info, coach numbers, and emergency contacts in one searchable directory.',
      htmlText:
          '<p>Gather all parent contact info, coach numbers, and emergency contacts in one searchable directory.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)), 
    createdBy: 'user_8',
    assignedUsers: ['user_7', 'user_2', 'user_3', 'user_4'],
  ),
  TaskModel(
    id: 'task-info-3',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-info-1',
    title: 'Document team roster with jersey numbers',
    orderIndex: 3,
    description: (
      plainText:
          'Create a clear list of all players with their assigned jersey numbers for easy reference.',
      htmlText:
          '<p>Create a clear list of all players with their assigned jersey numbers for easy reference.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_8',
    assignedUsers: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  TaskModel(
    id: 'task-info-4',
    sheetId: 'sheet-4',
    parentId: 'list-tasks-info-1',
    title: 'Set up equipment and rules reference',
    orderIndex: 4,
    description: (
      plainText:
          'Document what to bring to games, uniform requirements, and important team rules for easy reference.',
      htmlText:
          '<p>Document what to bring to games, uniform requirements, and important team rules for easy reference.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)), 
    createdBy: 'user_8',
    assignedUsers: ['user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),

  // Group Visibility (sheet-5) tasks
  TaskModel(
    id: 'task-visibility-potluck-1',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-visibility-1',
    title: 'Main dishes (need 3 total)',
    orderIndex: 1,
    description: (
      plainText:
          'Substantial entrees that can feed 8-10 people. Pasta dishes, casseroles, or grilled items work well.',
      htmlText:
          '<p>Substantial entrees that can feed 8-10 people. Pasta dishes, casseroles, or grilled items work well.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    createdBy: 'user_8',
    assignedUsers: [],
  ),
  TaskModel(
    id: 'task-visibility-potluck-2',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-visibility-1',
    title: 'Side dishes (need 4 total)',
    orderIndex: 2,
    description: (
      plainText:
          'Salads, vegetable dishes, bread, or other sides that complement the main dishes.',
      htmlText:
          '<p>Salads, vegetable dishes, bread, or other sides that complement the main dishes.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 5)), 
    createdBy: 'user_8',
    assignedUsers: ['user_1', 'user_2', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  TaskModel(
    id: 'task-visibility-potluck-3',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-visibility-1',
    title: 'Desserts (need 2 total)',
    orderIndex: 3,
    description: (
      plainText:
          'Sweet treats to finish the meal. Cakes, pies, cookies, or fruit dishes.',
      htmlText:
          '<p>Sweet treats to finish the meal. Cakes, pies, cookies, or fruit dishes.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    createdBy: 'user_4',
    assignedUsers: ['user_1','user_8', 'user_9', 'user_10'],
  ),
  TaskModel(
    id: 'task-visibility-potluck-4',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-visibility-1',
    title: 'Drinks (urgent - still needed!)',
    orderIndex: 4,
    description: (
      plainText:
          'Beverages for the group. Water, soda, juice, or other drinks. Please bring variety.',
      htmlText:
          '<p>Beverages for the group. Water, soda, juice, or other drinks. Please bring variety.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    createdBy: 'user_4',
    assignedUsers: ['user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),

  TaskModel(
    id: 'task-visibility-party-1',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-visibility-2',
    title: 'Decorations and banners',
    orderIndex: 1,
    description: (
      plainText:
          'Team colors decorations, "Congratulations" banner, balloons, and table decorations.',
      htmlText:
          '<p>Team colors decorations, "Congratulations" banner, balloons, and table decorations.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_1',
    assignedUsers: ['user_10'],
  ),
  TaskModel(
    id: 'task-visibility-party-2',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-visibility-2',
    title: 'Music speaker and playlist',
    orderIndex: 2,
    description: (
      plainText:
          'Portable speaker with upbeat, family-friendly music playlist for background ambiance.',
      htmlText:
          '<p>Portable speaker with upbeat, family-friendly music playlist for background ambiance.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)), 
    createdBy: 'user_9',
    assignedUsers: ['user_1','user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  TaskModel(
    id: 'task-visibility-party-3',
    sheetId: 'sheet-5',
    parentId: 'list-tasks-visibility-2',
    title: 'Plates, cups, and utensils',
    orderIndex: 3,
    description: (
      plainText:
          'Paper plates, cups, plastic utensils, and napkins for approximately 50 people.',
      htmlText:
          '<p>Paper plates, cups, plastic utensils, and napkins for approximately 50 people.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_2',
    assignedUsers: ['user_8'],
  ),

  // Stress-Free Organizing (sheet-6) tasks
  TaskModel(
    id: 'task-stress-1',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-stress-1',
    title: 'Set up automatic reminders for recurring events',
    orderIndex: 1,
    description: (
      plainText:
          'Configure weekly practice reminders, game day notifications, and monthly meeting alerts so you never have to remember manually.',
      htmlText:
          '<p>Configure weekly practice reminders, game day notifications, and monthly meeting alerts so you never have to remember manually.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_2',
    assignedUsers: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  TaskModel(
    id: 'task-stress-2',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-stress-1',
    title: 'Create self-tracking task lists',
    orderIndex: 2,
    description: (
      plainText:
          'Set up lists where parents can mark tasks complete with emoji reactions - no need to chase people for updates.',
      htmlText:
          '<p>Set up lists where parents can mark tasks complete with emoji reactions - no need to chase people for updates.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_2',
    assignedUsers: [],
  ),
  TaskModel(
    id: 'task-stress-3',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-stress-1',
    title: 'Establish shared responsibility system',
    orderIndex: 3,
    description: (
      plainText:
          'Assign clear ownership for different areas (snacks, equipment, communication) so the mental load is distributed.',
      htmlText:
          '<p>Assign clear ownership for different areas (snacks, equipment, communication) so the mental load is distributed.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  TaskModel(
    id: 'task-stress-4',
    sheetId: 'sheet-6',
    parentId: 'list-tasks-stress-1',
    title: 'Create persistent information lists',
    orderIndex: 4,
    description: (
      plainText:
          'Move important details out of your head and into organized lists that everyone can access and update.',
      htmlText:
          '<p>Move important details out of your head and into organized lists that everyone can access and update.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_4',
    assignedUsers: ['user_1', 'user_2'],
  ),

  // Easy Handoffs (sheet-7) tasks
  TaskModel(
    id: 'task-handoff-1',
    sheetId: 'sheet-7',
    parentId: 'list-tasks-handoff-1',
    title: 'Document all current responsibilities',
    orderIndex: 1,
    description: (
      plainText:
          'Create clear lists of what you\'re organizing, who\'s committed to what, and what deadlines are coming up.',
      htmlText:
          '<p>Create clear lists of what you\'re organizing, who\'s committed to what, and what deadlines are coming up.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_1',
    assignedUsers: ['user_1', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  TaskModel(
    id: 'task-handoff-2',
    sheetId: 'sheet-7',
    parentId: 'list-tasks-handoff-1',
    title: 'Identify backup organizers',
    orderIndex: 2,
    description: (
      plainText:
          'Recruit 2-3 other parents who could step in as organizers if needed. Brief them on the basics.',
      htmlText:
          '<p>Recruit 2-3 other parents who could step in as organizers if needed. Brief them on the basics.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
    createdBy: 'user_3',
    assignedUsers: ['user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  TaskModel(
    id: 'task-handoff-3',
    sheetId: 'sheet-7',
    parentId: 'list-tasks-handoff-1',
    title: 'Centralize all contact information',
    orderIndex: 3,
    description: (
      plainText:
          'Ensure all parent contacts, coach info, and important numbers are in accessible lists, not just your phone.',
      htmlText:
          '<p>Ensure all parent contacts, coach info, and important numbers are in accessible lists, not just your phone.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
    createdBy: 'user_3',
    assignedUsers: ['user_9', 'user_10'],
  ),
  TaskModel(
    id: 'task-handoff-4',
    sheetId: 'sheet-7',
    parentId: 'list-tasks-handoff-1',
    title: 'Test the handoff process',
    orderIndex: 4,
    description: (
      plainText:
          'Practice transferring organizer privileges to a backup person and ensure they have all the context they need.',
      htmlText:
          '<p>Practice transferring organizer privileges to a backup person and ensure they have all the context they need.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
    createdBy: 'user_3',
    assignedUsers: ['user_5'],
  ),

  // Group Trip Planning (sheet-8) tasks
  TaskModel(
    id: 'task-trip-1',
    sheetId: 'sheet-8',
    parentId: 'list-tasks-trip-1',
    title: 'Research and book group flights',
    orderIndex: 1,
    description: (
      plainText:
          'Find flights for all 6 travelers to Tokyo. Look for group discounts and coordinate departure times.',
      htmlText:
          '<p>Find flights for all 6 travelers to Tokyo. Look for group discounts and coordinate departure times.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 14)),
    createdBy: 'user_5',
    assignedUsers: [],
  ),
  TaskModel(
    id: 'task-trip-2',
    sheetId: 'sheet-8',
    parentId: 'list-tasks-trip-1',
    title: 'Find accommodations in Tokyo and Kyoto',
    orderIndex: 2,
    description: (
      plainText:
          'Book hotels or vacation rentals for our group. Need 3 rooms total for our week-long stay.',
      htmlText:
          '<p>Book hotels or vacation rentals for our group. Need 3 rooms total for our week-long stay.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 10)),
    createdBy: 'user_5',
    assignedUsers: [],
  ),
  TaskModel(
    id: 'task-trip-3',
    sheetId: 'sheet-8',
    parentId: 'list-tasks-trip-1',
    title: 'Research activities and restaurants',
    orderIndex: 3,
    description: (
      plainText:
          'Create lists of must-see temples, best food spots, and unique experiences in both Tokyo and Kyoto.',
      htmlText:
          '<p>Create lists of must-see temples, best food spots, and unique experiences in both Tokyo and Kyoto.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 7)),
    createdBy: 'user_5',
    assignedUsers: [],
  ),
  TaskModel(
    id: 'task-trip-4',
    sheetId: 'sheet-8',
    parentId: 'list-tasks-trip-1',
    title: 'Set up group chat for travel day coordination',
    orderIndex: 4,
    description: (
      plainText:
          'Create a dedicated chat for sharing flight updates, meeting points, and real-time travel coordination.',
      htmlText:
          '<p>Create a dedicated chat for sharing flight updates, meeting points, and real-time travel coordination.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 5)),
    createdBy: 'user_5',
    assignedUsers: [],
  ),
  TaskModel(
    id: 'task-trip-5',
    sheetId: 'sheet-8',
    parentId: 'list-tasks-trip-1',
    title: 'Coordinate travel insurance and documents',
    orderIndex: 5,
    description: (
      plainText:
          'Ensure everyone has valid passports and consider group travel insurance options for the trip.',
      htmlText:
          '<p>Ensure everyone has valid passports and consider group travel insurance options for the trip.</p>',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 21)),
    createdBy: 'user_5',
    assignedUsers: [],
  ),
];
