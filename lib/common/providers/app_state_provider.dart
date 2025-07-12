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
            title: 'Welcome Note',
            content:
                'Welcome to Zoe! This is your first page. You can add different types of content blocks to organize your thoughts and tasks.',
          ),
          ListBlock(
            title: 'Getting Started Tips',
            items: [
              'Click the + button to add new content blocks',
              'Tap on any text to edit it inline',
              'Use the emoji picker to customize your pages',
              'Drag and drop to reorder content blocks',
              'Set priorities and due dates for tasks',
              'Add locations and RSVP options to events',
            ],
          ),
          TodoBlock(
            title: 'Today\'s Tasks',
            items: [
              TodoItem(
                text: 'Complete project setup',
                isCompleted: true,
                priority: TodoPriority.high,
                assignees: ['John Doe'],
                description:
                    'Set up the initial project structure and dependencies',
              ),
              TodoItem(
                text: 'Review meeting notes',
                isCompleted: false,
                priority: TodoPriority.medium,
                assignees: ['Jane Smith', 'Bob Wilson'],
                dueDate: DateTime.now().add(const Duration(hours: 6)),
                tags: ['meeting', 'review'],
              ),
              TodoItem(
                text: 'Plan vacation trip',
                isCompleted: false,
                priority: TodoPriority.low,
                assignees: ['Alice Johnson'],
                dueDate: DateTime.now().add(const Duration(days: 2)),
                description: 'Research destinations and create itinerary',
                tags: ['personal', 'travel'],
              ),
            ],
          ),
          EventBlock(
            title: 'Upcoming Events',
            events: [
              EventItem(
                title: 'Team Meeting',
                description:
                    'Weekly sync with the team to discuss project progress',
                startTime: DateTime.now().add(const Duration(hours: 2)),
                endTime: DateTime.now().add(const Duration(hours: 3)),
                location: EventLocation(
                  physical: 'Conference Room A',
                  virtual: 'https://zoom.us/j/123456789',
                ),
                requiresRSVP: true,
                rsvpResponses: [
                  RSVPResponse(
                    userId: '1',
                    userName: 'John Doe',
                    status: RSVPStatus.yes,
                  ),
                  RSVPResponse(
                    userId: '2',
                    userName: 'Jane Smith',
                    status: RSVPStatus.maybe,
                  ),
                ],
              ),
              EventItem(
                title: 'Lunch with Sarah',
                description:
                    'Catch up over lunch at the new Italian restaurant',
                startTime: DateTime.now().add(
                  const Duration(days: 1, hours: 12),
                ),
                endTime: DateTime.now().add(const Duration(days: 1, hours: 13)),
                location: EventLocation(
                  physical: 'Bella Vista Restaurant, 123 Main St',
                ),
                requiresRSVP: false,
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
            title: 'Trip Overview',
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
              TodoItem(
                text: 'Research destinations',
                isCompleted: true,
                priority: TodoPriority.high,
                assignees: ['Travel Agent'],
                description:
                    'Compare different vacation destinations and their attractions',
                tags: ['research', 'travel'],
              ),
              TodoItem(
                text: 'Book flights',
                isCompleted: false,
                priority: TodoPriority.urgent,
                assignees: ['Self'],
                dueDate: DateTime.now().add(const Duration(days: 3)),
                description: 'Find and book the best flight deals',
                tags: ['booking', 'urgent'],
              ),
              TodoItem(
                text: 'Reserve accommodations',
                isCompleted: false,
                priority: TodoPriority.high,
                assignees: ['Self'],
                dueDate: DateTime.now().add(const Duration(days: 5)),
                description: 'Book hotel or vacation rental',
                tags: ['booking', 'accommodation'],
              ),
              TodoItem(
                text: 'Plan activities',
                isCompleted: false,
                priority: TodoPriority.medium,
                assignees: ['Self', 'Travel Companion'],
                dueDate: DateTime.now().add(const Duration(days: 7)),
                description: 'Create itinerary for daily activities and tours',
                tags: ['planning', 'activities'],
              ),
            ],
          ),
          EventBlock(
            title: 'Travel Schedule',
            events: [
              EventItem(
                title: 'Flight Departure',
                description: 'Departure from home airport to destination',
                startTime: DateTime.now().add(
                  const Duration(days: 14, hours: 8),
                ),
                endTime: DateTime.now().add(
                  const Duration(days: 14, hours: 14),
                ),
                location: EventLocation(
                  physical: 'International Airport Terminal 2',
                  virtual: 'Flight Tracker: AA1234',
                ),
                requiresRSVP: false,
              ),
              EventItem(
                title: 'Welcome Dinner',
                description: 'Group dinner at the resort restaurant',
                startTime: DateTime.now().add(
                  const Duration(days: 14, hours: 19),
                ),
                endTime: DateTime.now().add(
                  const Duration(days: 14, hours: 21),
                ),
                location: EventLocation(
                  physical: 'Sunset Terrace Restaurant, Ocean View Resort',
                ),
                requiresRSVP: true,
                rsvpResponses: [
                  RSVPResponse(
                    userId: '1',
                    userName: 'Travel Companion',
                    status: RSVPStatus.yes,
                  ),
                  RSVPResponse(
                    userId: '2',
                    userName: 'Self',
                    status: RSVPStatus.yes,
                  ),
                ],
              ),
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
