import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/events/models/events_content_model.dart';
import 'package:zoey/features/contents/events/providers/events_content_list_provider.dart';
import 'package:zoey/features/contents/events/data/events_content_list.dart';

final eventsContentItemProvider = Provider.family<EventsContentModel, String>((
  ref,
  String id,
) {
  try {
    return ref
        .watch(eventsContentListProvider)
        .firstWhere((element) => element.id == id);
  } catch (e) {
    // Return a default events content if ID not found
    return EventsContentModel(
      parentId: 'default',
      id: id,
      title: 'Content not found',
      events: [
        EventItem(
          title: 'Content not found',
          description: 'The content with ID "$id" could not be found.',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(hours: 1)),
        ),
      ],
    );
  }
});

// Provider to update events content
final eventsContentUpdateProvider =
    Provider<void Function(String, {String? title, List<EventItem>? events})>((
      ref,
    ) {
      return (String id, {String? title, List<EventItem>? events}) {
        final index = eventsContentList.indexWhere(
          (element) => element.id == id,
        );
        if (index != -1) {
          final currentContent = eventsContentList[index];
          final updatedContent = currentContent.copyWith(
            title: title,
            events: events,
          );
          eventsContentList[index] = updatedContent;

          // Refresh the list provider to notify listeners
          ref.invalidate(eventsContentListProvider);
          // Also invalidate the specific item provider to ensure UI updates
          ref.invalidate(eventsContentItemProvider(id));
        }
      };
    });
