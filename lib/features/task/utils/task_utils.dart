import 'package:flutter/material.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class TaskUtils {
  static String formatTaskDueDate(BuildContext context, TaskModel task) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
    );
    final difference = dueDate.difference(today).inDays;

    if (difference < 0) {
      final overdueDays = -difference;
      return L10n.of(context).overdueByDays(
        overdueDays == 1
            ? L10n.of(context).oneDay
            : L10n.of(context).daysCounts(overdueDays),
      );
    } else if (difference == 0) {
      return L10n.of(context).dueToday;
    } else if (difference == 1) {
      return L10n.of(context).dueTomorrow;
    } else if (difference <= 7) {
      return L10n.of(context).dueInDays(difference);
    } else {
      return L10n.of(context).dueAtDayMonth(task.dueDate.day, task.dueDate.month);
    }
  }
}
