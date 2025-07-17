import 'package:zoey/features/sheet/models/content_block/event_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/list_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/text_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/todo_block_model.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';

final gettingStartedSheet = ZoeSheetModel(
  title: 'Getting Started Guide',
  description: 'Learn how to use Zoey effectively',
  emoji: '🚀',
  isWhatsAppConnected: true,
  contentBlocks: [
    TextBlockModel(
      title: 'Welcome to Zoey!',
      content:
          'Zoey is your personal workspace for organizing thoughts, tasks, and ideas. This guide will help you understand all the features and get the most out of your experience.',
    ),
    ListBlockModel(
      title: 'Key Features Overview',
      items: [
        '📄 Create unlimited sheets with custom titles and emojis',
        '📝 Add different content blocks: text, tasks, events, and lists',
        '✏️ Edit content inline by tapping on any text',
        '🎨 Customize sheets with emojis and descriptions',
        '📱 Access everything from the home dashboard',
        '🔍 Quick actions for common tasks',
      ],
    ),
    TodoBlockModel(
      title: 'Quick Start Checklist',
      items: [
        TodoItem(
          text: 'Explore this Getting Started sheet',
          isCompleted: true,
          priority: TodoPriority.high,
          description: 'Read through this guide to understand Zoey\'s features',
          tags: ['tutorial', 'getting-started'],
        ),
        TodoItem(
          text: 'Check out the Productivity Workspace example',
          isCompleted: false,
          priority: TodoPriority.high,
          description:
              'See how to organize a real project with tasks and events',
          tags: ['tutorial', 'example'],
        ),
        TodoItem(
          text: 'Create your first custom sheet',
          isCompleted: false,
          priority: TodoPriority.medium,
          dueDate: DateTime.now().add(const Duration(hours: 2)),
          description: 'Try creating a sheet for a personal project or goal',
          tags: ['hands-on', 'practice'],
        ),
        TodoItem(
          text: 'Add different content blocks',
          isCompleted: false,
          priority: TodoPriority.medium,
          description: 'Experiment with text, tasks, events, and lists',
          tags: ['practice', 'content-blocks'],
        ),
        TodoItem(
          text: 'Customize your workspace',
          isCompleted: false,
          priority: TodoPriority.low,
          dueDate: DateTime.now().add(const Duration(days: 1)),
          description: 'Add emojis, organize sheets, and make it your own',
          tags: ['customization', 'personal'],
        ),
      ],
    ),
    TextBlockModel(
      title: 'How to Use Content Blocks',
      content:
          'Content blocks are the building blocks of your sheets. Tap the + button to add new blocks:\n\n• Text Blocks: For notes, ideas, and documentation\n• Task Lists: For to-dos with priorities and due dates\n• Event Blocks: For scheduling and calendar items\n• List Blocks: For simple bullet points and collections\n\nYou can drag and drop blocks to reorder them, and edit any text by tapping on it.',
    ),
    EventBlockModel(
      title: 'Learning Schedule',
      events: [
        EventItem(
          title: 'Explore Getting Started Guide',
          description: 'Read through this guide and try the features',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(minutes: 30)),
          location: EventLocation(physical: 'Your current location'),
          requiresRSVP: false,
        ),
        EventItem(
          title: 'Practice Session',
          description: 'Create your first custom sheet and add content',
          startTime: DateTime.now().add(const Duration(hours: 1)),
          endTime: DateTime.now().add(const Duration(hours: 2)),
          location: EventLocation(physical: 'Anywhere you\'re comfortable'),
          requiresRSVP: false,
        ),
      ],
    ),
    ListBlockModel(
      title: 'Pro Tips',
      items: [
        'Use emojis to quickly identify different types of sheets',
        'Set due dates on tasks to stay organized',
        'Add descriptions to tasks for more context',
        'Use tags to categorize and find content later',
        'Check the home dashboard for today\'s priorities',
        'The drawer menu shows all your sheets for quick access',
      ],
    ),
  ],
);
