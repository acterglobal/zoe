import 'dart:ui';
import 'package:zoe/features/sheet/models/sheet_model.dart';

final sheetList = [
  SheetModel(
    id: 'sheet-1',
    title: 'Getting Started Guide',
    emoji: '🚀',
    color: const Color(0xFF6366F1), // Indigo
    description: (
      plainText:
          'Your complete introduction to Zoe! This interactive guide walks you through all features, includes hands-on tasks to practice with, and provides tips for organizing your digital workspace effectively. Perfect for new users to get up and running quickly.',
      htmlText:
          '<p>Your complete introduction to <strong>Zoe</strong>! This interactive guide walks you through all features, includes hands-on tasks to practice with, and provides tips for organizing your digital workspace effectively. Perfect for new users to get up and running quickly.</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_2', 'user_3'],
  ),
  SheetModel(
    id: 'sheet-2',
    title: 'Planning a Trip',
    emoji: '✈️',
    color: const Color(0xFF10B981), // Emerald
    description: (
      plainText:
          'Our epic trip planning workspace! From choosing the perfect destination to coordinating all the fun details. Use polls to decide on destinations, tasks to track preparations, events to schedule activities, and share all the important links and resources.',
      htmlText:
          '<p>Our epic <strong>trip planning workspace</strong>! From choosing the perfect destination to coordinating all the fun details. Use polls to decide on destinations, tasks to track preparations, events to schedule activities, and share all the important links and resources.</p>',
    ),
    createdBy: 'user_2',
    users: ['user_1', 'user_2', 'user_3', 'user_4'],
  ),
  SheetModel(
    id: 'sheet-3',
    title: 'Christmas Time for Joy & Celebrations',
    emoji: '🎄',
    color: const Color(0xFFDC2626), // Red
    description: (
      plainText:
          'Our festive Christmas celebration workspace! From planning the perfect party to coordinating all the holiday fun. Use polls to decide on venues, tasks to track preparations, events to schedule activities, and share all the Christmas cheer and memes.',
      htmlText:
          '<p>Our festive <strong>Christmas celebration workspace</strong>! From planning the perfect party to coordinating all the holiday fun. Use polls to decide on venues, tasks to track preparations, events to schedule activities, and share all the Christmas cheer and memes.</p>',
    ),
    createdBy: 'user_3',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5'],
  ),
  SheetModel(
    id: 'sheet-4',
    title: 'Important Details Lost in the Messages',
    emoji: '🔍',
    color: const Color(0xFF7C3AED), // Purple
    description: (
      plainText:
          'Tired of endless scrolling through chats and thousands of photos? This is your digital organization sanctuary! From managing important details to finding better ways to organize photos, chats, and documents - Zoe helps you keep what matters most accessible and organized.',
      htmlText:
          '<p>Tired of <strong>endless scrolling</strong> through chats and thousands of photos? This is your digital organization sanctuary! From managing important details to finding better ways to organize photos, chats, and documents - Zoe helps you keep what matters most accessible and organized.</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6'],
  ),
  SheetModel(
    id: 'sheet-5',
    title: 'Community Organization Hub',
    emoji: '🏘️',
    color: const Color(0xFF059669), // Emerald
    description: (
      plainText:
          'Tired of 100+ notifications, scattered tools, and missing important clients? This is your one-stop solution for community management! From organizing chat groups to tracking important clients, event planning, and task management - Zoe brings everything together so you never miss what matters.',
      htmlText:
          '<p>Tired of <strong>100+ notifications</strong>, scattered tools, and missing important clients? This is your one-stop solution for community management! From organizing chat groups to tracking important clients, event planning, and task management - Zoe brings everything together so you never miss what matters.</p>',
    ),
    createdBy: 'user_2',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7'],
  ),
  SheetModel(
    id: 'sheet-6',
    title: 'Group Chat Chaos Management',
    emoji: '💬',
    color: const Color(0xFF7C2D12), // Brown
    description: (
      plainText:
          'Tired of endless "Friday or Sunday?" debates in group chat? We feel you! This is your solution for managing group chat chaos. From creating polls for quick decisions to organizing who\'s coming, tracking meeting preferences, and putting an end to endless back-and-forth discussions - Zoe helps you stay organized and make decisions fast.',
      htmlText:
          '<p>Tired of endless <strong>"Friday or Sunday?" debates</strong> in group chat? We feel you! This is your solution for managing group chat chaos. From creating polls for quick decisions to organizing who\'s coming, tracking meeting preferences, and putting an end to endless back-and-forth discussions - Zoe helps you stay organized and make decisions fast.</p>',
    ),
    createdBy: 'user_3',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8'],
  ),
  SheetModel(
    id: 'sheet-7',
    title: 'Exhibition Planning Hub',
    emoji: '🎨',
    color: const Color(0xFF1E40AF), // Blue
    description: (
      plainText:
          'Planning an exhibition feels overwhelming? We get it! Papers, notes, too many tools, but nothing is organized. Note apps, chat groups, calendars, paper flyers - so much stress and confusion! From food stalls to guest lists, stage management to vendor coordination - Zoe brings everything together in one organized place.',
      htmlText:
          '<p>Planning an exhibition feels <strong>overwhelming</strong>? We get it! Papers, notes, too many tools, but nothing is organized. Note apps, chat groups, calendars, paper flyers - so much stress and confusion! From food stalls to guest lists, stage management to vendor coordination - Zoe brings everything together in one organized place.</p>',
    ),
    createdBy: 'user_4',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9'],
  ),
  SheetModel(
    id: 'sheet-8',
    title: 'School Fundraiser Success Hub',
    emoji: '🎓',
    color: const Color(0xFFDC2626), // Red
    description: (
      plainText:
          'It starts with one parent saying "Let\'s do a school fundraiser!" Then suddenly: cupcakes everywhere, ticket lists flying, volunteer signups no one tracks, calendar overflowing. What should be fun turns into mayhem! Too many chats and questions like "Who\'s bringing cookies?" "When\'s the meeting?" "We need more flyers!" There\'s a better way - Zoe!',
      htmlText:
          '<p>It starts with one parent saying <strong>"Let\'s do a school fundraiser!"</strong> Then suddenly: cupcakes everywhere, ticket lists flying, volunteer signups no one tracks, calendar overflowing. What should be fun turns into mayhem! Too many chats and questions like "Who\'s bringing cookies?" "When\'s the meeting?" "We need more flyers!" There\'s a better way - Zoe!</p>',
    ),
    createdBy: 'user_5',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  SheetModel(
    id: 'sheet-9',
    title: 'BBQ Planning Paradise',
    emoji: '🔥',
    color: const Color(0xFFEA580C), // Orange
    description: (
      plainText:
          'Planning a BBQ always starts with fun ideas, but then the group chat messages never stop! "I will bring chips, wait who\'s bringing the grill? We need veggie options, I can\'t eat pork, do not forget the drinks, I already bought plates! Guys, where is the BBQ planning? What time we are meeting?" Total confusion! There\'s a better way - Zoe!',
      htmlText:
          '<p>Planning a BBQ always starts with <strong>fun ideas</strong>, but then the group chat messages never stop! "I will bring chips, wait who\'s bringing the grill? We need veggie options, I can\'t eat pork, do not forget the drinks, I already bought plates! Guys, where is the BBQ planning? What time we are meeting?" Total confusion! There\'s a better way - Zoe!</p>',
    ),
    createdBy: 'user_6',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  SheetModel(
    id: 'sheet-10',
    title: 'University Hangout Hub',
    emoji: '🎓',
    color: const Color(0xFF7C3AED), // Purple
    description: (
      plainText:
          'New at university? Making friends is exciting! New group made, making friends is exciting, but organizing hangouts? Total chaos! When we meet? Which place? Not free Tuesday, change the time, different timetables, nobody replies, who\'s even coming? And nobody knows who\'s actually coming! Now imagine one place for all - calendar, checklist, poll, attendance!',
      htmlText:
          '<p>New at university? <strong>Making friends is exciting</strong>! New group made, making friends is exciting, but organizing hangouts? Total chaos! When we meet? Which place? Not free Tuesday, change the time, different timetables, nobody replies, who\'s even coming? And nobody knows who\'s actually coming! Now imagine one place for all - calendar, checklist, poll, attendance!</p>',
    ),
    createdBy: 'user_7',
    users: ['user_1', 'user_5', 'user_6', 'user_7', 'user_8'],
  ),
  SheetModel(
    id: 'sheet-11',
    title: 'Book Club Paradise',
    emoji: '📚',
    color: const Color(0xFF059669), // Green
    description: (
      plainText:
          'Book club - the perfect way to meet friends monthly! But when it\'s time to plan, messy chat: "I\'m busy Friday, can we do next week? Who\'s hosting? Which book this time?" Juggling dates, hosting, deciding the book - sometimes it feels more stress than stories! Now imagine one place for book, task, calendar with Zoe!',
      htmlText:
          '<p>Book club - <strong>the perfect way to meet friends monthly</strong>! But when it\'s time to plan, messy chat: "I\'m busy Friday, can we do next week? Who\'s hosting? Which book this time?" Juggling dates, hosting, deciding the book - sometimes it feels more stress than stories! Now imagine one place for book, task, calendar with Zoe!</p>',
    ),
    createdBy: 'user_8',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8'],
  ),
  SheetModel(
    id: 'sheet-12',
    title: 'Softball Club BBQ Party Hub',
    emoji: '⚾',
    color: const Color(0xFFDC2626), // Red
    description: (
      plainText:
          'Softball club BBQ party planning: Great idea before it gets cold! BBQ? Softball? Drinks? This weekend? Finding date is tough, someone is busy, everyone talking, nobody decide, endless planning, no clarity, everyone\'s missing, plan gone wrong! There\'s a better way - Zoe!',
      htmlText:
          '<p>Softball club BBQ party planning: <strong>Great idea before it gets cold</strong>! BBQ? Softball? Drinks? This weekend? Finding date is tough, someone is busy, everyone talking, nobody decide, endless planning, no clarity, everyone\'s missing, plan gone wrong! There\'s a better way - Zoe!</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  SheetModel(
    id: 'sheet-13',
    title: 'Bachelorette Party Paradise',
    emoji: '💃',
    color: const Color(0xFFEC4899), // Pink
    description: (
      plainText:
          'Organizing a bachelorette party: Let\'s plan her bachelorette! The group chat is non-stop buzzing like "When we are doing it? Vegas or local? Too expensive, who\'s booking the Airbnb? I can\'t that weekend, what\'s the theme? Should we rent a limo? I vote for wine tasting." Juggling dates, no fix budget, no fix date, empty checklist - stress steals the fun!',
      htmlText:
          '<p>Organizing a bachelorette party: <strong>Let\'s plan her bachelorette</strong>! The group chat is non-stop buzzing like "When we are doing it? Vegas or local? Too expensive, who\'s booking the Airbnb? I can\'t that weekend, what\'s the theme? Should we rent a limo? I vote for wine tasting." Juggling dates, no fix budget, no fix date, empty checklist - stress steals the fun!</p>',
    ),
    createdBy: 'user_2',
    users: ['user_1', 'user_2', 'user_3', 'user_4'],
  ),
  SheetModel(
    id: 'sheet-14',
    title: 'Church Summer Fest 2026 Hub',
    emoji: '⛪',
    color: const Color(0xFF059669), // Green
    description: (
      plainText:
          'Church Summer Fest 2026: Coming together this summer! Food, music, games, charity raffle, but planning total chaos! Who\'s cooking? What\'s the budget? Which date works? Who brings chair? Busy lives, clashing schedules, no clarity! There\'s a better way - Zoe!',
      htmlText:
          '<p>Church Summer Fest 2026: <strong>Coming together this summer</strong>! Food, music, games, charity raffle, but planning total chaos! Who\'s cooking? What\'s the budget? Which date works? Who brings chair? Busy lives, clashing schedules, no clarity! There\'s a better way - Zoe!</p>',
    ),
    createdBy: 'user_3',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8'],
  ),
  SheetModel(
    id: 'sheet-15',
    title: 'PTA Bake Sale Success Hub',
    emoji: '🧁',
    color: const Color(0xFFDC2626), // Red
    description: (
      plainText:
          'Organizing PTA bake sale in school: The moms are full of energy, everyone excited to start baking together, but in group chat total chaos! Everyone nothing clear, who brings brownies? I will do cupcakes, need gluten-free too! Coffee included? Can\'t do Saturday, budget again? Decorations volunteer? Out this week, who pays? Nobody really knows, details lost!',
      htmlText:
          '<p>Organizing PTA bake sale in school: <strong>The moms are full of energy</strong>, everyone excited to start baking together, but in group chat total chaos! Everyone nothing clear, who brings brownies? I will do cupcakes, need gluten-free too! Coffee included? Can\'t do Saturday, budget again? Decorations volunteer? Out this week, who pays? Nobody really knows, details lost!</p>',
    ),
    createdBy: 'user_4',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  SheetModel(
    id: 'sheet-16',
    title: 'Halloween Planning Spectacular Hub',
    emoji: '🎃',
    color: const Color(0xFF7C2D12), // Dark orange/brown
    description: (
      plainText:
          'Halloween planning: Everyone\'s excited! Where you? We missed you! Wrong street, nobody on the same place, messy group chat like: meet at Maple St? Wait, Elm St right? I can only join later, we\'ll just go without u, wait which house again? Nobody is here!',
      htmlText:
          '<p>Halloween planning: <strong>Everyone\'s excited</strong>! Where you? We missed you! Wrong street, nobody on the same place, messy group chat like: meet at Maple St? Wait, Elm St right? I can only join later, we\'ll just go without u, wait which house again? Nobody is here!</p>',
    ),
    createdBy: 'user_5',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
];
