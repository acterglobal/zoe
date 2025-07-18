import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/events/models/events_content_model.dart';
import 'package:zoey/features/contents/events/providers/events_content_item_proivder.dart';

class EventsContentWidget extends ConsumerWidget {
  final String eventsContentId;
  final bool isEditing;
  const EventsContentWidget({
    super.key,
    required this.eventsContentId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsContent = ref.watch(eventsContentItemProvider(eventsContentId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        isEditing
            ? _buildTitleTextField(context, ref, eventsContent.title)
            : _buildTitleText(context, ref, eventsContent.title),
        const SizedBox(height: 6),
        isEditing
            ? _buildDataTextField(context, ref, eventsContent.events)
            : _buildDataText(context, ref, eventsContent.events),
      ],
    );
  }

  Widget _buildTitleTextField(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) {
    final controller = ref.watch(
      eventsContentTitleControllerProvider(eventsContentId),
    );
    final updateContent = ref.read(eventsContentUpdateProvider);

    return TextField(
      controller: controller,
      maxLines: null,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: const InputDecoration(
        hintText: 'Title',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      onChanged: (value) {
        updateContent(eventsContentId, title: value);
      },
    );
  }

  Widget _buildDataTextField(
    BuildContext context,
    WidgetRef ref,
    List<EventItem> events,
  ) {
    return ListView.builder(
      itemCount: events.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final titleControllerKey = '$eventsContentId-$index';
        final titleController = ref.watch(
          eventsContentItemTitleControllerProvider(titleControllerKey),
        );
        final descriptionController = ref.watch(
          eventsContentItemDescriptionControllerProvider(titleControllerKey),
        );
        final updateContent = ref.read(eventsContentUpdateProvider);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.event, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Event title...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      final updatedEvents = List<EventItem>.from(events);
                      updatedEvents[index] = events[index].copyWith(
                        title: value,
                      );
                      updateContent(eventsContentId, events: updatedEvents);
                    },
                  ),
                  TextField(
                    controller: descriptionController,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Description...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      final updatedEvents = List<EventItem>.from(events);
                      updatedEvents[index] = events[index].copyWith(
                        description: value,
                      );
                      updateContent(eventsContentId, events: updatedEvents);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleText(BuildContext context, WidgetRef ref, String title) {
    return Text(
      title.isEmpty ? 'Untitled' : title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildDataText(
    BuildContext context,
    WidgetRef ref,
    List<EventItem> events,
  ) {
    return ListView.builder(
      itemCount: events.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Row(
        children: [
          const Icon(Icons.event, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  events[index].title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (events[index].description?.isNotEmpty == true)
                  Text(
                    events[index].description!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
