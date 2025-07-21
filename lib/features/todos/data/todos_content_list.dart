import 'package:zoey/features/todos/models/todos_content_model.dart';

final todosContentList = [
  TodosContentModel(
    sheetId: 'sheet-1',
    id: 'todos-content-1',
    title: 'Quick Start Checklist',
    items: [
      TodoItem(
        title: 'Explore this Getting Started sheet',
        description: 'Read through this guide to understand Zoey\'s features',
        isCompleted: true,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        assignees: ['You'],
      ),
      TodoItem(
        title: 'Check out the Productivity Workspace example',
        description: 'See how to organize a real project with tasks and events',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(hours: 2)),
        assignees: ['You', 'Team Lead'],
      ),
      TodoItem(
        title: 'Create your first custom sheet',
        description: 'Try creating a sheet for a personal project or goal',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        assignees: ['You'],
      ),
      TodoItem(
        title: 'Add different content blocks',
        description: 'Experiment with text, tasks, events, and lists',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        assignees: ['You'],
      ),
      TodoItem(
        title: 'Customize your workspace',
        description: 'Add emojis, organize sheets, and make it your own',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        assignees: ['You'],
      ),
    ],
  ),
  TodosContentModel(
    sheetId: 'sheet-1',
    id: 'todos-content-2',
    title: 'Productivity Workspace',
    items: [
      TodoItem(
        title: 'Explore Getting Started Guide',
        description: 'Read through this guide and try the features',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        assignees: ['You', 'Designer'],
      ),
      TodoItem(
        title: 'Check out the Productivity Workspace example',
        description: 'See how to organize a real project with tasks and events',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        assignees: ['You', 'Developer'],
      ),
    ],
  ),
];
