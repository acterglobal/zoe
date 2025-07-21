import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/events_list_provider.dart';

final eventsProvider = Provider.family<EventModel, String>((ref, String id) {
  try {
    return ref
        .watch(eventsListProvider)
        .firstWhere((element) => element.id == id);
  } catch (e) {
    // Return a default event if ID not found
    return EventModel(
      sheetId: 'default',
      parentId: 'default',
      id: id,
      title: 'Event not found',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(hours: 1)),
    );
  }
});

// Direct update provider - saves immediately using StateNotifier
final eventsUpdateProvider =
    Provider<
      void Function(
        String, {
        String? title,
        DateTime? startDate,
        DateTime? endDate,
      })
    >((ref) {
      return (
        String eventId, {
        String? title,
        DateTime? startDate,
        DateTime? endDate,
      }) {
        // Update using the StateNotifier for immediate reactivity
        ref
            .read(eventsListProvider.notifier)
            .updateEvent(
              eventId,
              title: title,
              startDate: startDate,
              endDate: endDate,
            );
      };
    });

final deleteEventProvider = Provider<void Function(String)>((ref) {
  return (String eventId) {
    ref.read(eventsListProvider.notifier).deleteEvent(eventId);
  };
});
