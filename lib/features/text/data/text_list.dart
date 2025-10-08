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
          'Pack your bags and get ready for an unforgettable journey! 🎒\n\nThis is our organized command center for planning the perfect getaway. From choosing dream destinations to coordinating every detail, we\'ve got everything covered with reliable planning tools.\n\n🗳️ Vote on destinations and flight preferences (morning vs evening)\n✅ Track preparation tasks and deadlines systematically\n📅 Schedule planning meetings and important dates\n💭 Share travel ideas, memes, and excitement\n🔗 Store booking confirmations and travel resources\n📄 Keep all documents organized and accessible\n\nReady to create memories that will last a lifetime? Let\'s make this adventure epic! ✈️🌍',
      htmlText:
          '<p>Pack your bags and get ready for an <strong>unforgettable journey</strong>! 🎒</p><br><p>This is our <strong>organized command center</strong> for planning the perfect getaway. From choosing dream destinations to coordinating every detail, we\'ve got everything covered with reliable planning tools.</p><br><br><p><strong>🗳️ Vote</strong> on destinations and flight preferences (morning vs evening)</p><br><p><strong>✅ Track</strong> preparation tasks and deadlines systematically</p><br><p><strong>📅 Schedule</strong> planning meetings and important dates</p><br><p><strong>💭 Share</strong> travel ideas, memes, and excitement</p><br><p><strong>🔗 Store</strong> booking confirmations and travel resources</p><br><p><strong>📄 Keep</strong> all documents organized and accessible</p><br><br><p>Ready to create memories that will last a lifetime? Let\'s make this adventure epic! ✈️🌍</p>',
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
          'Your command center for community management! 📱\n\nThis workspace helps you organize 100+ notifications and scattered tools. From organizing chat groups to tracking important clients, coordinating events, and managing tasks - bring everything together in one place.\n\n🗳️ Vote on community management challenges\n👥 Track community tasks and coordination efforts\n📅 Schedule community meetings and events\n💬 Share frustrations, solutions, and success stories\n🔗 Store community tools and resources\n📄 Keep all community documents organized\n\nTransform community chaos into seamless coordination! 🎯✨',
      htmlText:
          '<p>Your <strong>command center for community management</strong>! 📱</p><br><p>This workspace helps you organize 100+ notifications and scattered tools. From organizing chat groups to tracking important clients, coordinating events, and managing tasks - bring everything together in one place.</p><br><br><p><strong>🗳️ Vote</strong> on community management challenges</p><br><p><strong>👥 Track</strong> community tasks and coordination efforts</p><br><p><strong>📅 Schedule</strong> community meetings and events</p><br><p><strong>💬 Share</strong> frustrations, solutions, and success stories</p><br><p><strong>🔗 Store</strong> community tools and resources</p><br><p><strong>📄 Keep</strong> all community documents organized</p><br><br><p>Transform community chaos into seamless coordination! 🎯✨</p>',
    ),
    createdBy: 'user_2',
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
          'Your organized workspace for exhibition planning! 😰\n\nThis hub helps you manage papers, notes, and multiple tools that were previously scattered. Note apps, chat groups, calendars, paper flyers - so much stress and confusion! From food stalls to guest lists, stage management to vendor coordination - bring everything together in one organized place.\n\n🗳️ Vote on exhibition planning challenges\n🎨 Track exhibition tasks and coordination efforts\n📅 Schedule planning meetings and vendor coordination\n😰 Share frustrations and celebrate organized solutions\n🔗 Store exhibition tools and vendor resources\n📄 Keep all exhibition documents organized\n\nTransform overwhelming chaos into organized excellence! 🎯✨',
      htmlText:
          '<p>Your <strong>organized workspace for exhibition planning</strong>! 😰</p><br><p>This hub helps you manage papers, notes, and multiple tools that were previously scattered. Note apps, chat groups, calendars, paper flyers - so much stress and confusion! From food stalls to guest lists, stage management to vendor coordination - bring everything together in one organized place.</p><br><br><p><strong>🗳️ Vote</strong> on exhibition planning challenges</p><br><p><strong>🎨 Track</strong> exhibition tasks and coordination efforts</p><br><p><strong>📅 Schedule</strong> planning meetings and vendor coordination</p><br><p><strong>😰 Share</strong> frustrations and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> exhibition tools and vendor resources</p><br><p><strong>📄 Keep</strong> all exhibition documents organized</p><br><br><p>Transform overwhelming chaos into organized excellence! 🎯✨</p>',
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
          'Your organized workspace for school fundraiser success! 😅\n\nThis hub helps you manage cupcake coordination, ticket lists, volunteer signups, and calendar overflow. Transform what should be fun from mayhem into organized success with clear coordination and planning.\n\n🗳️ Vote on fundraiser planning challenges\n🎓 Track cupcake coordination and ticket management\n📅 Schedule planning meetings and volunteer coordination\n😅 Share chaos stories and celebrate organized solutions\n🔗 Store fundraiser tools and parent resources\n📄 Keep all fundraiser documents organized\n\nTransform fundraiser mayhem into organized success! 🎯✨',
      htmlText:
          '<p>Your <strong>organized workspace for school fundraiser success</strong>! 😅</p><br><p>This hub helps you manage cupcake coordination, ticket lists, volunteer signups, and calendar overflow. Transform what should be fun from mayhem into organized success with clear coordination and planning.</p><br><br><p><strong>🗳️ Vote</strong> on fundraiser planning challenges</p><br><p><strong>🎓 Track</strong> cupcake coordination and ticket management</p><br><p><strong>📅 Schedule</strong> planning meetings and volunteer coordination</p><br><p><strong>😅 Share</strong> chaos stories and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> fundraiser tools and parent resources</p><br><p><strong>📄 Keep</strong> all fundraiser documents organized</p><br><br><p>Transform fundraiser mayhem into organized success! 🎯✨</p>',
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
          'Your organized workspace for BBQ planning paradise! 🔥\n\nThis hub helps you coordinate group chat messages, equipment planning, dietary restrictions, and meeting logistics. Transform BBQ planning from total confusion into organized fun with clear coordination.\n\n🗳️ Vote on BBQ planning challenges\n🔥 Track equipment coordination and food planning\n📅 Schedule BBQ meetings and timing coordination\n😅 Share chaos stories and celebrate organized solutions\n🔗 Store BBQ tools and recipe resources\n📄 Keep all BBQ planning documents organized\n\nTransform BBQ chaos into planning paradise! 🎯✨',
      htmlText:
          '<p>Your <strong>organized workspace for BBQ planning paradise</strong>! 🔥</p><br><p>This hub helps you coordinate group chat messages, equipment planning, dietary restrictions, and meeting logistics. Transform BBQ planning from total confusion into organized fun with clear coordination.</p><br><br><p><strong>🗳️ Vote</strong> on BBQ planning challenges</p><br><p><strong>🔥 Track</strong> equipment coordination and food planning</p><br><p><strong>📅 Schedule</strong> BBQ meetings and timing coordination</p><br><p><strong>😅 Share</strong> chaos stories and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> BBQ tools and recipe resources</p><br><p><strong>📄 Keep</strong> all BBQ planning documents organized</p><br><br><p>Transform BBQ chaos into planning paradise! 🎯✨</p>',
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
          'Your organized workspace for university hangout coordination! 🎓\n\nThis hub helps you manage different timetables, meeting places, and attendance tracking. Transform hangout planning from total chaos into organized fun with calendar, checklist, poll, and attendance management.\n\n🗳️ Vote on university hangout challenges\n🎓 Track schedules and coordinate timetables\n📅 Schedule hangouts and find perfect meeting spots\n😅 Share chaos stories and celebrate organized solutions\n🔗 Store university hangout tools and campus resources\n📄 Keep all hangout planning documents organized\n\nTransform university chaos into organized fun! 🎯✨',
      htmlText:
          '<p>Your <strong>organized workspace for university hangout coordination</strong>! 🎓</p><br><p>This hub helps you manage different timetables, meeting places, and attendance tracking. Transform hangout planning from total chaos into organized fun with calendar, checklist, poll, and attendance management.</p><br><br><p><strong>🗳️ Vote</strong> on university hangout challenges</p><br><p><strong>🎓 Track</strong> schedules and coordinate timetables</p><br><p><strong>📅 Schedule</strong> hangouts and find perfect meeting spots</p><br><p><strong>😅 Share</strong> chaos stories and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> university hangout tools and campus resources</p><br><p><strong>📄 Keep</strong> all hangout planning documents organized</p><br><br><p>Transform university chaos into organized fun! 🎯✨</p>',
    ),
    createdBy: 'user_7',
  ),
  // Book Club Text Content
  TextModel(
    sheetId: 'sheet-11',
    parentId: 'sheet-11',
    id: 'text-content-14',
    title: 'From Book Club Stress to Story Paradise',
    emoji: '📚',
    orderIndex: 5,
    description: (
      plainText:
          'Your organized workspace for book club paradise! 📚\n\nThis hub helps you manage monthly meeting scheduling, hosting rotation, and book selection. Transform book club planning from stressful chaos into organized fun with one place for book, task, and calendar management.\n\n🗳️ Vote on book club planning challenges\n📚 Track book selection and hosting rotation\n📅 Schedule monthly meetings and coordinate dates\n😅 Share stress stories and celebrate organized solutions\n🔗 Store book club tools and reading resources\n📄 Keep all book club documents organized\n\nTransform book club stress into story paradise! 🎯✨',
      htmlText:
          '<p>Your <strong>organized workspace for book club paradise</strong>! 📚</p><br><p>This hub helps you manage monthly meeting scheduling, hosting rotation, and book selection. Transform book club planning from stressful chaos into organized fun with one place for book, task, and calendar management.</p><br><br><p><strong>🗳️ Vote</strong> on book club planning challenges</p><br><p><strong>📚 Track</strong> book selection and hosting rotation</p><br><p><strong>📅 Schedule</strong> monthly meetings and coordinate dates</p><br><p><strong>😅 Share</strong> stress stories and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> book club tools and reading resources</p><br><p><strong>📄 Keep</strong> all book club documents organized</p><br><br><p>Transform book club stress into story paradise! 🎯✨</p>',
    ),
    createdBy: 'user_8',
  ),
  // Softball Club BBQ Party Text Content
  TextModel(
    sheetId: 'sheet-12',
    parentId: 'sheet-12',
    id: 'text-content-15',
    title: 'From Softball Club BBQ Chaos to Success Paradise',
    emoji: '⚾',
    orderIndex: 5,
    description: (
      plainText:
          'Your organized workspace for softball club BBQ party planning! ⚾\n\nThis hub helps you coordinate date finding, decision making, and attendance tracking. Transform BBQ party planning from endless confusion into organized success with clear coordination and planning.\n\n🗳️ Vote on softball club BBQ planning challenges\n⚾ Track date coordination and decision making\n📅 Schedule BBQ party and coordinate attendance\n😅 Share chaos stories and celebrate organized solutions\n🔗 Store softball club tools and BBQ resources\n📄 Keep all party planning documents organized\n\nTransform softball club BBQ chaos into success paradise! 🎯✨',
      htmlText:
          '<p>Your <strong>organized workspace for softball club BBQ party planning</strong>! ⚾</p><br><p>This hub helps you coordinate date finding, decision making, and attendance tracking. Transform BBQ party planning from endless confusion into organized success with clear coordination and planning.</p><br><br><p><strong>🗳️ Vote</strong> on softball club BBQ planning challenges</p><br><p><strong>⚾ Track</strong> date coordination and decision making</p><br><p><strong>📅 Schedule</strong> BBQ party and coordinate attendance</p><br><p><strong>😅 Share</strong> chaos stories and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> softball club tools and BBQ resources</p><br><p><strong>📄 Keep</strong> all party planning documents organized</p><br><br><p>Transform softball club BBQ chaos into success paradise! 🎯✨</p>',
    ),
    createdBy: 'user_1',
  ),
  // Bachelorette Party Text Content
  TextModel(
    sheetId: 'sheet-13',
    parentId: 'sheet-13',
    id: 'text-content-16',
    title: 'From Bachelorette Party Stress to Celebration Paradise',
    emoji: '💃',
    orderIndex: 5,
    description: (
      plainText:
          'Your organized workspace for bachelorette party paradise! 💃\n\nThis hub helps you manage group chat coordination, date planning, budget decisions, and activity selection. Transform bachelorette party planning from stressful chaos into organized fun with clear coordination and planning.\n\n🗳️ Vote on bachelorette party planning challenges\n💃 Track theme selection and activity coordination\n📅 Schedule party dates and coordinate availability\n😅 Share stress stories and celebrate organized solutions\n🔗 Store bachelorette party tools and celebration resources\n📄 Keep all party planning documents organized\n\nTransform bachelorette party stress into celebration paradise! 🎯✨',
      htmlText:
          '<p>Your <strong>organized workspace for bachelorette party paradise</strong>! 💃</p><br><p>This hub helps you manage group chat coordination, date planning, budget decisions, and activity selection. Transform bachelorette party planning from stressful chaos into organized fun with clear coordination and planning.</p><br><br><p><strong>🗳️ Vote</strong> on bachelorette party planning challenges</p><br><p><strong>💃 Track</strong> theme selection and activity coordination</p><br><p><strong>📅 Schedule</strong> party dates and coordinate availability</p><br><p><strong>😅 Share</strong> stress stories and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> bachelorette party tools and celebration resources</p><br><p><strong>📄 Keep</strong> all party planning documents organized</p><br><br><p>Transform bachelorette party stress into celebration paradise! 🎯✨</p>',
    ),
    createdBy: 'user_2',
  ),
  // Church Summer Fest 2026 Text Content
  TextModel(
    sheetId: 'sheet-14',
    parentId: 'sheet-14',
    id: 'text-content-17',
    title: 'From Church Summer Fest Chaos to Community Success',
    emoji: '⛪',
    orderIndex: 5,
    description: (
      plainText:
          'Your organized workspace for Church Summer Fest 2026! ⛪\n\nThis hub helps you coordinate food planning, budget management, date scheduling, and equipment coordination. Transform festival planning from total chaos into organized success with clear coordination and planning.\n\n🗳️ Vote on church summer fest planning challenges\n⛪ Track food coordination and budget planning\n📅 Schedule fest dates and resolve conflicts\n😅 Share chaos stories and celebrate organized solutions\n🔗 Store church fest tools and community resources\n📄 Keep all fest planning documents organized\n\nTransform church summer fest chaos into community success! 🎯✨',
      htmlText:
          '<p>Your <strong>organized workspace for Church Summer Fest 2026</strong>! ⛪</p><br><p>This hub helps you coordinate food planning, budget management, date scheduling, and equipment coordination. Transform festival planning from total chaos into organized success with clear coordination and planning.</p><br><br><p><strong>🗳️ Vote</strong> on church summer fest planning challenges</p><br><p><strong>⛪ Track</strong> food coordination and budget planning</p><br><p><strong>📅 Schedule</strong> fest dates and resolve conflicts</p><br><p><strong>😅 Share</strong> chaos stories and celebrate organized solutions</p><br><p><strong>🔗 Store</strong> church fest tools and community resources</p><br><p><strong>📄 Keep</strong> all fest planning documents organized</p><br><br><p>Transform church summer fest chaos into community success! 🎯✨</p>',
    ),
    createdBy: 'user_3',
  ),
  TextModel(
    id: 'text-content-18',
    sheetId: 'sheet-15',
    parentId: 'sheet-15',
    title: 'From PTA Bake Sale Chaos to Sweet Success Paradise',
    orderIndex: 6,
    description: (
      plainText:
          '🧁 PTA Bake Sale Success Hub - Your organized command center for school fundraising!\n\n'
          'The moms are full of energy, everyone excited to start baking together, but in group chat total chaos! Everyone nothing clear, coordination issues, scheduling conflicts, budget confusion, and details lost!\n\n'
          '🎯 This workspace transforms PTA bake sale planning from chaos to success:\n'
          '• Baking assignments and coordination (no more confusion)\n'
          '• Dietary restrictions and special needs (gluten-free, allergies, preferences)\n'
          '• Scheduling conflicts and availability (find dates that work for everyone)\n'
          '• Budget and payment coordination (clear financial planning and tracking)\n\n'
          '✨ Create reliable planning tools, systematically organize baking tasks, handle dietary requirements, and coordinate schedules!',
      htmlText:
          '<p><strong>🧁 PTA Bake Sale Success Hub</strong> - Your organized command center for school fundraising!</p>\n'
          '<p>The moms are full of energy, everyone excited to start baking together, but in group chat total chaos! Everyone nothing clear, coordination issues, scheduling conflicts, budget confusion, and details lost!</p><br><br>\n'
          '<p><strong>🎯 This workspace transforms PTA bake sale planning from chaos to success:</strong></p><br><br>\n'
          '<p>• Baking assignments and coordination (no more confusion)<br>\n'
          '• Dietary restrictions and special needs (gluten-free, allergies, preferences)<br>\n'
          '• Scheduling conflicts and availability (find dates that work for everyone)<br>\n'
          '• Budget and payment coordination (clear financial planning and tracking)</p><br><br>\n'
          '<p><strong>✨ Create reliable planning tools</strong>, systematically organize baking tasks, handle dietary requirements, and coordinate schedules!</p>',
    ),
    createdBy: 'user_4',
  ),
  TextModel(
    id: 'text-content-19',
    sheetId: 'sheet-16',
    parentId: 'sheet-16',
    title: 'From Halloween Planning Chaos to Spectacular Success',
    orderIndex: 6,
    description: (
      plainText:
          '🎃\n\nHalloween Planning Spectacular Hub - Your organized command center for Halloween fun!\n\n'
          'Everyone\'s excited! But then the chaos begins with wrong streets, nobody on the same place, messy group chat confusion about meeting locations, timing issues, and people getting lost!\n\n'
          '🎯\n\nThis workspace transforms Halloween planning from chaos to success:\n\n'
          '• Location coordination and clear directions (no more confusion)\n'
          '• Clear communication and organized group chat (no more chaos)\n'
          '• Scheduling conflicts and late arrivals (handle scheduling situations)\n'
          '• House locations and meeting points (clear organization)\n\n'
          '✨\n\nCreate reliable planning tools, systematically organize meeting locations, handle scheduling conflicts, and coordinate communication!',
      htmlText:
          '<p><strong>🎃</strong></p>\n'
          '<p>Your organized command center for Halloween fun!</p>\n'
          '<p>Everyone\'s excited! But then the chaos begins with wrong streets, nobody on the same place, messy group chat confusion about meeting locations, timing issues, and people getting lost!</p><br><br>\n'
          '<p><strong>🎯</strong></p>\n'
          '<p>This workspace transforms Halloween planning from chaos to success:</p><br>\n'
          '<p>• Location coordination and clear directions (no more confusion)<br>\n'
          '• Clear communication and organized group chat (no more chaos)<br>\n'
          '• Scheduling conflicts and late arrivals (handle scheduling situations)<br>\n'
          '• House locations and meeting points (clear organization)</p><br><br>\n'
          '<p><strong>✨</strong></p>\n'
          '<p>Create reliable planning tools, systematically organize meeting locations, handle scheduling conflicts, and coordinate communication!</p>',
    ),
    createdBy: 'user_5',
  ),
  TextModel(
    id: 'text-content-20',
    sheetId: 'sheet-17',
    parentId: 'sheet-17',
    title: 'From Summer Camp Sign-ups Chaos to Spectacular Success',
    orderIndex: 6,
    description: (
      plainText:
          '🏕️\n\nSummer Camp Sign-ups Success Hub - Your organized command center for summer camp fun!\n\n'
          'Parents are excited, kids wait for camp to start, but then chaos begins with form confusion, date conflicts, payment issues, equipment questions, and stress overload!\n\n'
          '🎯\n\nThis workspace transforms summer camp sign-ups from chaos to success:\n\n'
          '• Form submissions and sign-up process (no more confusion)\n'
          '• Date conflicts and scheduling coordination (handle scheduling chaos)\n'
          '• Payment handling and financial coordination (clear organization)\n'
          '• Equipment and supplies organization (no more confusion)\n\n'
          '✨\n\nCreate reliable planning tools, systematically organize sign-ups, handle date conflicts, manage payments, and coordinate equipment!',
      htmlText:
          '<p><strong>🏕️</strong></p>\n'
          '<p>Summer Camp Sign-ups Success Hub - Your organized command center for summer camp fun!</p>\n'
          '<p>Parents are excited, kids wait for camp to start, but then chaos begins with form confusion, date conflicts, payment issues, equipment questions, and stress overload!</p><br><br>\n'
          '<p><strong>🎯</strong></p>\n'
          '<p>This workspace transforms summer camp sign-ups from chaos to success:</p><br>\n'
          '<p>• Form submissions and sign-up process (no more confusion)<br>\n'
          '• Date conflicts and scheduling coordination (handle scheduling chaos)<br>\n'
          '• Payment handling and financial coordination (clear organization)<br>\n'
          '• Equipment and supplies organization (no more confusion)</p><br><br>\n'
          '<p><strong>✨</strong></p>\n'
          '<p>Create reliable planning tools, systematically organize sign-ups, handle date conflicts, manage payments, and coordinate equipment!</p>',
    ),
    createdBy: 'user_6',
  ),
  TextModel(
    id: 'text-content-21',
    sheetId: 'sheet-18',
    parentId: 'sheet-18',
    title: 'From Thanksgiving Planning Chaos to Spectacular Success',
    orderIndex: 6,
    description: (
      plainText:
          '🦃\n\nThanksgiving Will Not Be Terrible This Year Hub - Your organized command center for Thanksgiving success!\n\n'
          'Weeks of cooking endless stress, they all promised they will help but will they really help? I will handle the turkey in family group chats with confusion about who\'s bringing what, random memes, and timing confusion. At the end everything falls on mom!\n\n'
          '🎯\n\nThis workspace transforms Thanksgiving planning from chaos to success:\n\n'
          '• Cooking assignments and stress reduction (no more endless stress)\n'
          '• Reliable help and promise follow-through (handle promise situations)\n'
          '• Family group chat organization (no more chaos)\n'
          '• Balanced workload distribution (prevent overload situations)\n\n'
          '✨\n\nCreate reliable planning tools, systematically organize cooking tasks, coordinate reliable help, and manage family communication!',
      htmlText:
          '<p><strong>🦃</strong></p>\n'
          '<p>Thanksgiving Will Not Be Terrible This Year Hub - Your organized command center for Thanksgiving success!</p>\n'
          '<p>Weeks of cooking endless stress, they all promised they will help but will they really help? I will handle the turkey in family group chats with confusion about who\'s bringing what, random memes, and timing confusion. At the end everything falls on mom!</p><br><br>\n'
          '<p><strong>🎯</strong></p>\n'
          '<p>This workspace transforms Thanksgiving planning from chaos to success:</p><br>\n'
          '<p>• Cooking assignments and stress reduction (no more endless stress)<br>\n'
          '• Reliable help and promise follow-through (handle promise situations)<br>\n'
          '• Family group chat organization (no more chaos)<br>\n'
          '• Balanced workload distribution (prevent overload situations)</p><br><br>\n'
          '<p><strong>✨</strong></p>\n'
          '<p>Create reliable planning tools, systematically organize cooking tasks, coordinate reliable help, and manage family communication!</p>',
    ),
    createdBy: 'user_7',
  ),
];
