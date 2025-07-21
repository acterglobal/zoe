import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/events/data/events_list.dart';
import 'package:zoey/features/content/events/models/events_model.dart';

class EventsListNotifier extends StateNotifier<List<EventModel>> {
  EventsListNotifier() : super(eventsList);

  // Update a specific event item
  void updateEvent(
    String id, {
    String? title,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    state = state.map((event) {
      if (event.id == id) {
        return event.copyWith(
          title: title ?? event.title,
          startDate: startDate ?? event.startDate,
          endDate: endDate ?? event.endDate,
        );
      }
      return event;
    }).toList();

    // Also update the original list to keep it in sync
    final index = eventsList.indexWhere((element) => element.id == id);
    if (index != -1) {
      eventsList[index] = state.firstWhere((element) => element.id == id);
    }
  }

  // Add new event
  void addEvent(EventModel event) {
    state = [...state, event];
    eventsList.add(event);
  }

  // Remove event
  void deleteEvent(String id) {
    state = state.where((event) => event.id != id).toList();
    eventsList.removeWhere((element) => element.id == id);
  }
}
