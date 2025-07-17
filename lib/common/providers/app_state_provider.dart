import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/data/zoe_page_data.dart';
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

class AppState {
  final List<ZoePage> pages;
  final String userName;
  final bool isFirstLaunch;

  const AppState({
    required this.pages,
    required this.userName,
    required this.isFirstLaunch,
  });

  AppState copyWith({
    List<ZoePage>? pages,
    String? userName,
    bool? isFirstLaunch,
  }) {
    return AppState(
      pages: pages ?? this.pages,
      userName: userName ?? this.userName,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier()
    : super(const AppState(pages: [], userName: 'Zoe', isFirstLaunch: true));

  // Initialize with sample data
  void initializeWithSampleData() {
    final samplePages = [gettingStartedPage];
    state = state.copyWith(pages: samplePages, isFirstLaunch: false);
  }

  // Page management
  void addPage(ZoePage page) {
    state = state.copyWith(pages: [...state.pages, page]);
  }

  void updatePage(ZoePage updatedPage) {
    final updatedPages = state.pages.map((page) {
      return page.id == updatedPage.id ? updatedPage : page;
    }).toList();
    state = state.copyWith(pages: updatedPages);
  }

  void deletePage(String pageId) {
    final updatedPages = state.pages
        .where((page) => page.id != pageId)
        .toList();
    state = state.copyWith(pages: updatedPages);
  }

  ZoePage? getPageById(String pageId) {
    try {
      return state.pages.firstWhere((page) => page.id == pageId);
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

    for (final page in state.pages) {
      for (final todoBlock in page.todoBlocks) {
        for (final todo in todoBlock.items) {
          // Only include tasks that are specifically due today
          if (todo.dueDate != null &&
              todo.dueDate!.isAfter(todayStart) &&
              todo.dueDate!.isBefore(todayEnd)) {
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

    for (final page in state.pages) {
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

    for (final page in state.pages) {
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
    state = state.copyWith(userName: name);
  }

  void completeFirstLaunch() {
    state = state.copyWith(isFirstLaunch: false);
  }
}

// Riverpod providers
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((
  ref,
) {
  return AppStateNotifier();
});

// Convenience providers for frequently accessed data
final pagesProvider = Provider<List<ZoePage>>((ref) {
  return ref.watch(appStateProvider).pages;
});

final userNameProvider = Provider<String>((ref) {
  return ref.watch(appStateProvider).userName;
});

final isFirstLaunchProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isFirstLaunch;
});

final todaysTodosProvider = Provider<List<TodoWithPage>>((ref) {
  return ref.watch(appStateProvider.notifier).getTodaysTodos();
});

final upcomingEventsProvider = Provider<List<EventWithPage>>((ref) {
  return ref.watch(appStateProvider.notifier).getUpcomingEvents();
});

final todaysEventsProvider = Provider<List<EventWithPage>>((ref) {
  return ref.watch(appStateProvider.notifier).getTodaysEvents();
});
