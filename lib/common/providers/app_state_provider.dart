import 'package:flutter/foundation.dart';
import '../models/page.dart';
import '../models/content_block.dart';

class AppStateProvider extends ChangeNotifier {
  List<ZoePage> _pages = [];
  String _userName = 'Zoe';
  bool _isFirstLaunch = true;

  // Getters
  List<ZoePage> get pages => _pages;
  String get userName => _userName;
  bool get isFirstLaunch => _isFirstLaunch;

  // Initialize with sample data
  void initializeWithSampleData() {
    _pages = [
      ZoePage(
        title: 'Getting Started!',
        description: 'Welcome to your new workspace',
        emoji: '🎉',
        contentBlocks: [
          TextBlock(
            content:
                'Welcome to Zoe! This is your first page. You can add different types of content blocks to organize your thoughts and tasks.',
          ),
          TodoBlock(
            title: 'Today\'s Tasks',
            items: [
              TodoItem(text: 'Complete project setup', isCompleted: true),
              TodoItem(text: 'Review meeting notes', isCompleted: false),
              TodoItem(
                text: 'Plan vacation trip',
                isCompleted: false,
                dueDate: DateTime.now().add(const Duration(days: 2)),
              ),
            ],
          ),
          EventBlock(
            title: 'Upcoming Events',
            events: [
              EventItem(
                title: 'Team Meeting',
                description: 'Weekly sync with the team',
                startTime: DateTime.now().add(const Duration(hours: 2)),
                endTime: DateTime.now().add(const Duration(hours: 3)),
              ),
              EventItem(
                title: 'Lunch with Sarah',
                startTime: DateTime.now().add(
                  const Duration(days: 1, hours: 12),
                ),
                endTime: DateTime.now().add(const Duration(days: 1, hours: 13)),
              ),
            ],
          ),
        ],
      ),
      ZoePage(
        title: 'Vacation Trip',
        description: 'Planning my dream vacation',
        emoji: '🏖️',
        contentBlocks: [
          TextBlock(
            content:
                'Planning an amazing vacation to explore new places and create wonderful memories.',
          ),
          ListBlock(
            title: 'Destinations to Consider',
            items: [
              'Bali, Indonesia',
              'Santorini, Greece',
              'Kyoto, Japan',
              'Banff, Canada',
            ],
          ),
          TodoBlock(
            title: 'Trip Planning Checklist',
            items: [
              TodoItem(text: 'Research destinations', isCompleted: true),
              TodoItem(text: 'Book flights', isCompleted: false),
              TodoItem(text: 'Reserve accommodations', isCompleted: false),
              TodoItem(text: 'Plan activities', isCompleted: false),
            ],
          ),
        ],
      ),
    ];
    _isFirstLaunch = false;
    notifyListeners();
  }

  // Page management
  void addPage(ZoePage page) {
    _pages.add(page);
    notifyListeners();
  }

  void updatePage(ZoePage updatedPage) {
    final index = _pages.indexWhere((page) => page.id == updatedPage.id);
    if (index != -1) {
      _pages[index] = updatedPage;
      notifyListeners();
    }
  }

  void deletePage(String pageId) {
    _pages.removeWhere((page) => page.id == pageId);
    notifyListeners();
  }

  ZoePage? getPageById(String pageId) {
    try {
      return _pages.firstWhere((page) => page.id == pageId);
    } catch (e) {
      return null;
    }
  }

  // Get today's todos across all pages
  List<TodoItem> getTodaysTodos() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    List<TodoItem> todaysTodos = [];

    for (final page in _pages) {
      for (final todoBlock in page.todoBlocks) {
        for (final todo in todoBlock.items) {
          if (todo.dueDate != null &&
              todo.dueDate!.isAfter(todayStart) &&
              todo.dueDate!.isBefore(todayEnd)) {
            todaysTodos.add(todo);
          } else if (todo.dueDate == null && !todo.isCompleted) {
            // Include todos without due dates that are not completed
            todaysTodos.add(todo);
          }
        }
      }
    }

    return todaysTodos;
  }

  // Get upcoming events across all pages
  List<EventItem> getUpcomingEvents() {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));

    List<EventItem> upcomingEvents = [];

    for (final page in _pages) {
      for (final eventBlock in page.eventBlocks) {
        for (final event in eventBlock.events) {
          if (event.startTime.isAfter(now) &&
              event.startTime.isBefore(nextWeek)) {
            upcomingEvents.add(event);
          }
        }
      }
    }

    // Sort by start time
    upcomingEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

    return upcomingEvents;
  }

  // Get today's events
  List<EventItem> getTodaysEvents() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    List<EventItem> todaysEvents = [];

    for (final page in _pages) {
      for (final eventBlock in page.eventBlocks) {
        for (final event in eventBlock.events) {
          if (event.startTime.isAfter(todayStart) &&
              event.startTime.isBefore(todayEnd)) {
            todaysEvents.add(event);
          }
        }
      }
    }

    // Sort by start time
    todaysEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

    return todaysEvents;
  }

  // User settings
  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void completeFirstLaunch() {
    _isFirstLaunch = false;
    notifyListeners();
  }
}
