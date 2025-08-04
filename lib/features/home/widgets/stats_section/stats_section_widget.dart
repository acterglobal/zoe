import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/home/widgets/stats_section/stats_widget.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class StatsSectionWidget extends ConsumerWidget {
  const StatsSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetList = ref.watch(sheetListProvider);
    final eventList = ref.watch(eventListProvider);
    final taskList = ref.watch(taskListProvider);

    return Row(
      children: [
        Expanded(
          child: StatsWidget(
            icon: Icons.article_rounded,
            count: sheetList.length.toString(),
            title: L10n.of(context).sheets,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsWidget(
            icon: Icons.event_rounded,
            count: eventList.length.toString(),
            title: L10n.of(context).events,
            color: AppColors.secondaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsWidget(
            icon: Icons.task_alt_rounded,
            count: taskList.length.toString(),
            title: L10n.of(context).tasks,
            color: AppColors.successColor,
          ),
        ),
      ],
    );
  }
}
