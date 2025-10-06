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
];
