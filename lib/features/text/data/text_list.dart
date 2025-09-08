import 'package:zoe/features/text/models/text_model.dart';

final textList = [
  // Getting Started Guide Texts
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
  
  // Mobile App Development Texts
  TextModel(
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    id: 'text-app-1',
    title: 'Project Overview',
    emoji: '📱',
    orderIndex: 1,
    description: (
      plainText:
          'Our mobile app aims to revolutionize personal productivity with a focus on simplicity and powerful features. The app will help users organize tasks, track goals, and maintain daily routines through an intuitive interface.\n\nKey Objectives:\n• Create a seamless cross-platform experience\n• Implement robust offline functionality\n• Ensure data security and privacy\n• Deliver a polished, professional UI',
      htmlText:
          '<p>Our mobile app aims to revolutionize personal productivity with a focus on simplicity and powerful features. The app will help users organize tasks, track goals, and maintain daily routines through an intuitive interface.</p><br><p><strong>Key Objectives:</strong></p><ul><li>Create a seamless cross-platform experience</li><li>Implement robust offline functionality</li><li>Ensure data security and privacy</li><li>Deliver a polished, professional UI</li></ul>',
    ),
    createdBy: 'user_1',
  ),
  TextModel(
    sheetId: 'sheet-2',
    parentId: 'sheet-2',
    id: 'text-app-2',
    title: 'Architecture Overview',
    emoji: '🏗️',
    orderIndex: 2,
    description: (
      plainText:
          'The app follows a clean architecture pattern with clear separation of concerns:\n\n📱 Presentation Layer:\n• Flutter UI components\n• State management with Riverpod\n• Navigation using GoRouter\n\n⚙️ Domain Layer:\n• Business logic\n• Entity models\n• Repository interfaces\n\n💾 Data Layer:\n• API integration\n• Local storage\n• Repository implementations',
      htmlText:
          '<p>The app follows a clean architecture pattern with clear separation of concerns:</p><br><p><strong>📱 Presentation Layer:</strong></p><ul><li>Flutter UI components</li><li>State management with Riverpod</li><li>Navigation using GoRouter</li></ul><br><p><strong>⚙️ Domain Layer:</strong></p><ul><li>Business logic</li><li>Entity models</li><li>Repository interfaces</li></ul><br><p><strong>💾 Data Layer:</strong></p><ul><li>API integration</li><li>Local storage</li><li>Repository implementations</li></ul>',
    ),
    createdBy: 'user_2',
  ),

  // Community Garden Texts
  TextModel(
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    id: 'text-garden-1',
    title: 'Garden Guidelines',
    emoji: '🌱',
    orderIndex: 1,
    description: (
      plainText:
          'Welcome to our community garden! This space is maintained by and for our community members. Please follow these guidelines:\n\n🌿 Sustainable Practices:\n• Use organic methods only\n• Conserve water with mulching\n• Contribute to composting\n\n👥 Community Spirit:\n• Share knowledge and resources\n• Respect others\' plots\n• Participate in group activities\n\n🔧 Maintenance:\n• Clean and return tools\n• Report issues promptly\n• Help maintain common areas',
      htmlText:
          '<p>Welcome to our community garden! This space is maintained by and for our community members. Please follow these guidelines:</p><br><p><strong>🌿 Sustainable Practices:</strong></p><ul><li>Use organic methods only</li><li>Conserve water with mulching</li><li>Contribute to composting</li></ul><br><p><strong>👥 Community Spirit:</strong></p><ul><li>Share knowledge and resources</li><li>Respect others\' plots</li><li>Participate in group activities</li></ul><br><p><strong>🔧 Maintenance:</strong></p><ul><li>Clean and return tools</li><li>Report issues promptly</li><li>Help maintain common areas</li></ul>',
    ),
    createdBy: 'user_1',
  ),
  TextModel(
    sheetId: 'sheet-3',
    parentId: 'sheet-3',
    id: 'text-garden-2',
    title: 'Seasonal Planning',
    emoji: '🌞',
    orderIndex: 2,
    description: (
      plainText:
          'Our garden follows a seasonal planting schedule to maximize harvest and maintain soil health:\n\n🌱 Spring (March-May):\n• Start seedlings indoors\n• Prepare soil and beds\n• Plant early crops\n\n☀️ Summer (June-August):\n• Main growing season\n• Regular maintenance\n• Harvest management\n\n🍂 Fall (September-November):\n• Late season crops\n• Soil preparation\n• Winter protection',
      htmlText:
          '<p>Our garden follows a seasonal planting schedule to maximize harvest and maintain soil health:</p><br><p><strong>🌱 Spring (March-May):</strong></p><ul><li>Start seedlings indoors</li><li>Prepare soil and beds</li><li>Plant early crops</li></ul><br><p><strong>☀️ Summer (June-August):</strong></p><ul><li>Main growing season</li><li>Regular maintenance</li><li>Harvest management</li></ul><br><p><strong>🍂 Fall (September-November):</strong></p><ul><li>Late season crops</li><li>Soil preparation</li><li>Winter protection</li></ul>',
    ),
    createdBy: 'user_2',
  ),

   // Wedding Planning Texts
  TextModel(
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    id: 'text-wedding-1',
    title: 'Wedding Timeline',
    emoji: '📅',
    orderIndex: 1,
    description: (
      plainText:
          '12 Months Before:\n• Set wedding date and budget\n• Book venue and caterer\n• Start guest list\n\n6-9 Months Before:\n• Book photographer and DJ\n• Order wedding dress\n• Send save-the-dates\n\n3-6 Months Before:\n• Order invitations\n• Plan honeymoon\n• Book florist\n\n1-3 Months Before:\n• Send invitations\n• Plan seating chart\n• Final dress fitting',
      htmlText:
          '<p><strong>12 Months Before:</strong></p><ul><li>Set wedding date and budget</li><li>Book venue and caterer</li><li>Start guest list</li></ul><br><p><strong>6-9 Months Before:</strong></p><ul><li>Book photographer and DJ</li><li>Order wedding dress</li><li>Send save-the-dates</li></ul><br><p><strong>3-6 Months Before:</strong></p><ul><li>Order invitations</li><li>Plan honeymoon</li><li>Book florist</li></ul><br><p><strong>1-3 Months Before:</strong></p><ul><li>Send invitations</li><li>Plan seating chart</li><li>Final dress fitting</li></ul>',
    ),
    createdBy: 'user_1',
  ),
  TextModel(
    sheetId: 'sheet-4',
    parentId: 'sheet-4',
    id: 'text-wedding-2',
    title: 'Budget Overview',
    emoji: '💰',
    orderIndex: 2,
    description: (
      plainText:
          'Total Budget Allocation:\n\n🏰 Venue & Catering: 50%\n• Venue rental\n• Food and beverages\n• Staff and service\n\n📸 Photography & Entertainment: 20%\n• Photographer/videographer\n• DJ/band\n• Photo booth\n\n💐 Decor & Attire: 20%\n• Flowers and decorations\n• Wedding dress and accessories\n• Wedding party attire\n\n📝 Miscellaneous: 10%\n• Invitations and stationery\n• Wedding rings\n• Transportation',
      htmlText:
          '<p><strong>Total Budget Allocation:</strong></p><br><p><strong>🏰 Venue & Catering: 50%</strong></p><ul><li>Venue rental</li><li>Food and beverages</li><li>Staff and service</li></ul><br><p><strong>📸 Photography & Entertainment: 20%</strong></p><ul><li>Photographer/videographer</li><li>DJ/band</li><li>Photo booth</li></ul><br><p><strong>💐 Decor & Attire: 20%</strong></p><ul><li>Flowers and decorations</li><li>Wedding dress and accessories</li><li>Wedding party attire</li></ul><br><p><strong>📝 Miscellaneous: 10%</strong></p><ul><li>Invitations and stationery</li><li>Wedding rings</li><li>Transportation</li></ul>',
    ),
    createdBy: 'user_1',
  ),

  // Fitness Journey Texts
  TextModel(
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    id: 'text-fitness-1',
    title: 'Workout Schedule',
    emoji: '🏋️‍♀️',
    orderIndex: 1,
    description: (
      plainText:
          'Weekly Training Split:\n\nMonday: Upper Body Strength\n• Chest and triceps\n• Shoulder press\n• Pull-ups/rows\n\nTuesday: Lower Body Power\n• Squats and deadlifts\n• Lunges\n• Calf raises\n\nWednesday: Cardio & Core\n• HIIT training\n• Ab circuit\n• Planks\n\nThursday: Full Body Circuit\n• Compound movements\n• Supersets\n• Endurance focus\n\nFriday: Mobility & Recovery\n• Yoga\n• Stretching\n• Foam rolling',
      htmlText:
          '<p><strong>Weekly Training Split:</strong></p><br><p><strong>Monday: Upper Body Strength</strong></p><ul><li>Chest and triceps</li><li>Shoulder press</li><li>Pull-ups/rows</li></ul><br><p><strong>Tuesday: Lower Body Power</strong></p><ul><li>Squats and deadlifts</li><li>Lunges</li><li>Calf raises</li></ul><br><p><strong>Wednesday: Cardio & Core</strong></p><ul><li>HIIT training</li><li>Ab circuit</li><li>Planks</li></ul><br><p><strong>Thursday: Full Body Circuit</strong></p><ul><li>Compound movements</li><li>Supersets</li><li>Endurance focus</li></ul><br><p><strong>Friday: Mobility & Recovery</strong></p><ul><li>Yoga</li><li>Stretching</li><li>Foam rolling</li></ul>',
    ),
    createdBy: 'user_1',
  ),
  TextModel(
    sheetId: 'sheet-5',
    parentId: 'sheet-5',
    id: 'text-fitness-2',
    title: 'Nutrition Guidelines',
    emoji: '🥗',
    orderIndex: 2,
    description: (
      plainText:
          'Daily Nutrition Goals:\n\n🍗 Protein (30%)\n• Lean meats\n• Fish\n• Eggs\n• Plant-based proteins\n\n🥑 Healthy Fats (25%)\n• Avocados\n• Nuts and seeds\n• Olive oil\n• Fatty fish\n\n🍚 Complex Carbs (45%)\n• Whole grains\n• Sweet potatoes\n• Quinoa\n• Oats\n\n💧 Hydration\n• 2-3 liters of water daily\n• Herbal teas\n• Electrolytes post-workout',
      htmlText:
          '<p><strong>Daily Nutrition Goals:</strong></p><br><p><strong>🍗 Protein (30%)</strong></p><ul><li>Lean meats</li><li>Fish</li><li>Eggs</li><li>Plant-based proteins</li></ul><br><p><strong>🥑 Healthy Fats (25%)</strong></p><ul><li>Avocados</li><li>Nuts and seeds</li><li>Olive oil</li><li>Fatty fish</li></ul><br><p><strong>🍚 Complex Carbs (45%)</strong></p><ul><li>Whole grains</li><li>Sweet potatoes</li><li>Quinoa</li><li>Oats</li></ul><br><p><strong>💧 Hydration</strong></p><ul><li>2-3 liters of water daily</li><li>Herbal teas</li><li>Electrolytes post-workout</li></ul>',
    ),
    createdBy: 'user_1',
  ),
];
