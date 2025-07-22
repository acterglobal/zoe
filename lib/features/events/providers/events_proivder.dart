import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/event_notifiers.dart';

final eventListProvider =
    StateNotifierProvider<EventNotifier, List<EventModel>>(
      (ref) => EventNotifier(),
    );

final eventProvider = Provider.family<EventModel?, String>((ref, eventId) {
  final eventList = ref.watch(eventListProvider);
  return eventList.where((e) => e.id == eventId).firstOrNull;
});
