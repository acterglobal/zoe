import 'package:flutter/material.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

/// Mock data for Widgetbook testing
class MockData {
  static final List<SheetModel> sheets = [
    SheetModel(
      id: 'mock-sheet-1',
      title: 'Project Planning',
      emoji: '📋',
      color: const Color(0xFF6366F1),
      description: (
        plainText: 'A sheet for planning our next big project.',
        htmlText: '<p>A sheet for planning our next big project.</p>',
      ),
      createdBy: 'user_1',
      users: ['user_1', 'user_2', 'user_3'],
    ),
    SheetModel(
      id: 'mock-sheet-2',
      title: 'Meeting Notes',
      emoji: '📝',
      color: const Color(0xFF10B981),
      description: (
        plainText: 'Notes from our weekly team meetings.',
        htmlText: '<p>Notes from our weekly team meetings.</p>',
      ),
      createdBy: 'user_1',
      users: ['user_1', 'user_2'],
    ),
    SheetModel(
      id: 'mock-sheet-3',
      title: 'Ideas & Brainstorming',
      emoji: '💡',
      color: const Color(0xFFF59E0B),
      description: (
        plainText: 'Collection of ideas and brainstorming sessions.',
        htmlText: '<p>Collection of ideas and brainstorming sessions.</p>',
      ),
      createdBy: 'user_2',
      users: ['user_1', 'user_2', 'user_3', 'user_4'],
    ),
  ];

  static final List<Map<String, dynamic>> tasks = [
    {
      'id': 'task-1',
      'title': 'Design Review',
      'isCompleted': false,
      'dueDate': DateTime.now().add(const Duration(days: 2)),
    },
    {
      'id': 'task-2',
      'title': 'Code Refactoring',
      'isCompleted': true,
      'dueDate': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 'task-3',
      'title': 'Team Meeting',
      'isCompleted': false,
      'dueDate': DateTime.now(),
    },
  ];

  static final List<Map<String, dynamic>> events = [
    {
      'id': 'event-1',
      'title': 'Sprint Planning',
      'startDate': DateTime.now(),
      'endDate': DateTime.now().add(const Duration(hours: 2)),
    },
    {
      'id': 'event-2',
      'title': 'Design Workshop',
      'startDate': DateTime.now().add(const Duration(days: 1)),
      'endDate': DateTime.now().add(const Duration(days: 1, hours: 4)),
    },
  ];

  static final List<Map<String, dynamic>> users = [
    {
      'id': 'user_1',
      'name': 'Alice Johnson',
      'avatar': '👩‍💻',
      'role': 'Project Manager',
    },
    {
      'id': 'user_2',
      'name': 'Bob Smith',
      'avatar': '👨‍💻',
      'role': 'Developer',
    },
    {
      'id': 'user_3',
      'name': 'Carol White',
      'avatar': '👩‍🎨',
      'role': 'Designer',
    },
    {
      'id': 'user_4',
      'name': 'David Brown',
      'avatar': '👨‍🔧',
      'role': 'QA Engineer',
    },
  ];
}
