import 'package:zoey/features/text/models/text_model.dart';

final textList = [
  TextModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'text-content-1',
    title: 'Welcome to Zoey!',
    emoji: '👋',
    orderIndex: 1,
    description: (
      plainText:
          'Welcome to Zoey - your intelligent personal workspace! Zoey helps you organize thoughts, manage tasks, plan events, and structure ideas all in one beautiful, intuitive interface.\n\nThis guide will walk you through everything you need to know to get the most out of your Zoey experience. Let\'s get started!',
      htmlText:
          '<p>Welcome to <strong>Zoey</strong> - your intelligent personal workspace! Zoey helps you organize thoughts, manage tasks, plan events, and structure ideas all in one beautiful, intuitive interface.</p><p>This guide will walk you through everything you need to know to get the most out of your Zoey experience. Let\'s get started!</p>',
    ),
  ),
  TextModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'text-content-2',
    title: 'Understanding Sheets',
    emoji: '📋',
    orderIndex: 2,
    description: (
      plainText:
          'Sheets are your main workspaces in Zoey. Think of them as digital notebooks where you can combine different types of content:\n\n• Each sheet has a title, icon, and description\n• You can add multiple content blocks to organize information\n• Content blocks can be text, tasks, events, or lists\n• Everything is automatically saved as you work\n\nSheets appear on your home dashboard for easy access, and you can create as many as you need for different projects, goals, or topics.',
      htmlText:
          '<p>Sheets are your main workspaces in Zoey. Think of them as digital notebooks where you can combine different types of content:</p><ul><li>Each sheet has a title, icon, and description</li><li>You can add multiple content blocks to organize information</li><li>Content blocks can be text, tasks, events, or lists</li><li>Everything is automatically saved as you work</li></ul><p>Sheets appear on your home dashboard for easy access, and you can create as many as you need for different projects, goals, or topics.</p>',
    ),
  ),
  TextModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'text-content-3',
    title: 'Content Block Types',
    emoji: '🔧',
    orderIndex: 3,
    description: (
      plainText:
          'Zoey offers four powerful content block types to help you organize information effectively:\n\n📝 Text Blocks: Perfect for notes, ideas, documentation, and detailed explanations. Supports both plain text and rich HTML formatting.\n\n✅ Task Lists: Organize your to-dos with descriptions, due dates, and completion tracking. Great for project management and personal productivity.\n\n📅 Event Blocks: Schedule meetings, deadlines, and important dates with start and end times. Keep track of your calendar within your workspace.\n\n📋 List Blocks: Create bulleted lists, numbered lists, or simple collections. Perfect for organizing ideas, features, or any structured information.\n\nEach content type is designed to work together, so you can mix and match them within a single sheet to create the perfect workspace for your needs.',
      htmlText:
          '<p>Zoey offers four powerful content block types to help you organize information effectively:</p><p><strong>📝 Text Blocks:</strong> Perfect for notes, ideas, documentation, and detailed explanations. Supports both plain text and rich HTML formatting.</p><p><strong>✅ Task Lists:</strong> Organize your to-dos with descriptions, due dates, and completion tracking. Great for project management and personal productivity.</p><p><strong>📅 Event Blocks:</strong> Schedule meetings, deadlines, and important dates with start and end times. Keep track of your calendar within your workspace.</p><p><strong>📋 List Blocks:</strong> Create bulleted lists, numbered lists, or simple collections. Perfect for organizing ideas, features, or any structured information.</p><p>Each content type is designed to work together, so you can mix and match them within a single sheet to create the perfect workspace for your needs.</p>',
    ),
  ),
  TextModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'text-content-4',
    title: 'Tips for Success',
    emoji: '💡',
    orderIndex: 9,
    description: (
      plainText:
          'Here are some pro tips to help you make the most of Zoey:\n\n🎯 Start Small: Begin with one sheet and gradually add content as you get comfortable with the interface.\n\n📱 Use Icons: Choose meaningful icons for your sheets - they help you quickly identify different workspaces at a glance.\n\n📝 Be Descriptive: Add detailed descriptions to tasks and content blocks. Future you will thank you for the context!\n\n🔄 Stay Organized: Use the ordering system to arrange content logically within your sheets.\n\n⚡ Quick Actions: Look for quick action buttons and shortcuts throughout the interface to speed up your workflow.\n\n🏠 Home Dashboard: Your home screen shows all your sheets - use it as your central command center.',
      htmlText:
          '<p>Here are some pro tips to help you make the most of Zoey:</p><p><strong>🎯 Start Small:</strong> Begin with one sheet and gradually add content as you get comfortable with the interface.</p><p><strong>📱 Use Icons:</strong> Choose meaningful icons for your sheets - they help you quickly identify different workspaces at a glance.</p><p><strong>📝 Be Descriptive:</strong> Add detailed descriptions to tasks and content blocks. Future you will thank you for the context!</p><p><strong>🔄 Stay Organized:</strong> Use the ordering system to arrange content logically within your sheets.</p><p><strong>⚡ Quick Actions:</strong> Look for quick action buttons and shortcuts throughout the interface to speed up your workflow.</p><p><strong>🏠 Home Dashboard:</strong> Your home screen shows all your sheets - use it as your central command center.</p>',
    ),
  ),
  TextModel(
    sheetId: 'sheet-1',
    parentId: 'list-text-1',
    id: 'text-content-5',
    title: 'Getting Started with Text Blocks',
    orderIndex: 1,
    description: (
      plainText:
          'Text blocks are perfect for capturing detailed information, notes, and documentation. You can use them to write long-form content, explain complex concepts, or keep important reference materials. They support both plain text and rich HTML formatting for maximum flexibility.',
      htmlText:
          '<p><strong>Text blocks</strong> are perfect for capturing detailed information, notes, and documentation. You can use them to:</p><ul><li>Write long-form content</li><li>Explain complex concepts</li><li>Keep important reference materials</li></ul><p>They support both plain text and rich HTML formatting for maximum flexibility.</p>',
    ),
    emoji: '🚀',
  ),
  TextModel(
    sheetId: 'sheet-1',
    parentId: 'list-text-1',
    id: 'text-content-6',
    title: 'Best Practices for Text Organization',
    emoji: '💡',
    orderIndex: 2,
    description: (
      plainText:
          'When organizing text content, consider using clear headings, breaking up long paragraphs, and adding relevant emojis to make your content more scannable. Group related information together and use consistent formatting throughout your sheets for a professional appearance.',
      htmlText:
          '<p>When organizing text content, consider:</p><ul><li><strong>Clear headings</strong> - Make content easy to scan</li><li><strong>Breaking up paragraphs</strong> - Improve readability</li><li><strong>Relevant emojis</strong> - Add visual interest</li><li><strong>Consistent formatting</strong> - Maintain professionalism</li></ul><p>Group related information together for better organization.</p>',
    ),
  ),
];
