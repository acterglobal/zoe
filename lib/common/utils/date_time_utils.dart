import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/l10n/generated/l10n.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/task/models/task_model.dart';

class DateTimeUtils {
  static const String dateFormat = 'd MMM yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'd MMM yyyy hh:mm a';
  static const String dateFormatWithDay = 'EEE, MMM d';

  static String formatDate(DateTime date) {
    return DateFormat(dateFormat).format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat(timeFormat).format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat(dateTimeFormat).format(date);
  }

  static String getMonthText(DateTime date) {
    return DateFormat('MMM').format(date).toUpperCase();
  }

  static String getDayText(DateTime date) {
    return DateFormat('d').format(date);
  }

  static TimeOfDay getTimeOfDayFromDateTime(DateTime date) {
    return TimeOfDay.fromDateTime(date);
  }

  static DateTime updateDateTimeForTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  static String getCurrentDateFormatted({String? format}) {
    final now = DateTime.now();
    return DateFormat(format ?? dateFormatWithDay).format(now);
  }

  static String formatEventDateAndTime(BuildContext context, EventModel event) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(
      event.startDate.year,
      event.startDate.month,
      event.startDate.day,
    );

    String dayText;
    if (eventDate == today) {
      dayText = L10n.of(context).today;
    } else if (eventDate == today.add(const Duration(days: 1))) {
      dayText = L10n.of(context).tomorrow;
    } else {
      dayText = DateFormat('EEE').format(eventDate);
    }

    final timeText = DateFormat(timeFormat).format(event.startDate);
    return L10n.of(context).dayAtTime(dayText, timeText);
  }

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
      return L10n.of(context).dueDayMonth(task.dueDate.day, task.dueDate.month);
    }
  }

  static Color getTaskDueDateColor(TaskModel task) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
    );
    final difference = dueDate.difference(today).inDays;

    if (difference < 0) {
      return AppColors.errorColor;
    } else if (difference == 0) {
      return AppColors.brightOrangeColor;
    } else if (difference == 1) {
      return AppColors.brightMagentaColor;
    } else if (difference <= 3) {
      return AppColors.primaryColor;
    } else {
      return AppColors.successColor;
    }
  }

  static Future<DateTime?> showDatePickerDialog(
    BuildContext context, {
    DateTime? selectedDate,
  }) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1);
    final lastDate = DateTime(now.year + 1);

    return await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  static Future<TimeOfDay?> showTimePickerDialog(
    BuildContext context, {
    TimeOfDay? selectedTime,
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
  }
}

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}
