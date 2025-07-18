import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/events/data/events_content_list.dart';
import 'package:zoey/features/contents/events/models/events_content_model.dart';

final eventsContentListProvider = Provider<List<EventsContentModel>>((ref) {
  return eventsContentList;
});
