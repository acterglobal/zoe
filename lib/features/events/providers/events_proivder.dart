import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/providers/common_providers.dart';
import 'package:zoey/common/utils/date_time_utils.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/event_notifiers.dart';

final eventListProvider =
    StateNotifierProvider<EventNotifier, List<EventModel>>(
      (ref) => EventNotifier(),
    );

final eventListSearchProvider = Provider<List<EventModel>>((ref) {
  final eventList = ref.watch(eventListProvider);
  final searchValue = ref.watch(searchValueProvider);
  if (searchValue.isEmpty) return eventList;
  return eventList
      .where((e) => e.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
});

final eventProvider = Provider.family<EventModel?, String>((ref, eventId) {
  final eventList = ref.watch(eventListProvider);
  return eventList.where((e) => e.id == eventId).firstOrNull;
});

final eventByParentProvider = Provider.family<List<EventModel>, String>((
  ref,
  parentId,
) {
  final eventList = ref.watch(eventListProvider);
  return eventList.where((e) => e.parentId == parentId).toList();
});

final todaysEventsProvider = Provider<List<EventModel>>((ref) {
  final allEvents = ref.watch(eventListProvider);
  final todayEvents = allEvents
      .where((event) => event.startDate.isToday)
      .toList();
  todayEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
  return todayEvents;
});
