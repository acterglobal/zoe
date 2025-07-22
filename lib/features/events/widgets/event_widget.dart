import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/common/widgets/emoji_widget.dart';
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
    final isEditing = ref.watch(isEditValueProvider);

    final event = ref.watch(eventProvider(eventsId));
    if (event == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _buildEventContent(context, ref, event, isEditing),
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
        _buildEventDateWidget(context, ref, event),
        _buildEventIcon(context, ref, event.id, event.emoji),
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
              _buildEventDescription(context, ref, event),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventDateWidget(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
  ) {
    final now = DateTime.now();
    final startDate = event.startDate;
    final endDate = event.endDate;

    // Format dates and times
    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('h:mm a');
    final yearFormat = DateFormat('MMM d, y');

    // Determine if it's today, tomorrow, or another day
    final isToday =
        startDate.year == now.year &&
        startDate.month == now.month &&
        startDate.day == now.day;
    final isTomorrow =
        startDate.year == now.year &&
        startDate.month == now.month &&
        startDate.day == now.day + 1;
    final isThisYear = startDate.year == now.year;

    // Format the date part
    String dateText;
    if (isToday) {
      dateText = 'Today';
    } else if (isTomorrow) {
      dateText = 'Tomorrow';
    } else if (isThisYear) {
      dateText = dateFormat.format(startDate);
    } else {
      dateText = yearFormat.format(startDate);
    }

    // Format the time part
    final startTime = timeFormat.format(startDate);
    final endTime = timeFormat.format(endDate);

    // Check if it's the same day
    final isSameDay =
        startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day;

    String timeText;
    if (isSameDay) {
      timeText = '$startTime - $endTime';
    } else {
      // Multi-day event
      final endDateText = isThisYear
          ? dateFormat.format(endDate)
          : yearFormat.format(endDate);
      timeText = '$startTime - $endDateText $endTime';
    }

    return Container(
      margin: const EdgeInsets.only(right: 8, top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dateText,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            timeText,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventIcon(
    BuildContext context,
    WidgetRef ref,
    String eventId,
    String? emoji,
  ) {
    if (emoji != null) {
      return EmojiWidget(
        emoji: emoji,
        onTap: (currentEmoji) => ref
            .read(eventListProvider.notifier)
            .updateEventEmoji(eventId, CommonUtils.getNextEmoji(currentEmoji)),
      );
    }
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
    );
  }

  Widget _buildEventDescription(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
  ) {
    return Text(
      event.description?.plainText ?? '',
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
          onTap: () =>
              ref.read(eventListProvider.notifier).deleteEvent(event.id),
        ),
      ],
    );
  }
}
