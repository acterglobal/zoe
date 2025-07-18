import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/events/models/events_content_model.dart';
import 'package:zoey/features/contents/events/providers/events_content_list_provider.dart';

final eventsContentItemProvider = Provider.family<EventsContentModel, String>((
  ref,
  String id,
) {
  try {
    return ref
        .watch(eventsContentListProvider)
        .firstWhere((element) => element.id == id);
  } catch (e) {
    // Return a default events content if ID not found
    return EventsContentModel(
      parentId: 'default',
      id: id,
      title: 'Content not found',
      events: [
        EventItem(
          title: 'Content not found',
          description: 'The content with ID "$id" could not be found.',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(hours: 1)),
        ),
      ],
    );
  }
});

// Simple controller providers that create controllers once and keep them stable
final eventsContentTitleControllerProvider = Provider.family
    .autoDispose<TextEditingController, String>((ref, String id) {
      final content = ref.read(eventsContentItemProvider(id));
      final controller = TextEditingController(text: content.title);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

final eventsContentItemTitleControllerProvider = Provider.family
    .autoDispose<TextEditingController, String>((ref, String key) {
      // key format: "contentId-itemIndex"
      final parts = key.split('-');
      final contentId = parts.sublist(0, parts.length - 1).join('-');
      final itemIndex = int.parse(parts.last);

      final content = ref.read(eventsContentItemProvider(contentId));
      final itemTitle = itemIndex < content.events.length
          ? content.events[itemIndex].title
          : '';
      final controller = TextEditingController(text: itemTitle);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

final eventsContentItemDescriptionControllerProvider = Provider.family
    .autoDispose<TextEditingController, String>((ref, String key) {
      // key format: "contentId-itemIndex"
      final parts = key.split('-');
      final contentId = parts.sublist(0, parts.length - 1).join('-');
      final itemIndex = int.parse(parts.last);

      final content = ref.read(eventsContentItemProvider(contentId));
      final itemDescription = itemIndex < content.events.length
          ? (content.events[itemIndex].description ?? '')
          : '';
      final controller = TextEditingController(text: itemDescription);

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    });

// Direct update provider - saves immediately using StateNotifier
final eventsContentUpdateProvider =
    Provider<void Function(String, {String? title, List<EventItem>? events})>((
      ref,
    ) {
      return (String contentId, {String? title, List<EventItem>? events}) {
        // Update using the StateNotifier for immediate reactivity
        ref
            .read(eventsContentListProvider.notifier)
            .updateContent(contentId, title: title, events: events);
      };
    });
