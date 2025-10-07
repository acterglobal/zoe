import 'package:zoe/features/text/models/text_model.dart';

final textList = [
  TextModel(
    sheetId: 'sheet-1',
    parentId: 'sheet-1',
    id: 'text-content-1',
    title: 'Welcome to Zoe!',
    emoji: '👋',
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
  // Digital Organization Text Content
  TextModel(
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    id: 'text-content-7',
    title: 'Digital Clutter Crisis - Organization Hub',
    emoji: '🔍',
    orderIndex: 5,
    description: (
      plainText:
          'Drowning in digital chaos? You\'re not alone! 📱\n\nThis is our mission control for conquering digital clutter. From endless scrolling through chats to managing thousands of photos, we\'re creating systems that actually work.\n\n🗳️ Vote on your biggest digital challenges\n📱 Track organization tasks and cleanup progress\n📅 Schedule digital cleanup sessions\n💡 Share tips, frustrations, and solutions\n🔗 Store organization tools and resources\n📄 Keep important details accessible and organized\n\nLet\'s transform digital chaos into organized bliss! ✨🗂️',
      htmlText:
          '<p>Drowning in <strong>digital chaos</strong>? You\'re not alone! 📱</p><br><p>This is our mission control for conquering digital clutter. From endless scrolling through chats to managing thousands of photos, we\'re creating systems that actually work.</p><br><br><p><strong>🗳️ Vote</strong> on your biggest digital challenges</p><br><p><strong>📱 Track</strong> organization tasks and cleanup progress</p><br><p><strong>📅 Schedule</strong> digital cleanup sessions</p><br><p><strong>💡 Share</strong> tips, frustrations, and solutions</p><br><p><strong>🔗 Store</strong> organization tools and resources</p><br><p><strong>📄 Keep</strong> important details accessible and organized</p><br><br><p>Let\'s transform digital chaos into organized bliss! ✨🗂️</p>',
    ),
    createdBy: 'user_1',
  ),
  // Community Organization Text Content
  TextModel(
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    id: 'text-content-8',
    title: 'Community Chaos to Coordination - One-Stop Solution',
    emoji: '🏘️',
    orderIndex: 5,
    description: (
      plainText:
          'Drowning in 100+ notifications and scattered tools? You\'re not alone! 📱\n\nThis is your command center for community management. From organizing chat groups to tracking important clients, coordinating events, and managing tasks - Zoe brings everything together in one place.\n\n🗳️ Vote on community management challenges\n👥 Track community tasks and coordination efforts\n📅 Schedule community meetings and events\n💬 Share frustrations, solutions, and success stories\n🔗 Store community tools and resources\n📄 Keep all community documents organized\n\nTransform community chaos into seamless coordination! 🎯✨',
      htmlText:
          '<p>Drowning in <strong>100+ notifications and scattered tools</strong>? You\'re not alone! 📱</p><br><p>This is your command center for community management. From organizing chat groups to tracking important clients, coordinating events, and managing tasks - Zoe brings everything together in one place.</p><br><br><p><strong>🗳️ Vote</strong> on community management challenges</p><br><p><strong>👥 Track</strong> community tasks and coordination efforts</p><br><p><strong>📅 Schedule</strong> community meetings and events</p><br><p><strong>💬 Share</strong> frustrations, solutions, and success stories</p><br><p><strong>🔗 Store</strong> community tools and resources</p><br><p><strong>📄 Keep</strong> all community documents organized</p><br><br><p>Transform community chaos into seamless coordination! 🎯✨</p>',
    ),
    createdBy: 'user_2',
  ),
  // Chat Management Text Content
  TextModel(
    sheetId: 'sheet-6',
    parentId: 'sheet-6',
    id: 'text-content-9',
    title: 'End the Chat Chaos - Decision Making Hub',
    emoji: '💬',
    orderIndex: 5,
    description: (
      plainText:
          'Tired of endless "Friday or Sunday?" debates? We feel you! 😤\n\nThis is your solution for group chat chaos. From creating polls for quick decisions to tracking who\'s coming, organizing discussions, and putting an end to endless back-and-forth - Zoe helps you make decisions fast and stay organized.\n\n🗳️ Create polls for every group decision\n📱 Track attendance and who\'s coming\n📅 Organize chat topics and discussions\n😤 Share frustrations and celebrate solutions\n🔗 Store chat management tools and resources\n📄 Keep all group documents organized\n\nTransform chat chaos into organized decision-making! 🎯✨',
      htmlText:
          '<p>Tired of endless <strong>"Friday or Sunday?" debates</strong>? We feel you! 😤</p><br><p>This is your solution for group chat chaos. From creating polls for quick decisions to tracking who\'s coming, organizing discussions, and putting an end to endless back-and-forth - Zoe helps you make decisions fast and stay organized.</p><br><br><p><strong>🗳️ Create</strong> polls for every group decision</p><br><p><strong>📱 Track</strong> attendance and who\'s coming</p><br><p><strong>📅 Organize</strong> chat topics and discussions</p><br><p><strong>😤 Share</strong> frustrations and celebrate solutions</p><br><p><strong>🔗 Store</strong> chat management tools and resources</p><br><p><strong>📄 Keep</strong> all group documents organized</p><br><br><p>Transform chat chaos into organized decision-making! 🎯✨</p>',
    ),
    createdBy: 'user_3',
  ),
  // Exhibition Planning Text Content
  TextModel(
    sheetId: 'sheet-7',
    parentId: 'sheet-7',
    id: 'text-content-10',
    title: 'From Overwhelming Chaos to Organized Excellence',
    emoji: '🎨',
    orderIndex: 5,
    description: (
      plainText:
          'Planning an exhibition feels overwhelming? We get it! 😰\n\nPapers, notes, too many tools, but nothing is organized. Note apps, chat groups, calendars, paper flyers - so much stress and confusion! From food stalls to guest lists, stage management to vendor coordination - Zoe brings everything together in one organized place.\n\n🗳️ Vote on exhibition planning challenges\n🎨 Track exhibition tasks and coordination efforts\n📅 Schedule planning meetings and vendor coordination\n😰 Share frustrations and celebrate organized solutions\n🔗 Store exhibition tools and vendor resources\n📄 Keep all exhibition documents organized\n\nTransform overwhelming chaos into organized excellence! 🎯✨',
      htmlText:
          '<p>Planning an exhibition feels <strong>overwhelming</strong>? We get it! 😰</p><br><p>Papers, notes, too many tools, but nothing is organized. Note apps, chat groups, calendars, paper flyers - so much stress and confusion! From food stalls to guest lists, stage management to vendor coordination - Zoe brings everything together in one organized place.</p><br><br><p><strong>🗳️ Vote</strong> on exhibition planning challenges</p><br><p><strong>🎨 Track</strong> exhibition tasks and coordination efforts</p><br><p><strong>📅 Schedule</strong> planning meetings and vendor coordination</p><br><p><strong>😰 Share</strong> frustrations and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> exhibition tools and vendor resources</p><br><p><strong>📄 Keep</strong> all exhibition documents organized</p><br><br><p>Transform overwhelming chaos into organized excellence! 🎯✨</p>',
    ),
    createdBy: 'user_4',
  ),
  // School Fundraiser Text Content
  TextModel(
    sheetId: 'sheet-8',
    parentId: 'sheet-8',
    id: 'text-content-11',
    title: 'From Fundraiser Mayhem to Organized Success',
    emoji: '🎓',
    orderIndex: 5,
    description: (
      plainText:
          'It starts with one parent saying "Let\'s do a school fundraiser!" 😅\n\nThen suddenly: cupcakes everywhere, ticket lists flying, volunteer signups no one tracks, calendar overflowing! What should be fun turns into mayhem! Too many chats and questions like "Who\'s bringing cookies?" "When\'s the meeting?" "We need more flyers!"\n\n🗳️ Vote on fundraiser planning challenges\n🎓 Track cupcake coordination and ticket management\n📅 Schedule planning meetings and volunteer coordination\n😅 Share chaos stories and celebrate organized solutions\n🔗 Store fundraiser tools and parent resources\n📄 Keep all fundraiser documents organized\n\nTransform fundraiser mayhem into organized success! 🎯✨',
      htmlText:
          '<p>It starts with one parent saying <strong>"Let\'s do a school fundraiser!"</strong> 😅</p><br><p>Then suddenly: cupcakes everywhere, ticket lists flying, volunteer signups no one tracks, calendar overflowing! What should be fun turns into mayhem! Too many chats and questions like "Who\'s bringing cookies?" "When\'s the meeting?" "We need more flyers!"</p><br><br><p><strong>🗳️ Vote</strong> on fundraiser planning challenges</p><br><p><strong>🎓 Track</strong> cupcake coordination and ticket management</p><br><p><strong>📅 Schedule</strong> planning meetings and volunteer coordination</p><br><p><strong>😅 Share</strong> chaos stories and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> fundraiser tools and parent resources</p><br><p><strong>📄 Keep</strong> all fundraiser documents organized</p><br><br><p>Transform fundraiser mayhem into organized success! 🎯✨</p>',
    ),
    createdBy: 'user_5',
  ),
  // BBQ Planning Text Content
  TextModel(
    sheetId: 'sheet-9',
    parentId: 'sheet-9',
    id: 'text-content-12',
    title: 'From BBQ Chaos to Planning Paradise',
    emoji: '🔥',
    orderIndex: 5,
    description: (
      plainText:
          'Planning a BBQ always starts with fun ideas! 🔥\n\nBut then the group chat messages never stop! "I will bring chips, wait who\'s bringing the grill? We need veggie options, I can\'t eat pork, do not forget the drinks, I already bought plates! Guys, where is the BBQ planning? What time we are meeting?" Total confusion!\n\n🗳️ Vote on BBQ planning challenges\n🔥 Track equipment coordination and food planning\n📅 Schedule BBQ meetings and timing coordination\n😅 Share chaos stories and celebrate organized solutions\n🔗 Store BBQ tools and recipe resources\n📄 Keep all BBQ planning documents organized\n\nTransform BBQ chaos into planning paradise! 🎯✨',
      htmlText:
          '<p>Planning a BBQ always starts with <strong>fun ideas</strong>! 🔥</p><br><p>But then the group chat messages never stop! "I will bring chips, wait who\'s bringing the grill? We need veggie options, I can\'t eat pork, do not forget the drinks, I already bought plates! Guys, where is the BBQ planning? What time we are meeting?" Total confusion!</p><br><br><p><strong>🗳️ Vote</strong> on BBQ planning challenges</p><br><p><strong>🔥 Track</strong> equipment coordination and food planning</p><br><p><strong>📅 Schedule</strong> BBQ meetings and timing coordination</p><br><p><strong>😅 Share</strong> chaos stories and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> BBQ tools and recipe resources</p><br><p><strong>📄 Keep</strong> all BBQ planning documents organized</p><br><br><p>Transform BBQ chaos into planning paradise! 🎯✨</p>',
    ),
    createdBy: 'user_6',
  ),
  // University Hangout Text Content
  TextModel(
    sheetId: 'sheet-10',
    parentId: 'sheet-10',
    id: 'text-content-13',
    title: 'From University Chaos to Organized Fun',
    emoji: '🎓',
    orderIndex: 5,
    description: (
      plainText:
          'New at university? Making friends is exciting! 🎓\n\nNew group made, making friends is exciting, but organizing hangouts? Total chaos! When we meet? Which place? Not free Tuesday, change the time, different timetables, nobody replies, who\'s even coming? And nobody knows who\'s actually coming!\n\n🗳️ Vote on university hangout challenges\n🎓 Track schedules and coordinate timetables\n📅 Schedule hangouts and find perfect meeting spots\n😅 Share chaos stories and celebrate organized solutions\n🔗 Store university hangout tools and campus resources\n📄 Keep all hangout planning documents organized\n\nTransform university chaos into organized fun! 🎯✨',
      htmlText:
          '<p>New at university? <strong>Making friends is exciting</strong>! 🎓</p><br><p>New group made, making friends is exciting, but organizing hangouts? Total chaos! When we meet? Which place? Not free Tuesday, change the time, different timetables, nobody replies, who\'s even coming? And nobody knows who\'s actually coming!</p><br><br><p><strong>🗳️ Vote</strong> on university hangout challenges</p><br><p><strong>🎓 Track</strong> schedules and coordinate timetables</p><br><p><strong>📅 Schedule</strong> hangouts and find perfect meeting spots</p><br><p><strong>😅 Share</strong> chaos stories and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> university hangout tools and campus resources</p><br><p><strong>📄 Keep</strong> all hangout planning documents organized</p><br><br><p>Transform university chaos into organized fun! 🎯✨</p>',
    ),
    createdBy: 'user_7',
  ),
];
