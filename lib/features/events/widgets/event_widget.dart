import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';

class EventWidget extends ConsumerWidget {
  final String eventsId;
  const EventWidget({super.key, required this.eventsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the content edit mode provider
    final isEditing = ref.watch(toogleContentEditProvider);

    final event = ref.watch(eventsProvider(eventsId));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventIcon(context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildEventTitle(context, ref, event, isEditing),
                    ),
                    const SizedBox(width: 6),
                    if (isEditing) _buildEventActions(context, ref, event),
                  ],
                ),
                _buildEventDescription(context, ref, event),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 6),
      child: Icon(
        Icons.event,
        size: 24,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildEventTitle(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'Event name',
      isEditing: isEditing,
      text: event.title,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) =>
          ref.read(eventContentTitleUpdateProvider).call(event.id, value),
    );
  }

  Widget _buildEventDescription(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
  ) {
    return Text(
      event.plainTextDescription ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _buildEventActions(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
  ) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.push(
            AppRoutes.eventDetail.route.replaceAll(':eventId', event.id),
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
          onTap: () => ref.read(deleteEventProvider).call(event.id),
        ),
      ],
    );
  }
}
