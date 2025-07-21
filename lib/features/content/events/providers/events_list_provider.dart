import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/notifier/event_list_notifiers.dart';

// StateNotifier provider for the events list
final eventsListProvider =
    StateNotifierProvider<EventsListNotifier, List<EventModel>>(
      (ref) => EventsListNotifier(),
    );
