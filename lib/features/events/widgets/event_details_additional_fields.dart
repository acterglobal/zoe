import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/date_time_utils.dart';
import 'package:zoey/common/widgets/details_additional_field.dart';
import 'package:zoey/features/events/actions/update_event_time_actions.dart';
import 'package:zoey/features/events/models/events_model.dart';

class EventDetailsAdditionalFields extends ConsumerWidget {
  final EventModel event;
  final bool isEditing;

  const EventDetailsAdditionalFields({
    super.key,
    required this.event,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = event.startDate;
    final endDate = event.endDate;
    final startDateText = DateTimeUtils.formatDate(startDate);
    final startTimeText = DateTimeUtils.formatTime(startDate);
    final endDateText = DateTimeUtils.formatDate(endDate);
    final endTimeText = DateTimeUtils.formatTime(endDate);

    return Column(
      children: [
        DetailsAdditionalField(
          icon: Icons.calendar_month,
          title: 'Start Date',
          isEditing: isEditing,
          onChildTap: () => updateEventStartDate(context, ref, event),
          child: Text(
            startDateText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 5),
        DetailsAdditionalField(
          icon: Icons.calendar_month,
          title: 'Start Time',
          isEditing: isEditing,
          onChildTap: () => updateEventStartTime(context, ref, event),
          child: Text(
            startTimeText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 5),
        DetailsAdditionalField(
          icon: Icons.calendar_month,
          title: 'End Date',
          isEditing: isEditing,
          onChildTap: () => updateEventEndDate(context, ref, event),
          child: Text(
            endDateText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 5),
        DetailsAdditionalField(
          icon: Icons.calendar_month,
          title: 'End Time',
          isEditing: isEditing,
          onChildTap: () => updateEventEndTime(context, ref, event),
          child: Text(
            endTimeText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
