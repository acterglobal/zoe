// StateNotifier for managing the events content list
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/data/events_content_list.dart';
import 'package:zoey/features/events/models/events_content_model.dart';

class EventsBlockListNotifier extends StateNotifier<List<EventModel>> {
  EventsBlockListNotifier() : super(eventsBlockList);

  // Update a specific content item
  void updateEventBlock(
    String id, {
    String? title,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    state = state.map((content) {
      if (content.id == id) {
        return content.copyWith(
          title: title ?? content.title,
          startDate: startDate ?? content.startDate,
          endDate: endDate ?? content.endDate,
        );
      }
      return content;
    }).toList();

    // Also update the original list to keep it in sync
    final index = eventsBlockList.indexWhere((element) => element.id == id);
    if (index != -1) {
      eventsBlockList[index] = state.firstWhere((element) => element.id == id);
    }
  }

  // Add new content
  void addEventBlock(EventModel content) {
    state = [...state, content];
    eventsBlockList.add(content);
  }

  // Remove content
  void deleteEventBlock(String id) {
    state = state.where((content) => content.id != id).toList();
    eventsBlockList.removeWhere((element) => element.id == id);
  }
}
