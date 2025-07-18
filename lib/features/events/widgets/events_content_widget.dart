import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            Icon(Icons.calendar_month, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: ZoeInlineTextEditWidget(
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
            ),
            if (isEditing) ...[
              const SizedBox(width: 6),
              GestureDetector(
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
                child: const Icon(Icons.delete_outlined, size: 16),
              ),
            ],
          ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(Icons.event, size: 12),
        ),
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
                    ...eventsContent.events.asMap().entries.map(
                      (entry) => entry.key == index
                          ? entry.value.copyWith(title: value)
                          : entry.value,
                    ),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}
