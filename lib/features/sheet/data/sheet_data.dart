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
];
