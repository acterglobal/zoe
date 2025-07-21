import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/models/events_content_model.dart';
import 'package:zoey/features/events/providers/notifier/event_list_notifiers.dart';

// StateNotifier provider for the events content list
final eventsBlockListProvider =
    StateNotifierProvider<EventsBlockListNotifier, List<EventBlockModel>>(
      (ref) => EventsBlockListNotifier(),
    );
