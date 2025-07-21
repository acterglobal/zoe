import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/models/events_content_model.dart';
import 'package:zoey/features/events/providers/events_content_list_provider.dart';

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

// Direct update provider - saves immediately using StateNotifier
final eventsContentUpdateProvider =
    Provider<void Function(String, {String? title, List<EventItem>? events})>((
      ref,
    ) {
      return (String contentId, {String? title, List<EventItem>? events}) {
        // Update using the StateNotifier for immediate reactivity
        ref
            .read(eventsContentListProvider.notifier)
            .updateContent(contentId, title: title, events: events);
      };
    });
