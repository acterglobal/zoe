import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/common/utils/firestore_error_handler.dart';
import 'package:zoe/constants/firestore_collection_constants.dart';
import 'package:zoe/constants/firestore_field_constants.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

part 'event_providers.g.dart';

/// Main event list provider with all event management functionality
@Riverpod(keepAlive: true)
class EventList extends _$EventList {
  CollectionReference<Map<String, dynamic>> get collection =>
      ref.read(firestoreProvider).collection(FirestoreCollections.events);

  StreamSubscription? _subscription;

  @override
  List<EventModel> build() {
    _subscription?.cancel();
    _subscription = null;

    _subscription = collection.snapshots().listen(
      (snapshot) {
        state = snapshot.docs
            .map((doc) => EventModel.fromJson(doc.data()))
            .toList();
      },
      onError: (error, stackTrace) {
        runFirestoreOperation(ref, () => throw error);
      },
    );

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return [];
  }

  Future<void> addEvent(EventModel event) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(event.id).set(event.toJson()),
    );
  }

  Future<void> deleteEvent(String eventId) async {
    await runFirestoreOperation(ref, () => collection.doc(eventId).delete());
  }

  Future<void> updateEventTitle(String eventId, String title) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(eventId).update({
        FirestoreFieldConstants.title: title,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateEventDescription(
    String eventId,
    Description description,
  ) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(eventId).update({
        FirestoreFieldConstants.description: {
          FirestoreFieldConstants.plainText: description.plainText,
          FirestoreFieldConstants.htmlText: description.htmlText,
        },
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateEventStartDate(String eventId, DateTime startDate) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(eventId).update({
        FirestoreFieldConstants.startDate: Timestamp.fromDate(startDate),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateEventEndDate(String eventId, DateTime endDate) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(eventId).update({
        FirestoreFieldConstants.endDate: Timestamp.fromDate(endDate),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateEventOrderIndex(String eventId, int orderIndex) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(eventId).update({
        FirestoreFieldConstants.orderIndex: orderIndex,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  /// Add or update RSVP response for a user
  Future<void> updateRsvpResponse(
    String eventId,
    String userId,
    RsvpStatus status,
  ) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(eventId).update({
        '${FirestoreFieldConstants.rsvpResponses}.$userId': status.name,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }
}

/// Provider for today's events (filtered by membership)
@riverpod
List<EventModel> todaysEvents(Ref ref) {
  final events = ref.watch(eventListProvider);
  final todayEvents = events.where((event) {
    return event.startDate.isToday;
  }).toList();
  todayEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
  return todayEvents;
}

/// Provider for upcoming events (filtered by membership)
@riverpod
List<EventModel> upcomingEvents(Ref ref) {
  final events = ref.watch(eventListProvider);
  final upcomingEvents = events.where((event) {
    return event.startDate.isAfter(DateTime.now()) && !event.startDate.isToday;
  }).toList();
  upcomingEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
  return upcomingEvents;
}

/// Provider for past events (filtered by membership)
@riverpod
List<EventModel> pastEvents(Ref ref) {
  final events = ref.watch(eventListProvider);
  final pastEvents = events.where((event) {
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
  final events = ref.watch(eventListProvider);

  if (searchValue.isEmpty) return events;
  return events
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
