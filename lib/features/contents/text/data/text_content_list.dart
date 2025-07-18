import 'package:zoey/features/contents/text/models/text_content_model.dart';

final textContentList = [
  TextContentModel(
    parentId: 'sheet-1',
    id: 'text-1',
    title: 'Welcome to Zoey!',
    data:
        'Zoey is your personal workspace for organizing thoughts, tasks, and ideas. This guide will help you understand all the features and get the most out of your experience.',
  ),
  TextContentModel(
    parentId: 'sheet-1',
    id: 'text-2',
    title: 'How to Use Content Blocks',
    data:
        'Content blocks are the building blocks of your sheets. Tap the + button to add new blocks:\n\n• Text Blocks: For notes, ideas, and documentation\n• Task Lists: For to-dos with descriptions and due dates\n• Event Blocks: For scheduling with start and end dates\n• List Blocks: For simple bullet points and collections\n\nYou can drag and drop blocks to reorder them, and edit any text by tapping on it.',
  ),
];
