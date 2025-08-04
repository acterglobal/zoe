import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/task/models/task_model.dart';

class TodaysFocusWidget extends ConsumerWidget {
  const TodaysFocusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEvents = ref.watch(eventListProvider);
    final allTasks = ref.watch(taskListProvider);

    // Get today's items
    final todayEvents = _getTodayEvents(allEvents);
    final upcomingTasks = _getUpcomingTasks(allTasks);

    // If no items for today, don't show the widget
    if (todayEvents.isEmpty && upcomingTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context),
          _buildFocusItems(context, todayEvents, upcomingTasks),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 20),
      child: Text(
        'Today\'s Focus',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildFocusItems(
    BuildContext context,
    List<EventModel> todayEvents,
    List<TaskModel> upcomingTasks,
  ) {
    return Column(
      children: [
        // Events section
        if (todayEvents.isNotEmpty) ...[
          _buildEventSection(context, todayEvents),
          const SizedBox(height: 16),
        ],

        // Tasks section
        if (upcomingTasks.isNotEmpty) ...[
          _buildTaskSection(context, upcomingTasks),
        ],
      ],
    );
  }

  Widget _buildEventSection(BuildContext context, List<EventModel> events) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondaryColor.withValues(alpha: 0.1),
            AppColors.secondaryColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.secondaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.event_rounded,
                  color: AppColors.secondaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Upcoming Events',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.secondaryColor.withValues(alpha: 0.2),
                ),
                child: Text(
                  '${events.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Events list
          ...events
              .take(2)
              .map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildCompactEventItem(context, event),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildTaskSection(BuildContext context, List<TaskModel> tasks) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.successColor.withValues(alpha: 0.1),
            AppColors.successColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.successColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.successColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.task_alt_rounded,
                  color: AppColors.successColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Active Tasks',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.successColor.withValues(alpha: 0.2),
                ),
                child: Text(
                  '${tasks.where((t) => !t.isCompleted).length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.successColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Tasks list
          ...tasks
              .take(2)
              .map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildCompactTaskItem(context, task),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildCompactEventItem(BuildContext context, EventModel event) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.colorScheme.surface.withValues(alpha: 0.8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatEventDetails(event),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            size: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTaskItem(BuildContext context, TaskModel task) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.colorScheme.surface.withValues(alpha: 0.8),
      ),
      child: Row(
        children: [
          Icon(
            task.isCompleted
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: task.isCompleted
                ? AppColors.successColor
                : theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            size: 12,
          ),
        ],
      ),
    );
  }

  List<EventModel> _getTodayEvents(List<EventModel> allEvents) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    return allEvents.where((event) {
      final eventDate = DateTime(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );

      // Show events for today, tomorrow, and this week
      return eventDate.isAtSameMomentAs(today) ||
          eventDate.isAtSameMomentAs(tomorrow) ||
          (eventDate.isAfter(today) && eventDate.isBefore(nextWeek));
    }).toList();
  }

  List<TaskModel> _getUpcomingTasks(List<TaskModel> allTasks) {
    // Get incomplete tasks and recently completed ones
    return allTasks
        .where((task) => !task.isCompleted || _isRecentlyCompleted(task))
        .take(3)
        .toList();
  }

  bool _isRecentlyCompleted(TaskModel task) {
    // For now, we'll just check if it's completed
    // In a real app, you'd check if it was completed today
    return task.isCompleted;
  }

  String _formatEventDetails(EventModel event) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(
      event.startDate.year,
      event.startDate.month,
      event.startDate.day,
    );

    String dayText;
    if (eventDate.isAtSameMomentAs(today)) {
      dayText = 'Today';
    } else if (eventDate.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
      dayText = 'Tomorrow';
    } else {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      dayText = weekdays[eventDate.weekday - 1];
    }

    final timeText = _formatEventTime(event);
    return '$dayText at $timeText';
  }

  String _formatEventTime(EventModel event) {
    final startTime = event.startDate;
    final hour = startTime.hour;
    final minute = startTime.minute;

    String formatHour(int hour) {
      if (hour == 0) return '12';
      if (hour > 12) return (hour - 12).toString();
      return hour.toString();
    }

    String amPm = hour >= 12 ? 'PM' : 'AM';
    String minuteStr = minute.toString().padLeft(2, '0');

    return '${formatHour(hour)}:$minuteStr $amPm';
  }
}
