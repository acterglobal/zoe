import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoey/common/utils/date_time_utils.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class EventUtils {
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

    final timeText = DateFormat(
      DateTimeUtils.timeFormat,
    ).format(event.startDate);
    return L10n.of(context).dayAtTime(dayText, timeText);
  }

  static Color getRsvpStatusColor(RsvpStatus status) {
    switch (status) {
      case RsvpStatus.yes:
        return AppColors.successColor;
      case RsvpStatus.no:
        return AppColors.errorColor;
      case RsvpStatus.maybe:
        return AppColors.primaryColor;
    }
  }
}
