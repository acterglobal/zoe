import 'package:flutter/material.dart';
import 'package:zoey/core/theme/app_theme.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/sheet/models/content_block/todo_block_model.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black.withValues(
            alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: todo.isCompleted
                  ? AppColors.successColor
                  : Colors.transparent,
              border: Border.all(
                color: todo.isCompleted
                    ? AppColors.successColor
                    : Theme.of(context).colorScheme.outline,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: todo.isCompleted
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
        ),
        title: Text(
          todo.text,
          style: TextStyle(
            fontSize: 16,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted
                ? AppTheme.getTextTertiary(context)
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: todo.dueDate != null
            ? Text(
                _formatDueDate(todo.dueDate!),
                style: TextStyle(
                  fontSize: 12,
                  color: _getDueDateColor(context, todo.dueDate!),
                ),
              )
            : null,
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (dueDateOnly == today) {
      return 'Due today';
    } else if (dueDateOnly == tomorrow) {
      return 'Due tomorrow';
    } else if (dueDateOnly.isBefore(today)) {
      final difference = today.difference(dueDateOnly).inDays;
      return 'Overdue by $difference day${difference == 1 ? '' : 's'}';
    } else {
      final difference = dueDateOnly.difference(today).inDays;
      return 'Due in $difference day${difference == 1 ? '' : 's'}';
    }
  }

  Color _getDueDateColor(BuildContext context, DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (todo.dueDate == null) return AppTheme.getTextSecondary(context);

    if (dueDateOnly.isBefore(today)) {
      return Theme.of(context).colorScheme.error; // Red - overdue
    } else if (dueDateOnly == today) {
      return AppColors.warningColor; // Amber - due today
    } else {
      // Future dates
      return AppTheme.getTextSecondary(context); // Gray - future
    }
  }
}
