import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/providers/content_providers.dart';
import 'package:zoey/features/events/models/events_model.dart';

// StateNotifier provider for the events list
final eventsListProvider = Provider<List<EventModel>>((ref) {
  return ref.watch(contentListProvider).whereType<EventModel>().toList();
});
