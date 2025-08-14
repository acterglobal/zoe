import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_notifiers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

final eventListProvider =
    StateNotifierProvider<EventNotifier, List<EventModel>>(
      (ref) => EventNotifier(),
    );

final todaysEventsProvider = Provider<List<EventModel>>((ref) {
  final allEvents = ref.watch(eventListProvider);
  final todayEvents = allEvents.where((event) {
    return event.startDate.isToday;
  }).toList();
  todayEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
  return todayEvents;
});

final upcomingEventsProvider = Provider<List<EventModel>>((ref) {
  final eventList = ref.watch(eventListProvider);
  final upcomingEvents = eventList.where((event) {
    return event.startDate.isAfter(DateTime.now()) && !event.startDate.isToday;
  }).toList();
  upcomingEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
  return upcomingEvents;
});

final pastEventsProvider = Provider<List<EventModel>>((ref) {
  final eventList = ref.watch(eventListProvider);
  final pastEvents = eventList.where((event) {
    return event.startDate.isBefore(DateTime.now()) && !event.startDate.isToday;
  }).toList();
  pastEvents.sort((a, b) => b.startDate.compareTo(a.startDate));
  return pastEvents;
});

final allEventsProvider = Provider<List<EventModel>>((ref) {
  final todayEvents = ref.watch(todaysEventsProvider);
  final upcomingEvents = ref.watch(upcomingEventsProvider);
  final pastEvents = ref.watch(pastEventsProvider);
  return [...todayEvents, ...upcomingEvents, ...pastEvents];
});

final eventListSearchProvider = Provider<List<EventModel>>((ref) {
  final searchValue = ref.watch(searchValueProvider);
  final allEvents = ref.watch(allEventsProvider);
  if (searchValue.isEmpty) return allEvents;
  return allEvents
      .where((e) => e.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
});

final eventProvider = Provider.family<EventModel?, String>((ref, eventId) {
  final eventList = ref.watch(eventListProvider);
  return eventList.where((e) => e.id == eventId).firstOrNull;
});

final eventByParentProvider = Provider.family<List<EventModel>, String>((
  ref,
  parentId,
) {
  final eventList = ref.watch(eventListProvider);
  return eventList.where((e) => e.parentId == parentId).toList();
});

final currentUserRsvpProvider = FutureProvider.family<RsvpStatus?, String>((
  ref,
  eventId,
) async {
  final eventList = ref.watch(eventListProvider);
  final event = eventList.where((e) => e.id == eventId).firstOrNull;
  if (event == null) return null;

  // Get the current user ID from the loggedInUserProvider
  final currentUserId = await ref.read(loggedInUserProvider.future);
  if (currentUserId == null || currentUserId.isEmpty) return null;

  final rsvpResponse = event.rsvpResponses[currentUserId];
  if (rsvpResponse == null) return null;

  return rsvpResponse;
});

/// Provider for RSVP yes count of a specific event
final eventRsvpYesCountProvider = Provider.family<int, String>((ref, eventId) {
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
});

/// Provider for total RSVP count of a specific event
final eventTotalRsvpCountProvider = Provider.family<int, String>((ref, eventId) {
  final eventList = ref.watch(eventListProvider);
  final event = eventList.where((e) => e.id == eventId).firstOrNull;
  return event?.rsvpResponses.length ?? 0;
});

/// Provider for getting user whose RSVP to a specific event is "yes"
final eventRsvpYesUsersProvider = Provider.family<List<String>, String>((ref, eventId) {
  final eventList = ref.watch(eventListProvider);
  final event = eventList.where((e) => e.id == eventId).firstOrNull;
  if (event == null) return [];
  
  // Filter for only users whose RSVP is "yes"
  return event.rsvpResponses.entries
      .where((entry) => entry.value == RsvpStatus.yes)
      .map((entry) => entry.key)
      .toList();
});
