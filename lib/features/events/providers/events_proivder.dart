import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/date_time_utils.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/event_notifiers.dart';
import 'package:zoey/features/users/providers/user_providers.dart';

final eventListProvider =
    StateNotifierProvider<EventNotifier, List<EventModel>>(
      (ref) => EventNotifier(),
    );

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

final todaysEventsProvider = Provider<List<EventModel>>((ref) {
  final allEvents = ref.watch(eventListProvider);
  final todayEvents = allEvents
      .where((event) => event.startDate.isToday)
      .toList();
  todayEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
  return todayEvents;
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