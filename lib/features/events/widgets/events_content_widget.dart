import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/events/models/events_content_model.dart';
import 'package:zoey/features/events/providers/events_content_item_proivder.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

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
        Row(
          children: [
            Icon(
              Icons.calendar_month,
              size: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'Event list title',
                isEditing: isEditing,
                controller: ref.watch(
                  eventsContentTitleControllerProvider(eventsContentId),
                ),
                textStyle: Theme.of(context).textTheme.bodyLarge,
                onTextChanged: (value) => ref
                    .read(eventsContentUpdateProvider)
                    .call(eventsContentId, title: value),
              ),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () {
                  final eventsContent = ref.read(
                    eventsContentItemProvider(eventsContentId),
                  );
                  ref
                      .read(
                        sheetDetailProvider(eventsContent.parentId).notifier,
                      )
                      .deleteContent(eventsContentId);
                },
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildEventsList(context, ref),
        if (isEditing)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () {
                final currentEventsContent = ref.read(
                  eventsContentItemProvider(eventsContentId),
                );
                final updatedEvents = [
                  ...currentEventsContent.events,
                  EventItem(title: ''),
                ];
                ref
                    .read(eventsContentUpdateProvider)
                    .call(eventsContentId, events: updatedEvents);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Add event',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.event,
              size: 24,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
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
                                ...eventsContent.events.asMap().entries.map(
                                  (entry) => entry.key == index
                                      ? entry.value.copyWith(title: value)
                                      : entry.value,
                                ),
                              ],
                            ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (isEditing)
                      ZoeCloseButtonWidget(
                        onTap: () {
                          final currentEventsContent = ref.read(
                            eventsContentItemProvider(eventsContentId),
                          );
                          final updatedItems = [...currentEventsContent.events];
                          updatedItems.removeAt(index);
                          ref
                              .read(eventsContentUpdateProvider)
                              .call(eventsContentId, events: updatedItems);
                        },
                      ),
                  ],
                ),
                Text(
                  eventsContent.events[index].description ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
