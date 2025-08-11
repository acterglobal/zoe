import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/data/event_list.dart';
import 'package:zoey/features/events/models/events_model.dart';
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
              userId: status,
            },
          )
        else
          event,
    ];
  }

  /// Get RSVP count for a specific event
  Map<RsvpStatus, int> getRsvpStatusCount(String eventId) {
    final event = state.where((e) => e.id == eventId).firstOrNull;
    if (event == null) return {};

    final rsvpCount = <RsvpStatus, int>{};

    for (final response in event.rsvpResponses.values) {
      rsvpCount[response] = (rsvpCount[response] ?? 0) + 1;
    }
    return rsvpCount;
  }

  /// Get total RSVP count for a specific event
  int getTotalRsvpCount(String eventId) {
    final event = state.where((e) => e.id == eventId).firstOrNull;
    return event?.rsvpResponses.length ?? 0;
  }
}
