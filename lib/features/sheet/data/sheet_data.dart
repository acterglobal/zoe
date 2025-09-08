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
];
