import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/utils/date_time_utils.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/events/widgets/event_date_widget.dart';

class EventWidget extends ConsumerWidget {
  final String eventsId;
  const EventWidget({super.key, required this.eventsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the content edit mode provider
    final isEditing = ref.watch(isEditValueProvider);

    final event = ref.watch(eventProvider(eventsId));
    if (event == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: _buildEventContent(context, ref, event, isEditing),
      ),
    );
  }

  Widget _buildEventContent(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    bool isEditing,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EventDateWidget(event: event),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildEventTitle(
                      context,
                      ref,
                      event.title,
                      isEditing,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isEditing) _buildEventActions(context, ref, event),
                ],
              ),
              _buildEventDates(context, ref, event),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'Event name',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) => ref
          .read(eventListProvider.notifier)
          .updateEventTitle(eventsId, value),
      onTapText: () => context.push(
        AppRoutes.eventDetail.route.replaceAll(':eventId', eventsId),
      ),
    );
  }

  Widget _buildEventDates(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
  ) {
    final startDateText = DateTimeUtils.formatDateTime(event.startDate);
    final endDateText = DateTimeUtils.formatDateTime(event.endDate);
    return Text(
      '$startDateText - $endDateText',
      maxLines: 2,
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
          onTap: () =>
              ref.read(eventListProvider.notifier).deleteEvent(event.id),
        ),
      ],
    );
  }
}
