import 'package:zoey/features/text_block/models/text_block_model.dart';

final textBlockList = [
  TextBlockModel(
    sheetId: 'sheet-1',
    id: 'text-block-1',
    title: 'Welcome to Zoey!',
    plainTextDescription:
        'Zoey is your personal workspace for organizing thoughts, tasks, and ideas. This guide will help you understand all the features and get the most out of your experience.',
    htmlDescription:
        '<p>Zoey is your personal workspace for organizing thoughts, tasks, and ideas. This guide will help you understand all the features and get the most out of your experience.</p>',
  ),
  TextBlockModel(
    sheetId: 'sheet-1',
    id: 'text-block-2',
    title: 'How to Use Text Blocks',
    plainTextDescription:
        'Text blocks are the building blocks of your sheets. Tap the + button to add new blocks:\n\n• Text Blocks: For notes, ideas, and documentation\n• Task Lists: For to-dos with descriptions and due dates\n• Event Blocks: For scheduling with start and end dates\n• List Blocks: For simple bullet points and collections\n\nYou can drag and drop blocks to reorder them, and edit any text by tapping on it.',
    htmlDescription:
        '<p>Text blocks are the building blocks of your sheets. Tap the + button to add new blocks:</p><ul><li>Text Blocks: For notes, ideas, and documentation</li><li>Task Lists: For to-dos with descriptions and due dates</li><li>Event Blocks: For scheduling with start and end dates</li><li>List Blocks: For simple bullet points and collections</li></ul><p>You can drag and drop blocks to reorder them, and edit any text by tapping on it.</p>',
  ),
];
