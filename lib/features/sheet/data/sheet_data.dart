import 'dart:ui';
import 'package:zoey/features/sheet/models/sheet_model.dart';

final sheetList = [
  SheetModel(
    id: 'sheet-1',
    title: 'Getting Started Guide',
    emoji: '🚀',
    color: const Color(0xFF6366F1), // Indigo
    description: (
      plainText:
          'Your complete introduction to Zoey! This interactive guide walks you through all features, includes hands-on tasks to practice with, and provides tips for organizing your digital workspace effectively. Perfect for new users to get up and running quickly.',
      htmlText:
          '<p>Your complete introduction to <strong>Zoey</strong>! This interactive guide walks you through all features, includes hands-on tasks to practice with, and provides tips for organizing your digital workspace effectively. Perfect for new users to get up and running quickly.</p>',
    ),
    createdBy: 'user_1',
    users: ['user_1', 'user_2', 'user_3'],
  ),
  SheetModel(
    id: 'sheet-2',
    title: 'Community Organization',
    emoji: '⚽',
    color: const Color(0xFF10B981), // Emerald
    description: (
      plainText:
          'Perfect for sports teams, school parent groups, and community volunteers. Learn how to coordinate snacks, manage carpools, organize events, and keep everyone informed without the chaos of endless group chat scrolling.',
      htmlText:
          '<p>Perfect for sports teams, school parent groups, and community volunteers. Learn how to coordinate snacks, manage carpools, organize events, and keep everyone informed without the chaos of endless group chat scrolling.</p>',
    ),
    createdBy: 'user_1',
    users: [],
  ),
  SheetModel(
    id: 'sheet-3',
    title: 'Inclusive Communication',
    emoji: '🤗',
    color: const Color(0xFFF59E0B), // Amber
    description: (
      plainText:
          'Ensure everyone feels included and stays informed. Discover strategies for accommodating busy parents, new members, and people with different communication styles so nobody gets left behind.',
      htmlText:
          '<p>Ensure everyone feels included and stays informed. Discover strategies for accommodating busy parents, new members, and people with different communication styles so nobody gets left behind.</p>',
    ),
    createdBy: 'user_3',
    users: ['user_4', 'user_5', 'user_6'],
  ),
  SheetModel(
    id: 'sheet-4',
    title: 'Information Management',
    emoji: '📚',
    color: const Color(0xFF3B82F6), // Blue
    description: (
      plainText:
          'Stop losing important details in chat scroll. Learn how to create organized, searchable lists for schedules, contacts, rules, and resources that everyone can find and contribute to easily.',
      htmlText:
          '<p>Stop losing important details in chat scroll. Learn how to create organized, searchable lists for schedules, contacts, rules, and resources that everyone can find and contribute to easily.</p>',
    ),
    createdBy: 'user_4',
    users: ['user_4', 'user_5', 'user_6'],
  ),
  SheetModel(
    id: 'sheet-5',
    title: 'Group Visibility',
    emoji: '👀',
    color: const Color(0xFF8B5CF6), // Purple
    description: (
      plainText:
          'Keep everyone in the loop with real-time coordination. See who\'s doing what, track sign-ups instantly, and ensure nothing falls through the cracks with crystal clear communication.',
      htmlText:
          '<p>Keep everyone in the loop with real-time coordination. See who\'s doing what, track sign-ups instantly, and ensure nothing falls through the cracks with crystal clear communication.</p>',
    ),
    createdBy: 'user_5',
    users: ['user_4', 'user_5', 'user_6'],
  ),
  SheetModel(
    id: 'sheet-6',
    title: 'Stress-Free Organizing',
    emoji: '😌',
    color: const Color(0xFF06B6D4), // Cyan
    description: (
      plainText:
          'Reduce the mental load and sleep peacefully knowing nothing will be forgotten. Learn how to set up automatic reminders, delegate tasks effectively, and organize without carrying everything in your head.',
      htmlText:
          '<p>Reduce the mental load and sleep peacefully knowing nothing will be forgotten. Learn how to set up automatic reminders, delegate tasks effectively, and organize without carrying everything in your head.</p>',
    ),
    createdBy: 'user_6',
    users: ['user_7', 'user_8'],
  ),
  SheetModel(
    id: 'sheet-7',
    title: 'Easy Handoffs',
    emoji: '🤲',
    color: const Color(0xFFEF4444), // Red
    description: (
      plainText:
          'Life happens - emergencies, work trips, family obligations. Learn how to seamlessly pass organizing responsibilities to other parents with full context so events run smoothly even when you can\'t be there.',
      htmlText:
          '<p>Life happens - emergencies, work trips, family obligations. Learn how to seamlessly pass organizing responsibilities to other parents with full context so events run smoothly even when you can\'t be there.</p>',
    ),
    createdBy: 'user_7',
    users: ['user_9'],
  ),
  SheetModel(
    id: 'sheet-8',
    title: 'Group Trip Planning',
    emoji: '✈️',
    color: const Color(0xFF84CC16), // Lime
    description: (
      plainText:
          'Plan amazing group adventures from brainstorming destinations to tracking expenses. Learn how to coordinate with friends, family, or colleagues to create unforgettable trips without the usual planning stress.',
      htmlText:
          '<p>Plan amazing group adventures from brainstorming destinations to tracking expenses. Learn how to coordinate with friends, family, or colleagues to create unforgettable trips without the usual planning stress.</p>',
    ),
    createdBy: 'user_8',
    users: ['user_9', 'user_10'],
  ),
];
