import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_providers.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/events_list_provider.dart';

final eventsProvider = Provider.family<EventModel?, String>((ref, String id) {
  try {
    return ref
        .watch(eventsListProvider)
        .firstWhere((element) => element.id == id);
  } catch (e) {
    return null;
  }
});

final eventContentTitleUpdateProvider = Provider<void Function(String, String)>(
  (ref) {
    return (String eventId, String title) {
      ref.read(contentListProvider.notifier).updateContentTitle(eventId, title);
    };
  },
);
final deleteEventProvider = Provider<void Function(String)>((ref) {
  return (String eventId) {
    ref.read(contentListProvider.notifier).deleteContent(eventId);
  };
});
