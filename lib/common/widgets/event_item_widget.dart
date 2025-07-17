import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/content_block.dart';
import '../theme/app_theme.dart';

class EventItemWidget extends StatelessWidget {
  final EventItem event;
  final VoidCallback? onTap;

  const EventItemWidget({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.getSurface(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: Theme.of(context).brightness == Brightness.dark
                    ? 0.3
                    : 0.05,
              ),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Time indicator
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: _getEventColor(),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: AppTheme.getTextSecondary(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatEventTime(),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.getTextSecondary(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (event.description != null &&
                      event.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      event.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.getTextSecondary(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getEventColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getEventStatus(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _getEventColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEventColor() {
    final now = DateTime.now();
    final eventStart = event.startTime;
    final eventEnd = event.endTime ?? eventStart.add(const Duration(hours: 1));

    if (now.isAfter(eventEnd)) {
      return const Color(0xFF6B7280); // Gray - past
    } else if (now.isAfter(eventStart) && now.isBefore(eventEnd)) {
      return const Color(0xFF22C55E); // Green - ongoing (brighter)
    } else if (eventStart.difference(now).inHours <= 1) {
      return const Color(0xFFEF4444); // Red - starting soon
    } else if (eventStart.difference(now).inHours <= 24) {
      return const Color(0xFFF59E0B); // Amber - today
    } else {
      return const Color(0xFF8B5CF6); // Purple - future
    }
  }

  String _getEventStatus() {
    final now = DateTime.now();
    final eventStart = event.startTime;
    final eventEnd = event.endTime ?? eventStart.add(const Duration(hours: 1));

    if (now.isAfter(eventEnd)) {
      return 'Past';
    } else if (now.isAfter(eventStart) && now.isBefore(eventEnd)) {
      return 'Now';
    } else if (eventStart.difference(now).inHours <= 1) {
      return 'Soon';
    } else if (eventStart.difference(now).inHours <= 24) {
      return 'Today';
    } else {
      final days = eventStart.difference(now).inDays;
      if (days == 1) {
        return 'Tomorrow';
      } else if (days <= 7) {
        return '${days}d';
      } else {
        return DateFormat('MMM d').format(eventStart);
      }
    }
  }

  String _formatEventTime() {
    if (event.isAllDay) {
      return 'All day';
    }

    final startTime = DateFormat('h:mm a').format(event.startTime);
    if (event.endTime != null) {
      final endTime = DateFormat('h:mm a').format(event.endTime!);
      return '$startTime - $endTime';
    }

    return startTime;
  }
}
