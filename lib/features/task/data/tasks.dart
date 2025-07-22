import 'package:zoey/features/task/models/task_model.dart';

final tasks = [
  TaskModel(
    id: 'task-1',
    sheetId: 'sheet-1',
    listId: 'list-tasks-1',
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
  ),
  TaskModel(
    id: 'task-2',
    sheetId: 'sheet-1',
    listId: 'list-tasks-1',
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
  ),
  TaskModel(
    id: 'task-3',
    sheetId: 'sheet-1',
    listId: 'list-tasks-1',
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
  ),
  TaskModel(
    id: 'task-4',
    sheetId: 'sheet-1',
    listId: 'list-tasks-1',
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
  ),
  TaskModel(
    id: 'task-5',
    sheetId: 'sheet-1',
    listId: 'list-tasks-1',
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
  ),
  TaskModel(
    id: 'task-6',
    sheetId: 'sheet-1',
    listId: 'list-tasks-1',
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
  ),
  TaskModel(
    id: 'task-7',
    sheetId: 'sheet-1',
    listId: 'list-tasks-1',
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
  ),
  TaskModel(
    id: 'task-8',
    sheetId: 'sheet-1',
    listId: 'list-tasks-1',
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
  ),
  TaskModel(
    id: 'task-9',
    sheetId: 'sheet-1',
    listId: 'list-tasks-1',
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
  ),
];
