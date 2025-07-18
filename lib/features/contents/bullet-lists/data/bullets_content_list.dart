import 'package:zoey/features/contents/bullet-lists/models/bullets_content_model.dart';

final bulletsContentList = [
  BulletsContentModel(
    parentId: 'sheet-1',
    id: 'bullets-content-1',
    title: 'Key Features Overview',
    bullets: [
      'Create unlimited sheets with custom titles and icons',
      'Add different content blocks: text, tasks, events, and lists',
      'Edit content inline by tapping on any text',
      'Customize sheets with icons and descriptions',
      'Access everything from the home dashboard',
      'Quick actions for common tasks',
    ],
  ),
  BulletsContentModel(
    parentId: 'sheet-1',
    id: 'bullets-content-2',
    title: 'Pro Tips',
    bullets: [
      'Use icons to quickly identify different types of sheets',
      'Add detailed descriptions to tasks for better context',
      'Set due dates to stay organized and on track',
      'Assign tasks to team members for collaboration',
      'Use events to schedule meetings and deadlines',
      'Check the home dashboard for easy access',
      'The drawer menu shows all your sheets for quick access',
    ],
  ),
];
