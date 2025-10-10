import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/features/task/actions/update_task_actions.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class TaskDetailsAdditionalFields extends ConsumerWidget {
  final TaskModel task;
  final bool isEditing;

  const TaskDetailsAdditionalFields({
    super.key,
    required this.task,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueDate = task.dueDate;
    final dueDateText = DateTimeUtils.formatDate(dueDate);

    return _buildDueDateCard(
      context: context,
      dateText: dueDateText,
      onDateTap: isEditing ? () => updateTaskDueDate(context, ref, task) : null,
    );
  }

  Widget _buildDueDateCard({
    required BuildContext context,
    required String dateText,
    VoidCallback? onDateTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flag_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                L10n.of(context).dueDate,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFieldItem(
            context: context,
            icon: Icons.calendar_today_outlined,
            label: L10n.of(context).date,
            value: dateText,
            onTap: onDateTap,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: onTap != null
              ? Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
