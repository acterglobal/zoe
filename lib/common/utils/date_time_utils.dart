import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  static String getTodayDateFormatted({String? format}) {
    final now = DateTime.now();
    return DateFormat(format ?? dateFormatWithDay).format(now);
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
