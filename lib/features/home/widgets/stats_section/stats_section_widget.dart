import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/documents/providers/document_providers.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/home/widgets/stats_section/stats_widget.dart';
import 'package:zoey/features/link/providers/link_providers.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';
import 'package:zoey/common/widgets/coming_soon_badge_widget.dart';


class StatsSectionWidget extends ConsumerWidget {
  const StatsSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetList = ref.watch(sheetListProvider);
    final eventList = ref.watch(eventListProvider);
    final taskList = ref.watch(taskListProvider);
    final linkList = ref.watch(linkListProvider);
    final documentList = ref.watch(documentListProvider);

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
                color: AppColors.warningColor,
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
              child: Stack(
                children: [
                  StatsWidget(
                    icon: Icons.poll_sharp,
                    count: '0',
                    title: L10n.of(context).polls,
                    color: AppColors.brightMagentaColor,
                    onTap: () => {},
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: ComingSoonBadge(
                      text: L10n.of(context).comingSoon,
                      borderColor: AppColors.brightMagentaColor.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
