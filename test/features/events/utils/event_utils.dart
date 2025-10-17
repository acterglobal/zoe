import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';

EventModel getEventByIndex(ProviderContainer container, {int index = 0}) {
  final eventList = container.read(eventListProvider);
  if (eventList.isEmpty) fail('Event list is empty');
  if (index < 0 || index >= eventList.length) {
    fail('Event index is out of bounds');
  }
  return eventList[index];
}

