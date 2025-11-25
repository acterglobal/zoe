import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class SheetSharePreviewWidget extends ConsumerStatefulWidget {
  final String parentId;
  final String contentText;
  final ValueChanged<String>? onMessageChanged;

  const SheetSharePreviewWidget({
    super.key,
    required this.parentId,
    required this.contentText,
    this.onMessageChanged,
  });

  @override
  ConsumerState<SheetSharePreviewWidget> createState() =>
      _SheetSharePreviewWidgetState();
}

class _SheetSharePreviewWidgetState
    extends ConsumerState<SheetSharePreviewWidget> {
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageController.addListener(() {
      widget.onMessageChanged?.call(_messageController.text);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sheet = ref.watch(sheetProvider(widget.parentId));
    if (sheet == null) return const SizedBox.shrink();

    final eventList = ref.watch(eventsListProvider);
    final taskList = ref.watch(tasksListProvider);

    final documentList = ref.watch(documentListProvider);
    final pollList = ref.watch(pollsListProvider);

    // Filter by sheetId
    final sheetEvents = eventList
        .where((e) => e.sheetId == widget.parentId)
        .toList();
    final sheetTasks = taskList
        .where((t) => t.sheetId == widget.parentId)
        .toList();
    final sheetDocuments = documentList
        .where((d) => d.sheetId == widget.parentId)
        .toList();
    final sheetPolls = pollList
        .where((p) => p.sheetId == widget.parentId)
        .toList();

    // Filter today's events and tasks
    final todayEvents = sheetEvents.where((e) => e.startDate.isToday).toList();
    final todayTasks = sheetTasks.where((t) => t.dueDate.isToday).toList();

    final l10n = L10n.of(context);

    return GlassyContainer(
      padding: const EdgeInsets.all(16),
      blurRadius: 0,
      borderRadius: BorderRadius.circular(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message Text Field
            AnimatedTextField(
              controller: _messageController,
              hintText: l10n.addAMessage,
              onErrorChanged: (error) {},
              onSubmitted: () {
                final callback = widget.onMessageChanged;
                if (callback != null) {
                  callback(_messageController.text);
                }
              },
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              autofocus: false,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context: context,
              icon: Icons.event_rounded,
              label: l10n.events,
              count: sheetEvents.length,
              subtitle: todayEvents.isNotEmpty
                  ? '${todayEvents.length} ${l10n.today}'
                  : null,
              color: AppColors.secondaryColor,
            ),
            _buildStatCard(
              context: context,
              icon: Icons.task_alt_rounded,
              label: l10n.tasks,
              count: sheetTasks.length,
              subtitle: todayTasks.isNotEmpty
                  ? '${todayTasks.length} ${l10n.dueToday}'
                  : null,
              color: AppColors.successColor,
            ),
            _buildStatCard(
              context: context,
              icon: Icons.insert_drive_file_rounded,
              label: l10n.documents,
              count: sheetDocuments.length,
              color: AppColors.brightOrangeColor,
            ),
            _buildStatCard(
              context: context,
              icon: Icons.poll_rounded,
              label: l10n.polls,
              count: sheetPolls.length,
              color: AppColors.brightMagentaColor,
            ),
          ],
        ),
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

    return Row(
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
          child: Row(
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 4),
              if (subtitle != null)
                Text(
                  '($subtitle)',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
            shape: BoxShape.circle,
          ),
          child: Text(count.toString(), style: theme.textTheme.labelSmall),
        ),
      ],
    );
  }
}
