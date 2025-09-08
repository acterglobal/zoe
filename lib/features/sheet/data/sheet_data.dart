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
    title: 'Mobile App Development',
    emoji: '📱',
    color: const Color(0xFF10B981), // Emerald
    description: (
      plainText:
          'Central hub for our app development project. Track feature progress, share design assets, coordinate sprints, and manage development tasks. Perfect for keeping the team aligned on goals, deadlines, and technical decisions.',
      htmlText:
          '<p>Central hub for our app development project. Track feature progress, share design assets, coordinate sprints, and manage development tasks. Perfect for keeping the team aligned on goals, deadlines, and technical decisions.</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5', 'user_6', 'user_7', 'user_8', 'user_9', 'user_10'],
  ),
  SheetModel(
    id: 'sheet-3',
    title: 'Community Garden Project',
    emoji: '🌱',
    color: const Color(0xFFF59E0B), // Amber
    description: (
      plainText:
          'Organize our neighborhood garden initiative! Coordinate planting schedules, track maintenance tasks, share gardening tips, and plan community events. Keep everyone informed about volunteer opportunities and garden progress.',
      htmlText:
          '<p>Organize our neighborhood garden initiative! Coordinate planting schedules, track maintenance tasks, share gardening tips, and plan community events. Keep everyone informed about volunteer opportunities and garden progress.</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_2', 'user_3', 'user_4', 'user_5'],
  ),
  SheetModel(
    id: 'sheet-4',
    title: 'Wedding Planning',
    emoji: '💍',
    color: const Color(0xFFE879F9), // Fuchsia
    description: (
      plainText:
          'Your complete wedding organizer! Track vendors, manage guest lists, plan timelines, and coordinate with the wedding party. Perfect for keeping all wedding details organized and ensuring nothing is forgotten on your special day.',
      htmlText:
          '<p>Your complete wedding organizer! Track vendors, manage guest lists, plan timelines, and coordinate with the wedding party. Perfect for keeping all wedding details organized and ensuring nothing is forgotten on your special day.</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_2', 'user_3'],
  ),
  SheetModel(
    id: 'sheet-5',
    title: 'Fitness Journey',
    emoji: '💪',
    color: const Color(0xFF14B8A6), // Teal
    description: (
      plainText:
          'Track your fitness progress! Log workouts, plan meal prep, set goals, and monitor achievements. Perfect for maintaining a healthy lifestyle, following workout routines, and staying motivated with progress tracking.',
      htmlText:
          '<p>Track your fitness progress! Log workouts, plan meal prep, set goals, and monitor achievements. Perfect for maintaining a healthy lifestyle, following workout routines, and staying motivated with progress tracking.</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_2', 'user_3'],
  ),
];
