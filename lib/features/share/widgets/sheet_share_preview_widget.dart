import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class SheetSharePreviewWidget extends ConsumerWidget {
  final String parentId;
  final String contentText;

  const SheetSharePreviewWidget({
    super.key,
    required this.parentId,
    required this.contentText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sheet = ref.watch(sheetProvider(parentId));
    if (sheet == null) return const SizedBox.shrink();

    // Get all content filtered by sheetId
    final eventList = ref.watch(eventListProvider);
    final taskList = ref.watch(taskListProvider);
    final linkList = ref.watch(linkListProvider);
    final documentList = ref.watch(documentListProvider);
    final pollList = ref.watch(pollListProvider);

    // Filter by sheetId
    final sheetEvents = eventList.where((e) => e.sheetId == parentId).toList();
    final sheetTasks = taskList.where((t) => t.sheetId == parentId).toList();
    final sheetLinks = linkList.where((l) => l.sheetId == parentId).toList();
    final sheetDocuments = documentList
        .where((d) => d.sheetId == parentId)
        .toList();
    final sheetPolls = pollList.where((p) => p.sheetId == parentId).toList();

    // Filter today's events and tasks
    final todayEvents = sheetEvents.where((e) => e.startDate.isToday).toList();
    final todayTasks = sheetTasks.where((t) => t.dueDate.isToday).toList();

    return GlassyContainer(
      padding: const EdgeInsets.all(16),
      blurRadius: 0,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sheet Title and Description
          Text(contentText, style: Theme.of(context).textTheme.bodyMedium),

          // Statistics Section
          if (sheetEvents.isNotEmpty ||
              sheetTasks.isNotEmpty ||
              sheetLinks.isNotEmpty ||
              sheetDocuments.isNotEmpty ||
              sheetPolls.isNotEmpty) ...[
            const SizedBox(height: 20),
            Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),

            // Row 1: Events, Tasks, Links
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    icon: Icons.event_rounded,
                    label: L10n.of(context).events,
                    count: sheetEvents.length,
                    subtitle: todayEvents.isNotEmpty
                        ? '${todayEvents.length} ${L10n.of(context).today}'
                        : null,
                    color: AppColors.secondaryColor,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    icon: Icons.task_alt_rounded,
                    label: L10n.of(context).tasks,
                    count: sheetTasks.length,
                    subtitle: todayTasks.isNotEmpty
                        ? '${todayTasks.length} ${L10n.of(context).dueToday}'
                        : null,
                    color: AppColors.successColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Row 2: Documents and Polls
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    icon: Icons.insert_drive_file_rounded,
                    label: L10n.of(context).documents,
                    count: sheetDocuments.length,
                    color: AppColors.brightOrangeColor,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    icon: Icons.poll_rounded,
                    label: L10n.of(context).polls,
                    count: sheetPolls.length,
                    color: AppColors.brightMagentaColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int count,
    String? subtitle,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return GlassyContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      borderRadius: BorderRadius.circular(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StyledIconContainer(
            icon: icon,
            primaryColor: color,
            iconSize: 14,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 9,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
