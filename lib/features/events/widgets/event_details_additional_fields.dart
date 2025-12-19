import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/features/events/actions/update_event_time_actions.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class EventDetailsAdditionalFields extends ConsumerWidget {
  final EventModel event;
  final bool isEditing;

  const EventDetailsAdditionalFields({
    super.key,
    required this.event,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = event.startDate;
    final endDate = event.endDate;
    final startDateText = DateTimeUtils.formatDate(startDate);
    final startTimeText = DateTimeUtils.formatTime(startDate);
    final endDateText = DateTimeUtils.formatDate(endDate);
    final endTimeText = DateTimeUtils.formatTime(endDate);
    final l10n = L10n.of(context);

    return Column(
      children: [
        _buildDateTimeCard(
          context: context,
          title: l10n.start,
          icon: Icons.play_circle_outline,
          dateText: startDateText,
          timeText: startTimeText,
          onDateTap: isEditing
              ? () => updateEventStartDate(context, ref, event)
              : null,
          onTimeTap: isEditing
              ? () => updateEventStartTime(context, ref, event)
              : null,
        ),
        const SizedBox(height: 12),
        _buildDateTimeCard(
          context: context,
          title: l10n.end,
          icon: Icons.stop_circle_outlined,
          dateText: endDateText,
          timeText: endTimeText,
          onDateTap: isEditing
              ? () => updateEventEndDate(context, ref, event)
              : null,
          onTimeTap: isEditing
              ? () => updateEventEndTime(context, ref, event)
              : null,
        ),
      ],
    );
  }

  Widget _buildDateTimeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String dateText,
    required String timeText,
    VoidCallback? onDateTap,
    VoidCallback? onTimeTap,
  }) {
    final l10n = L10n.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFieldItem(
                  context: context,
                  icon: Icons.calendar_today_outlined,
                  label: l10n.date,
                  value: dateText,
                  onTap: onDateTap,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFieldItem(
                  context: context,
                  icon: Icons.access_time,
                  label: l10n.time,
                  value: timeText,
                  onTap: onTimeTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: onTap != null
              ? Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
