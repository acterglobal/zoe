import 'package:zoey/features/contents/text/models/text_content_model.dart';
import 'package:zoey/features/contents/todos/models/todos_content_model.dart';
import 'package:zoey/features/contents/events/models/events_content_model.dart';
import 'package:zoey/features/contents/bullet-lists/models/bullets_content_model.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';

final gettingStartedSheet = ZoeSheetModel(
  id: 'sheet-1',
  title: 'Getting Started Guide',
  description: 'Learn how to use Zoey effectively',
  emoji: '🚀',
  contentBlocks: [
    TextContentModel(
      parentId: 'sheet-1',
      id: 'text-content-1',
      title: 'Welcome to Zoey!',
      data:
          'Zoey is your personal workspace for organizing thoughts, tasks, and ideas. This guide will help you understand all the features and get the most out of your experience.',
    ),
    BulletsContentModel(
      parentId: 'sheet-1',
      id: 'bullets-content-1',
      title: 'Key Features Overview',
      bullets: [
        '📄 Create unlimited sheets with custom titles and emojis',
        '📝 Add different content blocks: text, tasks, events, and lists',
        '✏️ Edit content inline by tapping on any text',
        '🎨 Customize sheets with emojis and descriptions',
        '📱 Access everything from the home dashboard',
        '🔍 Quick actions for common tasks',
      ],
    ),
    TodosContentModel(
      parentId: 'sheet-1',
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
          description:
              'See how to organize a real project with tasks and events',
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
    TextContentModel(
      parentId: 'sheet-1',
      id: 'text-content-2',
      title: 'How to Use Content Blocks',
      data:
          'Content blocks are the building blocks of your sheets. Tap the + button to add new blocks:\n\n• Text Blocks: For notes, ideas, and documentation\n• Task Lists: For to-dos with descriptions and due dates\n• Event Blocks: For scheduling with start and end dates\n• List Blocks: For simple bullet points and collections\n\nYou can drag and drop blocks to reorder them, and edit any text by tapping on it.',
    ),
    EventsContentModel(
      parentId: 'sheet-1',
      id: 'events-content-1',
      title: 'Learning Schedule',
      events: [
        EventItem(
          title: 'Explore Getting Started Guide',
          description: 'Read through this guide and try the features',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(minutes: 30)),
        ),
        EventItem(
          title: 'Practice Session',
          description: 'Create your first custom sheet and add content',
          startDate: DateTime.now().add(const Duration(hours: 1)),
          endDate: DateTime.now().add(const Duration(hours: 2)),
        ),
        EventItem(
          title: 'Team Review Meeting',
          description: 'Review progress and discuss next steps',
          startDate: DateTime.now().add(const Duration(days: 1, hours: 10)),
          endDate: DateTime.now().add(const Duration(days: 1, hours: 11)),
        ),
      ],
    ),
    BulletsContentModel(
      parentId: 'sheet-1',
      id: 'bullets-content-2',
      title: 'Pro Tips',
      bullets: [
        'Use emojis to quickly identify different types of sheets',
        'Add detailed descriptions to tasks for better context',
        'Set due dates to stay organized and on track',
        'Assign tasks to team members for collaboration',
        'Use events to schedule meetings and deadlines',
        'Check the home dashboard for easy access',
        'The drawer menu shows all your sheets for quick access',
      ],
    ),
  ],
);
