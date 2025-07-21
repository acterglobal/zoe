import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/events/models/events_content_model.dart';
import 'package:zoey/features/events/providers/events_block_proivder.dart';

class EventsBlockWidget extends ConsumerWidget {
  final String eventsBlockId;
  final bool isEditing;
  const EventsBlockWidget({
    super.key,
    required this.eventsBlockId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsBlock = ref.watch(eventsBlockItemProvider(eventsBlockId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (context, index) =>
              _buildEventItem(context, ref, eventsBlock, index),
        ),
        if (isEditing) _buildAddEventButton(context, ref),
      ],
    );
  }

  Widget _buildEventItem(
    BuildContext context,
    WidgetRef ref,
    EventBlockModel eventsBlock,
    int index,
  ) {
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
                        text: eventsBlock.title,
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        onTextChanged: (value) => ref
                            .read(eventsBlockUpdateProvider)
                            .call(eventsBlockId, title: value),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (isEditing) ...[
                      GestureDetector(
                        onTap: () => context.push(
                          AppRoutes.eventDetail.route.replaceAll(
                            ':eventId',
                            eventsBlock.id,
                          ),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ZoeCloseButtonWidget(
                        onTap: () {
                          ref
                              .read(eventsBlockUpdateProvider)
                              .call(
                                eventsBlockId,
                                startDate: null,
                                endDate: null,
                              );
                        },
                      ),
                    ],
                  ],
                ),
                Text(
                  eventsBlock.plainTextDescription ?? '',
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

  Widget _buildAddEventButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: () {},
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
    );
  }
}
