import 'package:zoey/features/list_block/models/list_block_model.dart';

final listBlockList = [
  ListBlockModel(
    parentId: 'sheet-1',
    id: 'list-block-1',
    title: 'Key Features Overview',
    listItems: [
      ListItem(title: 'Create unlimited sheets with custom titles and icons'),
      ListItem(
        title: 'Add different content blocks: text, tasks, events, and lists',
      ),
      ListItem(title: 'Edit content inline by tapping on any text'),
      ListItem(title: 'Customize sheets with icons and descriptions'),
      ListItem(title: 'Access everything from the home dashboard'),
      ListItem(title: 'Quick actions for common tasks'),
    ],
  ),
  ListBlockModel(
    parentId: 'sheet-1',
    id: 'list-block-2',
    title: 'Pro Tips',
    listItems: [
      ListItem(
        title: 'Use icons to quickly identify different types of sheets',
      ),
      ListItem(
        title: 'Add detailed descriptions to tasks for better context',
        description:
            'Descriptions help provide context and additional information',
      ),
      ListItem(title: 'Set due dates to stay organized and on track'),
      ListItem(title: 'Assign tasks to team members for collaboration'),
      ListItem(title: 'Use events to schedule meetings and deadlines'),
      ListItem(title: 'Check the home dashboard for easy access'),
      ListItem(title: 'The drawer menu shows all your sheets for quick access'),
    ],
  ),
];
