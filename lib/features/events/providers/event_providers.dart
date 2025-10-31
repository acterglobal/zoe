import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

part 'event_providers.g.dart';

/// Main event list provider with all event management functionality
@Riverpod(keepAlive: true)
class EventList extends _$EventList {
  @override
  List<EventModel> build() => eventList;

  void addEvent(EventModel event) {
    state = [...state, event];
  }

  void deleteEvent(String eventId) {
    state = state.where((e) => e.id != eventId).toList();
  }

  void updateEventTitle(String eventId, String title) {
    state = [
      for (final event in state)
        if (event.id == eventId) event.copyWith(title: title) else event,
    ];
  }

  void updateEventDescription(String eventId, Description description) {
    state = [
      for (final event in state)
        if (event.id == eventId)
          event.copyWith(description: description)
        else
          event,
    ];
  }

  void updateEventStartDate(String eventId, DateTime startDate) {
    state = [
      for (final event in state)
        if (event.id == eventId)
          event.copyWith(startDate: startDate)
        else
          event,
    ];
  }

  void updateEventEndDate(String eventId, DateTime endDate) {
    state = [
      for (final event in state)
        if (event.id == eventId) event.copyWith(endDate: endDate) else event,
    ];
  }

  void updateEventDateRange(
    String eventId,
    DateTime startDate,
    DateTime endDate,
  ) {
    state = [
      for (final event in state)
        if (event.id == eventId)
          event.copyWith(startDate: startDate, endDate: endDate)
        else
          event,
    ];
  }

  void updateEventOrderIndex(String eventId, int orderIndex) {
    state = [
      for (final event in state)
        if (event.id == eventId)
          event.copyWith(orderIndex: orderIndex)
        else
          event,
    ];
  }

  /// Add or update RSVP response for a user
  void updateRsvpResponse(String eventId, String userId, RsvpStatus status) {
    state = [
      for (final event in state)
        if (event.id == eventId)
          event.copyWith(
            rsvpResponses: {...event.rsvpResponses, userId: status},
          )
        else
          event,
    ];
  }
}

/// Provider for events filtered by membership (current user must be a member of the sheet)
@riverpod
List<EventModel> memberEvents(Ref ref) {
  final allEvents = ref.watch(eventListProvider);
  final currentUserId = ref.watch(loggedInUserProvider).value;

  // If no user, show nothing
  if (currentUserId == null || currentUserId.isEmpty) return [];

  // Filter events by membership of current user in the event's sheet
  return allEvents.where((e) {
    final sheet = ref.watch(sheetProvider(e.sheetId));
    return sheet?.users.contains(currentUserId) == true;
  }).toList();
}

/// Provider for today's events (filtered by membership)
@riverpod
List<EventModel> todaysEvents(Ref ref) {
  final memberEvents = ref.watch(memberEventsProvider);
  final todayEvents = memberEvents.where((event) {
    return event.startDate.isToday;
  }).toList();
  todayEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
  return todayEvents;
}

/// Provider for upcoming events (filtered by membership)
@riverpod
List<EventModel> upcomingEvents(Ref ref) {
  final memberEvents = ref.watch(memberEventsProvider);
  final upcomingEvents = memberEvents.where((event) {
    return event.startDate.isAfter(DateTime.now()) && !event.startDate.isToday;
  }).toList();
  upcomingEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
  return upcomingEvents;
}

/// Provider for past events (filtered by membership)
@riverpod 
List<EventModel> pastEvents(Ref ref) {
  final memberEvents = ref.watch(memberEventsProvider);
  final pastEvents = memberEvents.where((event) {
    return event.startDate.isBefore(DateTime.now()) && !event.startDate.isToday;
  }).toList();
  pastEvents.sort((a, b) => b.startDate.compareTo(a.startDate));
  return pastEvents;
}

/// Provider for all events combined
@riverpod
List<EventModel> allEvents(Ref ref) {
  final todayEvents = ref.watch(todaysEventsProvider);
  final upcomingEvents = ref.watch(upcomingEventsProvider);
  final pastEvents = ref.watch(pastEventsProvider);
  return [...todayEvents, ...upcomingEvents, ...pastEvents];
}

/// Provider for searching events
@riverpod
List<EventModel> eventListSearch(Ref ref) {
  final searchValue = ref.watch(searchValueProvider);
  final memberEvents = ref.watch(memberEventsProvider);

  if (searchValue.isEmpty) return memberEvents;
  return memberEvents
      .where((e) => e.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
}

/// Provider for a single event by ID
@riverpod
EventModel? event(Ref ref, String eventId) {
  final eventList = ref.watch(eventListProvider);
  return eventList.where((e) => e.id == eventId).firstOrNull;
}

/// Provider for events filtered by parent ID
@riverpod
List<EventModel> eventByParent(Ref ref, String parentId) {
  final eventList = ref.watch(eventListProvider);
  return eventList.where((e) => e.parentId == parentId).toList();
}

/// Provider for current user's RSVP status
@riverpod
Future<RsvpStatus?> currentUserRsvp(Ref ref, String eventId) async {
  final eventList = ref.watch(eventListProvider);
  final event = eventList.where((e) => e.id == eventId).firstOrNull;
  if (event == null) return null;

  // Get the current user ID from the loggedInUserProvider
  final currentUserId = await ref.read(loggedInUserProvider.future);
  if (currentUserId == null || currentUserId.isEmpty) return null;

  final rsvpResponse = event.rsvpResponses[currentUserId];
  if (rsvpResponse == null) return null;

  return rsvpResponse;
}

/// Provider for RSVP yes count of a specific event
@riverpod
int eventRsvpYesCount(Ref ref, String eventId) {
  final eventList = ref.watch(eventListProvider);
  final event = eventList.where((e) => e.id == eventId).firstOrNull;
  if (event == null) return 0;

  int eventRSVPYesCount = 0;
  for (final response in event.rsvpResponses.values) {
    if (response == RsvpStatus.yes) {
      eventRSVPYesCount++;
    }
  }
  return eventRSVPYesCount;
}

/// Provider for total RSVP count of a specific event
@riverpod
int eventTotalRsvpCount(Ref ref, String eventId) {
  final eventList = ref.watch(eventListProvider);
  final event = eventList.where((e) => e.id == eventId).firstOrNull;
  return event?.rsvpResponses.length ?? 0;
}

/// Provider for getting users whose RSVP to a specific event is "yes"
@riverpod
List<String> eventRsvpYesUsers(Ref ref, String eventId) {
  final eventList = ref.watch(eventListProvider);
  final event = eventList.where((e) => e.id == eventId).firstOrNull;
  if (event == null) return [];
  
  // Filter for only users whose RSVP is "yes"
  return event.rsvpResponses.entries
      .where((entry) => entry.value == RsvpStatus.yes)
      .map((entry) => entry.key)
      .toList();
}
