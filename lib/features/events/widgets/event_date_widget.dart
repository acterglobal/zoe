import 'package:flutter/material.dart';
import 'package:Zoe/common/utils/date_time_utils.dart';
import 'package:Zoe/features/events/models/events_model.dart';

class EventDateWidget extends StatelessWidget {
  final EventModel event;
  final double width;
  final double height;
  final double borderRadius;

  const EventDateWidget({
    super.key,
    required this.event,
    this.width = 40,
    this.height = 40,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final startDate = event.startDate;
    final monthText = DateTimeUtils.getMonthText(startDate);
    final dayText = DateTimeUtils.getDayText(startDate);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            monthText,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 8,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            dayText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
