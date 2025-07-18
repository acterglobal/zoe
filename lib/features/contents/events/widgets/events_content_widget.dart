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
    final controller = TextEditingController(text: title);
    return TextField(
      controller: controller,
      maxLines: null,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(hintText: 'Title'),
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
        final titleController = TextEditingController(
          text: events[index].title,
        );
        final descriptionController = TextEditingController(
          text: events[index].description,
        );
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.calendar_month, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      contentPadding: EdgeInsets.zero,
                    ),
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
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
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
          Icon(Icons.calendar_month, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  events[index].title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  events[index].description ?? '',
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
