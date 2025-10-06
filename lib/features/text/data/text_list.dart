import 'package:zoe/features/text/models/text_model.dart';

final textList = [
  TextModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'text-content-1',
    title: 'Welcome to Zoe!',
    orderIndex: 1,
    description: (
      plainText:
          'Welcome to Zoe - your intelligent personal workspace! Zoe helps you organize thoughts, manage tasks, plan events, and structure ideas all in one beautiful, intuitive interface.\n\nThis guide will walk you through everything you need to know to get the most out of your Zoe experience. Let\'s get started!',
      htmlText:
          '<p>Welcome to <strong>Zoe</strong> - your intelligent personal workspace! Zoe helps you organize thoughts, manage tasks, plan events, and structure ideas all in one beautiful, intuitive interface.</p><p>This guide will walk you through everything you need to know to get the most out of your Zoe experience. Let\'s get started!</p>',
    ),
    createdBy: 'user_1',
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
          'Sheets are your main workspaces in Zoe. Think of them as digital notebooks where you can combine different types of content:\n\n• Each sheet has a title, icon, and description\n• You can add multiple content blocks to organize information\n• Content blocks can be text, tasks, events, or lists\n• Everything is automatically saved as you work\n\nSheets appear on your home dashboard for easy access, and you can create as many as you need for different projects, goals, or topics.',
      htmlText:
          '<p>Sheets are your main workspaces in Zoe. Think of them as digital notebooks where you can combine different types of content:</p><ul><li>Each sheet has a title, icon, and description</li><li>You can add multiple content blocks to organize information</li><li>Content blocks can be text, tasks, events, or lists</li><li>Everything is automatically saved as you work</li></ul><br><p>Sheets appear on your home dashboard for easy access, and you can create as many as you need for different projects, goals, or topics.</p>',
    ),
    createdBy: 'user_1',
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
          'Zoe offers four powerful content block types to help you organize information effectively:\n\n📝 Text Blocks: Perfect for notes, ideas, documentation, and detailed explanations. Supports both plain text and rich HTML formatting.\n\n✅ Task Lists: Organize your to-dos with descriptions, due dates, and completion tracking. Great for project management and personal productivity.\n\n📅 Event Blocks: Schedule meetings, deadlines, and important dates with start and end times. Keep track of your calendar within your workspace.\n\n📋 List Blocks: Create bulleted lists, numbered lists, or simple collections. Perfect for organizing ideas, features, or any structured information.\n\nEach content type is designed to work together, so you can mix and match them within a single sheet to create the perfect workspace for your needs.',
      htmlText:
          '<p>Zoe offers four powerful content block types to help you organize information effectively:</p><br><br><p><strong>📝 Text Blocks:</strong> Perfect for notes, ideas, documentation, and detailed explanations. Supports both plain text and rich HTML formatting.</p><br><br><p><strong>✅ Task Lists:</strong> Organize your to-dos with descriptions, due dates, and completion tracking. Great for project management and personal productivity.</p><br><br><p><strong>📅 Event Blocks:</strong> Schedule meetings, deadlines, and important dates with start and end times. Keep track of your calendar within your workspace.</p><br><br><p><strong>📋 List Blocks:</strong> Create bulleted lists, numbered lists, or simple collections. Perfect for organizing ideas, features, or any structured information.</p><br><br><p>Each content type is designed to work together, so you can mix and match them within a single sheet to create the perfect workspace for your needs.</p>',
    ),
    createdBy: 'user_2',
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
          'Here are some pro tips to help you make the most of Zoe:\n\n🎯 Start Small: Begin with one sheet and gradually add content as you get comfortable with the interface.\n\n📱 Use Icons: Choose meaningful icons for your sheets - they help you quickly identify different workspaces at a glance.\n\n📝 Be Descriptive: Add detailed descriptions to tasks and content blocks. Future you will thank you for the context!\n\n🔄 Stay Organized: Use the ordering system to arrange content logically within your sheets.\n\n⚡ Quick Actions: Look for quick action buttons and shortcuts throughout the interface to speed up your workflow.\n\n🏠 Home Dashboard: Your home screen shows all your sheets - use it as your central command center.',
      htmlText:
          '<p>Here are some pro tips to help you make the most of Zoe:</p><br><br><p><strong>🎯 Start Small:</strong> Begin with one sheet and gradually add content as you get comfortable with the interface.</p><br><br><p><strong>📱 Use Icons:</strong> Choose meaningful icons for your sheets - they help you quickly identify different workspaces at a glance.</p><br><br><p><strong>📝 Be Descriptive:</strong> Add detailed descriptions to tasks and content blocks. Future you will thank you for the context!</p><br><br><p><strong>🔄 Stay Organized:</strong> Use the ordering system to arrange content logically within your sheets.</p><br><br><p><strong>⚡ Quick Actions:</strong> Look for quick action buttons and shortcuts throughout the interface to speed up your workflow.</p><br><br><p><strong>🏠 Home Dashboard:</strong> Your home screen shows all your sheets - use it as your central command center.</p>',
    ),
    createdBy: 'user_2',
  ),
  // Trip Planning Text Content
  TextModel(
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    id: 'text-content-5',
    title: 'Adventure Awaits - Trip Planning Hub',
    emoji: '🗺️',
    orderIndex: 5,
    description: (
      plainText:
          'Pack your bags and get ready for an unforgettable journey! 🎒\n\nThis is our command center for planning the perfect getaway. From choosing dream destinations to coordinating every detail, we\'ve got everything covered.\n\n🗳️ Vote on destinations and travel preferences\n✅ Track preparation tasks and deadlines\n📅 Schedule planning meetings and important dates\n💭 Share travel ideas, memes, and excitement\n🔗 Store booking confirmations and travel resources\n📄 Keep all documents organized and accessible\n\nReady to create memories that will last a lifetime? Let\'s make this adventure epic! ✈️🌍',
      htmlText:
          '<p>Pack your bags and get ready for an <strong>unforgettable journey</strong>! 🎒</p><br><p>This is our command center for planning the perfect getaway. From choosing dream destinations to coordinating every detail, we\'ve got everything covered.</p><br><br><p><strong>🗳️ Vote</strong> on destinations and travel preferences</p><br><p><strong>✅ Track</strong> preparation tasks and deadlines</p><br><p><strong>📅 Schedule</strong> planning meetings and important dates</p><br><p><strong>💭 Share</strong> travel ideas, memes, and excitement</p><br><p><strong>🔗 Store</strong> booking confirmations and travel resources</p><br><p><strong>📄 Keep</strong> all documents organized and accessible</p><br><br><p>Ready to create memories that will last a lifetime? Let\'s make this adventure epic! ✈️🌍</p>',
    ),
    createdBy: 'user_1',
  ),
  // Christmas Planning Text Content
  TextModel(
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    id: 'text-content-6',
    title: 'Festive Magic - Christmas Celebration Center',
    emoji: '🎄',
    orderIndex: 5,
    description: (
      plainText:
          'Ho ho ho! Time to spread Christmas cheer! 🎅\n\nThis is our magical workshop for creating the most wonderful Christmas celebration ever. From planning the perfect party to coordinating festive activities, we\'re making this holiday season unforgettable.\n\n🗳️ Vote on venue and celebration preferences\n🎅 Track party preparation tasks and deadlines\n📅 Schedule planning meetings and festive events\n💬 Share Christmas ideas, memes, and holiday spirit\n🔗 Store booking confirmations and party resources\n📋 Keep all documents organized and accessible\n\nLet\'s deck the halls and make this Christmas absolutely magical! ✨🎁',
      htmlText:
          '<p>Ho ho ho! Time to spread <strong>Christmas cheer</strong>! 🎅</p><br><p>This is our magical workshop for creating the most wonderful Christmas celebration ever. From planning the perfect party to coordinating festive activities, we\'re making this holiday season unforgettable.</p><br><br><p><strong>🗳️ Vote</strong> on venue and celebration preferences</p><br><p><strong>🎅 Track</strong> party preparation tasks and deadlines</p><br><p><strong>📅 Schedule</strong> planning meetings and festive events</p><br><p><strong>💬 Share</strong> Christmas ideas, memes, and holiday spirit</p><br><p><strong>🔗 Store</strong> booking confirmations and party resources</p><br><p><strong>📋 Keep</strong> all documents organized and accessible</p><br><br><p>Let\'s deck the halls and make this Christmas absolutely magical! ✨🎁</p>',
    ),
    createdBy: 'user_2',
  ),
];
