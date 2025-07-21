import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/models/events_content_model.dart';
import 'package:zoey/features/events/providers/events_block_list_provider.dart';

final eventsBlockItemProvider = Provider.family<EventBlockModel, String>((
  ref,
  String id,
) {
  try {
    return ref
        .watch(eventsBlockListProvider)
        .firstWhere((element) => element.id == id);
  } catch (e) {
    // Return a default events content if ID not found
    return EventBlockModel(
      parentId: 'default',
      id: id,
      title: 'Content not found',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(hours: 1)),
    );
  }
});

// Direct update provider - saves immediately using StateNotifier
final eventsBlockUpdateProvider =
    Provider<
      void Function(
        String, {
        String? title,
        DateTime? startDate,
        DateTime? endDate,
      })
    >((ref) {
      return (
        String contentId, {
        String? title,
        DateTime? startDate,
        DateTime? endDate,
      }) {
        // Update using the StateNotifier for immediate reactivity
        ref
            .read(eventsBlockListProvider.notifier)
            .updateContent(
              contentId,
              title: title,
              startDate: startDate,
              endDate: endDate,
            );
      };
    });
