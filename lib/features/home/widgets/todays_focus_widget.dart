import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/task/models/task_model.dart';

class TodaysFocusWidget extends ConsumerWidget {
  const TodaysFocusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers and handle loading states
    final allEvents = ref.watch(eventListProvider);
    final allTasks = ref.watch(taskListProvider);

    // Get filtered items with improved logic
    final relevantEvents = _getRelevantEvents(allEvents);
    final priorityTasks = _getPriorityTasks(allTasks);

    // If no items for today, don't show the widget
    if (relevantEvents.isEmpty && priorityTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context),
          _buildFocusItems(context, relevantEvents, priorityTasks),
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
    List<EventModel> relevantEvents,
    List<TaskModel> priorityTasks,
  ) {
    return Column(
      children: [
        // Events section
        if (relevantEvents.isNotEmpty) ...[
          _buildEventSection(context, relevantEvents),
          const SizedBox(height: 16),
        ],

        // Tasks section
        if (priorityTasks.isNotEmpty) ...[
          _buildTaskSection(context, priorityTasks),
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

    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.eventDetail.route.replaceAll(':eventId', event.id),
        );
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildCompactTaskItem(BuildContext context, TaskModel task) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.taskDetail.route.replaceAll(':taskId', task.id));
      },
      child: Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
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
                  if (!task.isCompleted) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatTaskDueDate(task),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getTaskDueDateColor(task),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
      ),
    );
  }

  /// Get relevant events for today's focus - improved filtering
  List<EventModel> _getRelevantEvents(List<EventModel> allEvents) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextWeek = today.add(const Duration(days: 7));

    // Filter events for the next week and sort by date
    final relevantEvents = allEvents.where((event) {
      final eventDate = DateTime(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );

      // Show events from today to next week
      return !eventDate.isBefore(today) && eventDate.isBefore(nextWeek);
    }).toList();

    // Sort by start date (earliest first)
    relevantEvents.sort((a, b) => a.startDate.compareTo(b.startDate));

    // Return up to 3 events to avoid overcrowding
    return relevantEvents.take(3).toList();
  }

  /// Get priority tasks with better filtering and sorting
  List<TaskModel> _getPriorityTasks(List<TaskModel> allTasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Separate incomplete and recently completed tasks
    final incompleteTasks = allTasks
        .where((task) => !task.isCompleted)
        .toList();
    final recentlyCompleted = allTasks
        .where((task) => task.isCompleted && _isRecentlyCompleted(task, today))
        .toList();

    // Sort incomplete tasks by priority (due date)
    incompleteTasks.sort((a, b) {
      final aDueDate = DateTime(a.dueDate.year, a.dueDate.month, a.dueDate.day);
      final bDueDate = DateTime(b.dueDate.year, b.dueDate.month, b.dueDate.day);

      // Overdue tasks first, then today's tasks, then upcoming
      final aIsOverdue = aDueDate.isBefore(today);
      final bIsOverdue = bDueDate.isBefore(today);
      final aIsToday = aDueDate.isAtSameMomentAs(today);
      final bIsToday = bDueDate.isAtSameMomentAs(today);

      if (aIsOverdue && !bIsOverdue) return -1;
      if (!aIsOverdue && bIsOverdue) return 1;
      if (aIsToday && !bIsToday) return -1;
      if (!aIsToday && bIsToday) return 1;

      return aDueDate.compareTo(bDueDate);
    });

    // Combine incomplete (prioritized) and recently completed tasks
    final combinedTasks = <TaskModel>[];
    combinedTasks.addAll(incompleteTasks.take(2)); // Max 2 incomplete tasks
    if (combinedTasks.length < 3) {
      combinedTasks.addAll(recentlyCompleted.take(3 - combinedTasks.length));
    }

    return combinedTasks.take(3).toList();
  }

  bool _isRecentlyCompleted(TaskModel task, DateTime today) {
    if (!task.isCompleted) return false;
    // Check if task was completed today (using updatedAt as completion time)
    final completionDate = DateTime(
      task.updatedAt.year,
      task.updatedAt.month,
      task.updatedAt.day,
    );
    return completionDate.isAtSameMomentAs(today);
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

  String _formatTaskDueDate(TaskModel task) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
    );
    final difference = dueDate.difference(today).inDays;

    if (difference < 0) {
      final overdueDays = -difference;
      return 'Overdue by ${overdueDays == 1 ? '1 day' : '$overdueDays days'}';
    } else if (difference == 0) {
      return 'Due today';
    } else if (difference == 1) {
      return 'Due tomorrow';
    } else if (difference <= 3) {
      return 'Due in $difference days';
    } else if (difference <= 7) {
      return 'Due in $difference days';
    } else {
      return 'Due ${task.dueDate.day}/${task.dueDate.month}';
    }
  }

  Color _getTaskDueDateColor(TaskModel task) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
    );
    final difference = dueDate.difference(today).inDays;

    if (difference < 0) {
      return AppColors.errorColor; // Overdue - bright red
    } else if (difference == 0) {
      return const Color(0xFFEA5A00); // Due today - bright orange
    } else if (difference == 1) {
      return const Color(0xFFD946EF); // Due tomorrow - bright magenta
    } else if (difference <= 3) {
      return AppColors.primaryColor; // Due soon - purple
    } else {
      return AppColors.successColor; // Future tasks - green
    }
  }
}
