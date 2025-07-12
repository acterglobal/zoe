import 'package:flutter/foundation.dart';
import '../models/page.dart';
import '../models/content_block.dart';

// Wrapper classes to include page information
class TodoWithPage {
  final TodoItem todo;
  final ZoePage page;

  TodoWithPage({required this.todo, required this.page});
}

class EventWithPage {
  final EventItem event;
  final ZoePage page;

  EventWithPage({required this.event, required this.page});
}

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
        title: 'Getting Started Guide',
        description: 'Learn how to use Zoey effectively',
        emoji: '🚀',
        contentBlocks: [
          TextBlock(
            title: 'Welcome to Zoey!',
            content:
                'Zoey is your personal workspace for organizing thoughts, tasks, and ideas. This guide will help you understand all the features and get the most out of your experience.',
          ),
          ListBlock(
            title: 'Key Features Overview',
            items: [
              '📄 Create unlimited pages with custom titles and emojis',
              '📝 Add different content blocks: text, tasks, events, and lists',
              '✏️ Edit content inline by tapping on any text',
              '🎨 Customize pages with emojis and descriptions',
              '📱 Access everything from the home dashboard',
              '🔍 Quick actions for common tasks',
            ],
          ),
          TodoBlock(
            title: 'Quick Start Checklist',
            items: [
              TodoItem(
                text: 'Explore this Getting Started page',
                isCompleted: true,
                priority: TodoPriority.high,
                description:
                    'Read through this guide to understand Zoey\'s features',
                tags: ['tutorial', 'getting-started'],
              ),
              TodoItem(
                text: 'Check out the Productivity Workspace example',
                isCompleted: false,
                priority: TodoPriority.high,
                description:
                    'See how to organize a real project with tasks and events',
                tags: ['tutorial', 'example'],
              ),
              TodoItem(
                text: 'Create your first custom page',
                isCompleted: false,
                priority: TodoPriority.medium,
                dueDate: DateTime.now().add(const Duration(hours: 2)),
                description:
                    'Try creating a page for a personal project or goal',
                tags: ['hands-on', 'practice'],
              ),
              TodoItem(
                text: 'Add different content blocks',
                isCompleted: false,
                priority: TodoPriority.medium,
                description: 'Experiment with text, tasks, events, and lists',
                tags: ['practice', 'content-blocks'],
              ),
              TodoItem(
                text: 'Customize your workspace',
                isCompleted: false,
                priority: TodoPriority.low,
                dueDate: DateTime.now().add(const Duration(days: 1)),
                description: 'Add emojis, organize pages, and make it your own',
                tags: ['customization', 'personal'],
              ),
            ],
          ),
          TextBlock(
            title: 'How to Use Content Blocks',
            content:
                'Content blocks are the building blocks of your pages. Tap the + button to add new blocks:\n\n• Text Blocks: For notes, ideas, and documentation\n• Task Lists: For to-dos with priorities and due dates\n• Event Blocks: For scheduling and calendar items\n• List Blocks: For simple bullet points and collections\n\nYou can drag and drop blocks to reorder them, and edit any text by tapping on it.',
          ),
          EventBlock(
            title: 'Learning Schedule',
            events: [
              EventItem(
                title: 'Explore Getting Started Guide',
                description: 'Read through this guide and try the features',
                startTime: DateTime.now(),
                endTime: DateTime.now().add(const Duration(minutes: 30)),
                location: EventLocation(physical: 'Your current location'),
                requiresRSVP: false,
              ),
              EventItem(
                title: 'Practice Session',
                description: 'Create your first custom page and add content',
                startTime: DateTime.now().add(const Duration(hours: 1)),
                endTime: DateTime.now().add(const Duration(hours: 2)),
                location: EventLocation(
                  physical: 'Anywhere you\'re comfortable',
                ),
                requiresRSVP: false,
              ),
            ],
          ),
          ListBlock(
            title: 'Pro Tips',
            items: [
              'Use emojis to quickly identify different types of pages',
              'Set due dates on tasks to stay organized',
              'Add descriptions to tasks for more context',
              'Use tags to categorize and find content later',
              'Check the home dashboard for today\'s priorities',
              'The drawer menu shows all your pages for quick access',
            ],
          ),
        ],
      ),
      ZoePage(
        title: 'Productivity Workspace',
        description: 'A real-world example of project management',
        emoji: '💼',
        contentBlocks: [
          TextBlock(
            title: 'Project Overview',
            content:
                'This is an example of how you might organize a work project using Zoey. Notice how different content blocks work together to create a comprehensive workspace.',
          ),
          TodoBlock(
            title: 'Sprint Tasks',
            items: [
              TodoItem(
                text: 'Design user interface mockups',
                isCompleted: true,
                priority: TodoPriority.high,
                assignees: ['Design Team'],
                description:
                    'Create wireframes and high-fidelity mockups for the new feature',
                tags: ['design', 'ui-ux', 'sprint-1'],
              ),
              TodoItem(
                text: 'Implement authentication system',
                isCompleted: true,
                priority: TodoPriority.urgent,
                assignees: ['Backend Team'],
                description: 'Set up secure login and user management',
                tags: ['backend', 'security', 'sprint-1'],
              ),
              TodoItem(
                text: 'Write API documentation',
                isCompleted: false,
                priority: TodoPriority.high,
                assignees: ['Backend Team', 'Tech Writer'],
                dueDate: DateTime.now().add(const Duration(days: 2)),
                description: 'Document all API endpoints with examples',
                tags: ['documentation', 'api', 'sprint-2'],
              ),
              TodoItem(
                text: 'Conduct user testing',
                isCompleted: false,
                priority: TodoPriority.medium,
                assignees: ['UX Research Team'],
                dueDate: DateTime.now().add(const Duration(days: 5)),
                description: 'Test the new feature with 10 target users',
                tags: ['testing', 'user-research', 'sprint-2'],
              ),
              TodoItem(
                text: 'Optimize database queries',
                isCompleted: false,
                priority: TodoPriority.low,
                assignees: ['Backend Team'],
                dueDate: DateTime.now().add(const Duration(days: 7)),
                description: 'Improve performance for large datasets',
                tags: ['optimization', 'database', 'sprint-3'],
              ),
            ],
          ),
          EventBlock(
            title: 'Team Schedule',
            events: [
              EventItem(
                title: 'Daily Standup',
                description: 'Quick sync on progress and blockers',
                startTime: DateTime.now().add(const Duration(hours: 16)),
                endTime: DateTime.now().add(
                  const Duration(hours: 16, minutes: 15),
                ),
                location: EventLocation(
                  physical: 'Conference Room B',
                  virtual: 'https://meet.google.com/daily-standup',
                ),
                requiresRSVP: true,
                rsvpResponses: [
                  RSVPResponse(
                    userId: '1',
                    userName: 'Project Manager',
                    status: RSVPStatus.yes,
                  ),
                  RSVPResponse(
                    userId: '2',
                    userName: 'Lead Developer',
                    status: RSVPStatus.yes,
                  ),
                  RSVPResponse(
                    userId: '3',
                    userName: 'Designer',
                    status: RSVPStatus.maybe,
                  ),
                ],
              ),
              EventItem(
                title: 'Sprint Review',
                description: 'Demo completed features and gather feedback',
                startTime: DateTime.now().add(
                  const Duration(days: 2, hours: 14),
                ),
                endTime: DateTime.now().add(const Duration(days: 2, hours: 15)),
                location: EventLocation(
                  physical: 'Main Conference Room',
                  virtual: 'https://zoom.us/j/sprint-review',
                ),
                requiresRSVP: true,
                rsvpResponses: [
                  RSVPResponse(
                    userId: '1',
                    userName: 'Stakeholder',
                    status: RSVPStatus.yes,
                  ),
                  RSVPResponse(
                    userId: '2',
                    userName: 'Product Owner',
                    status: RSVPStatus.yes,
                  ),
                ],
              ),
              EventItem(
                title: 'Team Lunch',
                description: 'Casual team bonding over lunch',
                startTime: DateTime.now().add(
                  const Duration(days: 4, hours: 12),
                ),
                endTime: DateTime.now().add(const Duration(days: 4, hours: 13)),
                location: EventLocation(
                  physical: 'The Garden Café, 456 Office Plaza',
                ),
                requiresRSVP: true,
                rsvpResponses: [
                  RSVPResponse(
                    userId: '1',
                    userName: 'Team Member 1',
                    status: RSVPStatus.yes,
                  ),
                  RSVPResponse(
                    userId: '2',
                    userName: 'Team Member 2',
                    status: RSVPStatus.yes,
                  ),
                  RSVPResponse(
                    userId: '3',
                    userName: 'Team Member 3',
                    status: RSVPStatus.no,
                  ),
                ],
              ),
            ],
          ),
          ListBlock(
            title: 'Resources & Links',
            items: [
              'Project Repository: github.com/company/project',
              'Design System: figma.com/design-system',
              'API Documentation: docs.company.com/api',
              'Testing Environment: staging.company.com',
              'Project Slack: #project-alpha',
              'Bug Tracker: jira.company.com/project-alpha',
            ],
          ),
          TextBlock(
            title: 'Meeting Notes - Sprint Planning',
            content:
                'Key decisions from today\'s sprint planning:\n\n• Prioritizing user authentication as highest priority\n• Design team will deliver mockups by end of week\n• Backend team to focus on API stability\n• User testing scheduled for next sprint\n• Database optimization moved to sprint 3\n\nAction items:\n- Update project timeline\n- Schedule additional design review\n- Prepare demo environment',
          ),
          ListBlock(
            title: 'Success Metrics',
            items: [
              'User registration completion rate > 85%',
              'API response time < 200ms',
              'User satisfaction score > 4.5/5',
              'Zero critical security vulnerabilities',
              'Test coverage > 90%',
              'Feature adoption rate > 60%',
            ],
          ),
        ],
      ),
      ZoePage(
        title: 'Personal Life Planner',
        description: 'Organize your personal goals and activities',
        emoji: '🌟',
        contentBlocks: [
          TextBlock(
            title: 'Life Goals & Vision',
            content:
                'This page demonstrates how to use Zoey for personal planning. You can track goals, plan activities, and organize your personal life just like you would for work projects.',
          ),
          TodoBlock(
            title: 'Health & Fitness Goals',
            items: [
              TodoItem(
                text: 'Morning workout routine',
                isCompleted: true,
                priority: TodoPriority.high,
                description: '30 minutes of cardio and strength training',
                tags: ['health', 'fitness', 'daily'],
              ),
              TodoItem(
                text: 'Drink 8 glasses of water',
                isCompleted: false,
                priority: TodoPriority.medium,
                dueDate: DateTime.now().add(const Duration(hours: 8)),
                description: 'Stay hydrated throughout the day',
                tags: ['health', 'hydration', 'daily'],
              ),
              TodoItem(
                text: 'Meal prep for the week',
                isCompleted: false,
                priority: TodoPriority.medium,
                dueDate: DateTime.now().add(const Duration(days: 1)),
                description: 'Prepare healthy meals for Monday-Friday',
                tags: ['nutrition', 'meal-prep', 'weekly'],
              ),
              TodoItem(
                text: 'Schedule annual health checkup',
                isCompleted: false,
                priority: TodoPriority.low,
                dueDate: DateTime.now().add(const Duration(days: 14)),
                description: 'Book appointment with primary care doctor',
                tags: ['health', 'medical', 'annual'],
              ),
            ],
          ),
          EventBlock(
            title: 'Personal Schedule',
            events: [
              EventItem(
                title: 'Yoga Class',
                description:
                    'Weekly yoga session for flexibility and mindfulness',
                startTime: DateTime.now().add(
                  const Duration(days: 1, hours: 18),
                ),
                endTime: DateTime.now().add(const Duration(days: 1, hours: 19)),
                location: EventLocation(
                  physical: 'Zen Yoga Studio, 789 Wellness Ave',
                ),
                requiresRSVP: false,
              ),
              EventItem(
                title: 'Coffee with Mom',
                description: 'Weekly catch-up over coffee',
                startTime: DateTime.now().add(
                  const Duration(days: 3, hours: 10),
                ),
                endTime: DateTime.now().add(const Duration(days: 3, hours: 11)),
                location: EventLocation(physical: 'Corner Café, Downtown'),
                requiresRSVP: false,
              ),
              EventItem(
                title: 'Book Club Meeting',
                description: 'Monthly discussion of "The Power of Now"',
                startTime: DateTime.now().add(
                  const Duration(days: 7, hours: 19),
                ),
                endTime: DateTime.now().add(const Duration(days: 7, hours: 21)),
                location: EventLocation(
                  physical: 'Sarah\'s House',
                  virtual: 'Backup: Zoom link in email',
                ),
                requiresRSVP: true,
                rsvpResponses: [
                  RSVPResponse(
                    userId: '1',
                    userName: 'Sarah',
                    status: RSVPStatus.yes,
                  ),
                  RSVPResponse(
                    userId: '2',
                    userName: 'Mike',
                    status: RSVPStatus.maybe,
                  ),
                ],
              ),
            ],
          ),
          ListBlock(
            title: 'Learning & Development',
            items: [
              'Complete online photography course',
              'Read 2 books per month',
              'Practice Spanish for 15 minutes daily',
              'Learn basic guitar chords',
              'Take a cooking class',
              'Attend local networking events',
            ],
          ),
          TodoBlock(
            title: 'Home & Lifestyle',
            items: [
              TodoItem(
                text: 'Organize closet and donate clothes',
                isCompleted: false,
                priority: TodoPriority.medium,
                dueDate: DateTime.now().add(const Duration(days: 3)),
                description: 'Spring cleaning and decluttering',
                tags: ['home', 'organization', 'donation'],
              ),
              TodoItem(
                text: 'Plan weekend hiking trip',
                isCompleted: false,
                priority: TodoPriority.low,
                dueDate: DateTime.now().add(const Duration(days: 5)),
                description: 'Research trails and book accommodation',
                tags: ['outdoor', 'adventure', 'weekend'],
              ),
              TodoItem(
                text: 'Update home insurance policy',
                isCompleted: false,
                priority: TodoPriority.high,
                dueDate: DateTime.now().add(const Duration(days: 10)),
                description: 'Review coverage and renewal options',
                tags: ['insurance', 'financial', 'important'],
              ),
            ],
          ),
          TextBlock(
            title: 'Reflection & Gratitude',
            content:
                'Weekly reflection (Example):\n\nThis week I\'m grateful for:\n• Good health and energy\n• Supportive family and friends\n• Opportunities to learn and grow\n• Beautiful weather for outdoor activities\n\nAreas for improvement:\n• Better time management\n• More consistent sleep schedule\n• Increased focus on creative hobbies\n\nNext week\'s focus: Balance work and personal time better.',
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
  List<TodoWithPage> getTodaysTodos() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    List<TodoWithPage> todaysTodos = [];

    for (final page in _pages) {
      for (final todoBlock in page.todoBlocks) {
        for (final todo in todoBlock.items) {
          if (todo.dueDate != null &&
              todo.dueDate!.isAfter(todayStart) &&
              todo.dueDate!.isBefore(todayEnd)) {
            todaysTodos.add(TodoWithPage(todo: todo, page: page));
          } else if (todo.dueDate == null && !todo.isCompleted) {
            // Include todos without due dates that are not completed
            todaysTodos.add(TodoWithPage(todo: todo, page: page));
          }
        }
      }
    }

    return todaysTodos;
  }

  // Get upcoming events across all pages
  List<EventWithPage> getUpcomingEvents() {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));

    List<EventWithPage> upcomingEvents = [];

    for (final page in _pages) {
      for (final eventBlock in page.eventBlocks) {
        for (final event in eventBlock.events) {
          if (event.startTime.isAfter(now) &&
              event.startTime.isBefore(nextWeek)) {
            upcomingEvents.add(EventWithPage(event: event, page: page));
          }
        }
      }
    }

    // Sort by start time
    upcomingEvents.sort(
      (a, b) => a.event.startTime.compareTo(b.event.startTime),
    );

    return upcomingEvents;
  }

  // Get today's events
  List<EventWithPage> getTodaysEvents() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    List<EventWithPage> todaysEvents = [];

    for (final page in _pages) {
      for (final eventBlock in page.eventBlocks) {
        for (final event in eventBlock.events) {
          if (event.startTime.isAfter(todayStart) &&
              event.startTime.isBefore(todayEnd)) {
            todaysEvents.add(EventWithPage(event: event, page: page));
          }
        }
      }
    }

    // Sort by start time
    todaysEvents.sort((a, b) => a.event.startTime.compareTo(b.event.startTime));

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
