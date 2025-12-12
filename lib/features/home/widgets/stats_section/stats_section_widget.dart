import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/home/widgets/stats_section/stats_widget.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class StatsSectionWidget extends ConsumerWidget {
  const StatsSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetList = ref.watch(sheetListProvider);
    final eventList = ref.watch(eventListProvider);
    final taskList = ref.watch(taskListProvider);
    final linkList = ref.watch(linkListProvider);
    final documentList = ref.watch(documentListProvider);
    final pollList = ref.watch(pollListProvider);

    return Column(
      children: [
        // Top row: Sheets and Events
        Row(
          children: [
            Expanded(
              child: StatsWidget(
                icon: Icons.article_rounded,
                count: sheetList.length.toString(),
                title: L10n.of(context).sheets,
                color: AppColors.primaryColor,
                onTap: () => context.push(AppRoutes.sheetsList.route),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsWidget(
                icon: Icons.event_rounded,
                count: eventList.length.toString(),
                title: L10n.of(context).events,
                color: AppColors.secondaryColor,
                onTap: () => context.push(AppRoutes.eventsList.route),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Bottom row: Tasks and Links
        Row(
          children: [
            Expanded(
              child: StatsWidget(
                icon: Icons.task_alt_rounded,
                count: taskList.length.toString(),
                title: L10n.of(context).tasks,
                color: AppColors.successColor,
                onTap: () => context.push(AppRoutes.tasksList.route),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsWidget(
                icon: Icons.link_rounded,
                count: linkList.length.toString(),
                title: L10n.of(context).links,
                color: Colors.blueAccent,
                onTap: () => context.push(AppRoutes.linksList.route),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Documents and Polls
        Row(
          children: [
            Expanded(
              child: StatsWidget(
                icon: Icons.insert_drive_file_rounded,
                count: documentList.length.toString(),
                title: L10n.of(context).documents,
                color: AppColors.brightOrangeColor,
                onTap: () => context.push(AppRoutes.documentsList.route),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsWidget(
                icon: Icons.poll_rounded,
                count: pollList.length.toString(),
                title: L10n.of(context).polls,
                color: AppColors.brightMagentaColor,
                onTap: () => context.push(AppRoutes.pollsList.route),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
