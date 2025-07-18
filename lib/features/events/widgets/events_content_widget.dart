import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/events/models/events_content_model.dart';
import 'package:zoey/features/events/providers/events_content_item_proivder.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ZoeInlineTextEditWidget(
          hintText: 'Event list title',
          isEditing: isEditing,
          controller: ref.watch(
            eventsContentTitleControllerProvider(eventsContentId),
          ),
          textStyle: Theme.of(context).textTheme.titleMedium,
          onTextChanged: (value) => ref
              .read(eventsContentUpdateProvider)
              .call(eventsContentId, title: value),
        ),
        const SizedBox(height: 6),
        _buildEventsList(context, ref),
      ],
    );
  }

  Widget _buildEventsList(BuildContext context, WidgetRef ref) {
    final eventsContent = ref.watch(eventsContentItemProvider(eventsContentId));
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: eventsContent.events.length,
      itemBuilder: (context, index) =>
          _buildEventItem(context, ref, eventsContent, index),
    );
  }

  Widget _buildEventItem(
    BuildContext context,
    WidgetRef ref,
    EventsContentModel eventsContent,
    int index,
  ) {
    final titleControllerKey = '$eventsContentId-$index';
    final titleController = ref.watch(
      eventsContentItemTitleControllerProvider(titleControllerKey),
    );
    return Row(
      children: [
        Icon(Icons.event),
        const SizedBox(width: 6),
        Expanded(
          child: ZoeInlineTextEditWidget(
            hintText: 'Event name',
            isEditing: isEditing,
            controller: titleController,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            onTextChanged: (value) => ref
                .read(eventsContentUpdateProvider)
                .call(
                  eventsContentId,
                  events: [
                    ...eventsContent.events.map(
                      (e) => e.copyWith(title: value),
                    ),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}
