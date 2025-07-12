import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../common/models/content_block.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem todo;
  final Function(bool)? onChanged;

  const TodoItemWidget({super.key, required this.todo, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                    ? const Color(0xFF10B981)
                    : Colors.transparent,
                border: Border.all(
                  color: todo.isCompleted
                      ? const Color(0xFF10B981)
                      : const Color(0xFFD1D5DB),
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
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: todo.isCompleted
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF1F2937),
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
                        color: _getDueDateColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDueDate(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: _getDueDateColor(),
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

  Color _getDueDateColor() {
    if (todo.dueDate == null) return const Color(0xFF6B7280);

    final now = DateTime.now();
    final dueDate = todo.dueDate!;
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) {
      return const Color(0xFFEF4444); // Red - overdue
    } else if (difference == 0) {
      return const Color(0xFFF59E0B); // Amber - due today
    } else if (difference <= 3) {
      return const Color(0xFF8B5CF6); // Purple - due soon
    } else {
      return const Color(0xFF6B7280); // Gray - future
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
