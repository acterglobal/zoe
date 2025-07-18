import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/data/events_content_list.dart';
import 'package:zoey/features/events/models/events_content_model.dart';

// StateNotifier for managing the events content list
class EventsContentListNotifier
    extends StateNotifier<List<EventsContentModel>> {
  EventsContentListNotifier() : super(eventsContentList);

  // Update a specific content item
  void updateContent(String id, {String? title, List<EventItem>? events}) {
    state = state.map((content) {
      if (content.id == id) {
        return content.copyWith(
          title: title ?? content.title,
          events: events ?? content.events,
        );
      }
      return content;
    }).toList();

    // Also update the original list to keep it in sync
    final index = eventsContentList.indexWhere((element) => element.id == id);
    if (index != -1) {
      eventsContentList[index] = state.firstWhere(
        (element) => element.id == id,
      );
    }
  }

  // Add new content
  void addContent(EventsContentModel content) {
    state = [...state, content];
    eventsContentList.add(content);
  }

  // Remove content
  void removeContent(String id) {
    state = state.where((content) => content.id != id).toList();
    eventsContentList.removeWhere((element) => element.id == id);
  }
}

// StateNotifier provider for the events content list
final eventsContentListProvider =
    StateNotifierProvider<EventsContentListNotifier, List<EventsContentModel>>((
      ref,
    ) {
      return EventsContentListNotifier();
    });
