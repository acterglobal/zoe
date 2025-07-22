import 'package:zoey/features/task/models/task_model.dart';

final tasks = [
  TaskModel(
    id: 'task-1',
    listId: 'list-tasks-1',
    title: 'Explore this Getting Started sheet',
    description: (
      plainText: 'Read through this guide to understand Zoey\'s features',
      htmlText: '',
    ),
    isCompleted: true,
    dueDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
  TaskModel(
    id: 'task-2',
    listId: 'list-tasks-1',
    title: 'Check out the Productivity Workspace example',
    description: (
      plainText: 'See how to organize a real project with tasks and events',
      htmlText: '',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(hours: 2)),
  ),
  TaskModel(
    id: 'task-3',
    listId: 'list-tasks-1',
    title: 'Create your first custom sheet',
    description: (
      plainText: 'Try creating a sheet for a personal project or goal',
      htmlText: '',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
  ),
  TaskModel(
    id: 'task-4',
    listId: 'list-tasks-1',
    title: 'Add different content blocks',
    description: (
      plainText: 'Experiment with text, tasks, events, and lists',
      htmlText: '',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
  ),
  TaskModel(
    id: 'task-5',
    listId: 'list-tasks-1',
    title: 'Customize your workspace',
    description: (
      plainText: 'Add emojis, organize sheets, and make it your own',
      htmlText: '',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 3)),
  ),
  TaskModel(
    id: 'task-6',
    listId: 'list-tasks-1',
    title: 'Explore Getting Started Guide',
    description: (
      plainText: 'Read through this guide and try the features',
      htmlText: '',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 1)),
  ),
  TaskModel(
    id: 'task-7',
    listId: 'list-tasks-1',
    title: 'Check out the Productivity Workspace example',
    description: (
      plainText: 'See how to organize a real project with tasks and events',
      htmlText: '',
    ),
    isCompleted: false,
    dueDate: DateTime.now().add(const Duration(days: 2)),
  ),
];
