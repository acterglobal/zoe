import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/content_block.dart';
import '../../core/theme/app_theme.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem todo;
  final Function(bool)? onChanged;

  const TodoItemWidget({super.key, required this.todo, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Checkbox
          GestureDetector(
            onTap: () {
              if (onChanged != null) {
                onChanged!(!todo.isCompleted);
              }
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: todo.isCompleted
                    ? AppTheme.getSuccess(context)
                    : Colors.transparent,
                border: Border.all(
                  color: todo.isCompleted
                      ? AppTheme.getSuccess(context)
                      : AppTheme.getBorder(context),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: todo.isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: todo.isCompleted
                        ? AppTheme.getTextTertiary(context)
                        : AppTheme.getTextPrimary(context),
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (todo.dueDate != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: _getDueDateColor(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDueDate(),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getDueDateColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDueDateColor(BuildContext context) {
    if (todo.dueDate == null) return AppTheme.getTextSecondary(context);

    final now = DateTime.now();
    final dueDate = todo.dueDate!;
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) {
      return AppTheme.getError(context); // Red - overdue
    } else if (difference == 0) {
      return AppTheme.getWarning(context); // Amber - due today
    } else if (difference <= 3) {
      return const Color(0xFF8B5CF6); // Purple - due soon
    } else {
      return AppTheme.getTextSecondary(context); // Gray - future
    }
  }

  String _formatDueDate() {
    if (todo.dueDate == null) return '';

    final now = DateTime.now();
    final dueDate = todo.dueDate!;
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) {
      return 'Overdue';
    } else if (difference == 0) {
      return 'Due today';
    } else if (difference == 1) {
      return 'Due tomorrow';
    } else if (difference <= 7) {
      return 'Due in $difference days';
    } else {
      return DateFormat('MMM d').format(dueDate);
    }
  }
}
