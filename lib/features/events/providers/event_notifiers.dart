import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/data/event_list.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/models/rsvp_event_response_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class EventNotifier extends StateNotifier<List<EventModel>> {
  EventNotifier() : super(eventList);

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
            rsvpResponses: {
              ...event.rsvpResponses,
              userId: RsvpResponse(id: userId, name: userId, status: status),
            },
          )
        else
          event,
    ];
  }

  void removeRsvpResponse(String eventId, String userId) {
    state = [
      for (final event in state)
        if (event.id == eventId)
          event.copyWith(
            rsvpResponses: Map.from(event.rsvpResponses)..remove(userId),
          )
        else
          event,
    ];
  }

  /// Get RSVP statistics for a specific event
  Map<RsvpStatus, int> getRsvpStatistics(String eventId) {
    final event = state.where((e) => e.id == eventId).firstOrNull;
    if (event == null) return {};

    final stats = <RsvpStatus, int>{};
    for (final status in RsvpStatus.values) {
      stats[status] = 0;
    }

    for (final response in event.rsvpResponses.values) {
      stats[response.status] = (stats[response.status] ?? 0) + 1;
    }

    return stats;
  }

  /// Get total RSVP responses for a specific event
  int getTotalRsvpResponses(String eventId) {
    final event = state.where((e) => e.id == eventId).firstOrNull;
    return event?.rsvpResponses.length ?? 0;
  }
}
