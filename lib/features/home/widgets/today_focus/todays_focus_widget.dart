import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/events/providers/events_proivder.dart';
import 'package:zoe/features/events/widgets/event_widget.dart';
import 'package:zoe/features/home/widgets/section_header/section_header_widget.dart';
import 'package:zoe/features/home/widgets/today_focus/todays_item_widget.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class TodaysFocusWidget extends ConsumerWidget {
  const TodaysFocusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysEvents = ref.watch(todaysEventsProvider);
    final todaysTasks = ref.watch(todaysTasksProvider);

    if (todaysEvents.isEmpty && todaysTasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 24),
        SectionHeaderWidget(
          title: L10n.of(context).todaysFocus,
          icon: Icons.rocket_launch_rounded,
        ),
        const SizedBox(height: 16),
        if (todaysEvents.isNotEmpty) ...[
          _buildEventSection(context, todaysEvents),
          const SizedBox(height: 16),
        ],
        if (todaysTasks.isNotEmpty) ...[
          _buildTaskSection(context, todaysTasks),
        ],
      ],
    );
  }

  Widget _buildEventSection(BuildContext context, List<EventModel> events) {
    return TodaysItemWidget(
      title: L10n.of(context).upcomingEvents,
      icon: Icons.event_rounded,
      color: AppColors.secondaryColor,
      count: events.length,
      children: events.map((event) => _buildEventItem(context, event)).toList(),
    );
  }

  Widget _buildEventItem(BuildContext context, EventModel event) {
    return EventWidget(
      key: ValueKey(event.id),
      eventsId: event.id,
      isEditing: false,
      margin: const EdgeInsets.only(top: 3, bottom: 3),
    );
  }

  Widget _buildTaskSection(BuildContext context, List<TaskModel> tasks) {
    return TodaysItemWidget(
      title: L10n.of(context).activeTasks,
      icon: Icons.task_alt_rounded,
      color: AppColors.successColor,
      count: tasks.length,
      children: tasks.map((task) => _buildTaskItem(context, task)).toList(),
    );
  }

  Widget _buildTaskItem(BuildContext context, TaskModel task) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.colorScheme.surface.withValues(alpha: 0.8),
      ),
      child: TaskWidget(
        key: ValueKey(task.id),
        taskId: task.id,
        isEditing: false,
      ),
    );
  }
}
