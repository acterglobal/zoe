import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/events/models/events_content_model.dart';
import 'package:zoey/features/contents/events/providers/events_content_list_provider.dart';

final eventsContentItemProvider = Provider.family<EventsContentModel, String>((
  ref,
  String id,
) {
  return ref
      .watch(eventsContentListProvider)
      .firstWhere((element) => element.id == id);
});
