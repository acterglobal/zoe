import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_notifiers.dart';

class MockEventNotifier extends EventNotifier {
  MockEventNotifier();

  void setEvents(List<EventModel> events) {
    state = events;
  }
}

final mockEventListProvider = StateNotifierProvider<EventNotifier, List<EventModel>>(
  (ref) => MockEventNotifier(),
);

final mockTodaysEventsProvider = Provider<List<EventModel>>((ref) {
  final allEvents = ref.watch(mockEventListProvider);
  final now = DateTime.now();
  return allEvents.where((event) => 
    event.startDate.year == now.year &&
    event.startDate.month == now.month &&
    event.startDate.day == now.day
  ).toList();
});

final mockUpcomingEventsProvider = Provider<List<EventModel>>((ref) {
  final allEvents = ref.watch(mockEventListProvider);
  final now = DateTime.now();
  return allEvents.where((event) => 
    event.startDate.isAfter(now) &&
    event.startDate.day != now.day
  ).toList();
});

final mockPastEventsProvider = Provider<List<EventModel>>((ref) {
  final allEvents = ref.watch(mockEventListProvider);
  final now = DateTime.now();
  return allEvents.where((event) => 
    event.startDate.isBefore(now) &&
    event.startDate.day != now.day
  ).toList();
});
