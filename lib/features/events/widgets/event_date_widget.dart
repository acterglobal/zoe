import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoey/features/events/models/events_model.dart';

class EventDateWidget extends StatelessWidget {
  final EventModel event;
  const EventDateWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = event.startDate;

    // Determine if it's today, tomorrow, or another day
    final isToday =
        startDate.year == now.year &&
        startDate.month == now.month &&
        startDate.day == now.day;

    // Format month and day
    final monthText = DateFormat('MMM').format(startDate).toUpperCase();
    final dayText = DateFormat('d').format(startDate);

    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(right: 8, top: 2),
      decoration: BoxDecoration(
        color: isToday
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isToday
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            monthText,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isToday
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(
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
              color: isToday
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
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
