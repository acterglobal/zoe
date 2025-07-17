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
          todo.title,
          style: TextStyle(
            fontSize: 16,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted
                ? AppTheme.getTextTertiary(context)
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
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
}
