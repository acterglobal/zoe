import 'package:zoey/features/bullet-lists/models/bullets_content_model.dart';

final bulletsContentList = [
  BulletsContentModel(
    parentId: 'sheet-1',
    id: 'bullets-content-1',
    title: 'Key Features Overview',
    bullets: [
      BulletItem(title: 'Create unlimited sheets with custom titles and icons'),
      BulletItem(
        title: 'Add different content blocks: text, tasks, events, and lists',
      ),
      BulletItem(title: 'Edit content inline by tapping on any text'),
      BulletItem(title: 'Customize sheets with icons and descriptions'),
      BulletItem(title: 'Access everything from the home dashboard'),
      BulletItem(title: 'Quick actions for common tasks'),
    ],
  ),
  BulletsContentModel(
    parentId: 'sheet-1',
    id: 'bullets-content-2',
    title: 'Pro Tips',
    bullets: [
      BulletItem(
        title: 'Use icons to quickly identify different types of sheets',
      ),
      BulletItem(
        title: 'Add detailed descriptions to tasks for better context',
        description:
            'Descriptions help provide context and additional information',
      ),
      BulletItem(title: 'Set due dates to stay organized and on track'),
      BulletItem(title: 'Assign tasks to team members for collaboration'),
      BulletItem(title: 'Use events to schedule meetings and deadlines'),
      BulletItem(title: 'Check the home dashboard for easy access'),
      BulletItem(
        title: 'The drawer menu shows all your sheets for quick access',
      ),
    ],
  ),
];
