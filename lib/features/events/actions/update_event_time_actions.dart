import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/common/utils/date_time_utils.dart';
import 'package:Zoe/features/events/models/events_model.dart';
import 'package:Zoe/features/events/providers/events_proivder.dart';

/// Updates the start date of the event
Future<void> updateEventStartDate(
  BuildContext context,
  WidgetRef ref,
  EventModel event,
) async {
  // Get the start date and event id
  final startDate = event.startDate;
  final endDate = event.endDate;
  final eventId = event.id;

  // Show date picker dialog
  final selectedDate = await DateTimeUtils.showDatePickerDialog(
    context,
    selectedDate: startDate,
  );
  if (selectedDate == null) return;

  // Update the start date
  final startDateTime = DateTimeUtils.updateDateTimeForTime(
    selectedDate,
    DateTimeUtils.getTimeOfDayFromDateTime(startDate),
  );

  // Check if the start date is before the selected date
  if (endDate.isBefore(startDateTime)) {
    // Update the event end date
    ref
        .read(eventListProvider.notifier)
        .updateEventEndDate(eventId, startDateTime.add(const Duration(hours: 1)));
  }

  // Update the event start date
  ref
      .read(eventListProvider.notifier)
      .updateEventStartDate(eventId, startDateTime);
}

/// Updates the start date and time of the event
Future<void> updateEventStartTime(
  BuildContext context,
  WidgetRef ref,
  EventModel event,
) async {
  // Get the start date and event id
  final startDate = event.startDate;
  final endDate = event.endDate;
  final eventId = event.id;

  // Get the start time
  final startTime = DateTimeUtils.getTimeOfDayFromDateTime(startDate);

  // Show time picker dialog
  final selectedTime = await DateTimeUtils.showTimePickerDialog(
    context,
    selectedTime: startTime,
  );
  if (selectedTime == null || !context.mounted) return;

  // Update the start date
  final startDateTime = DateTimeUtils.updateDateTimeForTime(
    startDate,
    selectedTime,
  );

  // Check if the start date is before the selected date
  if (endDate.isBefore(startDateTime)) {
    // Update the event end date
    ref
        .read(eventListProvider.notifier)
        .updateEventEndDate(eventId, startDateTime.add(const Duration(hours: 1)));
  }

  // Update the event start date
  ref
      .read(eventListProvider.notifier)
      .updateEventStartDate(eventId, startDateTime);
}

/// Updates the end date of the event
Future<void> updateEventEndDate(
  BuildContext context,
  WidgetRef ref,
  EventModel event,
) async {
  // Get the end date and event id
  final startDate = event.startDate;
  final endDate = event.endDate;
  final eventId = event.id;

  // Show date picker dialog
  final selectedDate = await DateTimeUtils.showDatePickerDialog(
    context,
    selectedDate: endDate,
  );
  if (selectedDate == null) return;

  // Update the end date
  final endDateTime = DateTimeUtils.updateDateTimeForTime(
    selectedDate,
    DateTimeUtils.getTimeOfDayFromDateTime(endDate),
  );

  // Check if the end date is before the selected date
  if (startDate.isAfter(endDateTime)) {
    // Update the event start date
    ref
        .read(eventListProvider.notifier)
        .updateEventStartDate(eventId, endDateTime);
  }

  // Update the event end date
  ref.read(eventListProvider.notifier).updateEventEndDate(eventId, endDateTime);
}

/// Updates the end date and time of the event
Future<void> updateEventEndTime(
  BuildContext context,
  WidgetRef ref,
  EventModel event,
) async {
  // Get the end date and event id
  final startDate = event.startDate;
  final endDate = event.endDate;
  final eventId = event.id;

  // Get the end time
  final endTime = DateTimeUtils.getTimeOfDayFromDateTime(endDate);

  // Show time picker dialog
  final selectedTime = await DateTimeUtils.showTimePickerDialog(
    context,
    selectedTime: endTime,
  );
  if (selectedTime == null || !context.mounted) return;

  // Update the end date
  final endDateTime = DateTimeUtils.updateDateTimeForTime(
    endDate,
    selectedTime,
  );

  // Check if the end date is before the selected date
  if (startDate.isAfter(endDateTime)) {
    // Update the event start date
    ref
        .read(eventListProvider.notifier)
        .updateEventStartDate(eventId, endDateTime);
  }

  // Update the event end date
  ref.read(eventListProvider.notifier).updateEventEndDate(eventId, endDateTime);
}
