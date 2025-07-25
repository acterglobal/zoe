import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/date_time_utils.dart';
import 'package:zoey/common/widgets/attribute_field_widget.dart';
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
        AttributeFieldWidget(
          icon: Icons.calendar_month,
          title: 'Start Date',
          isEditing: isEditing,
          onTapValue: () => updateEventStartDate(context, ref, event),
          valueWidget: Text(
            startDateText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 5),
        AttributeFieldWidget(
          icon: Icons.calendar_month,
          title: 'Start Time',
          isEditing: isEditing,
          onTapValue: () => updateEventStartTime(context, ref, event),
          valueWidget: Text(
            startTimeText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 5),
        AttributeFieldWidget(
          icon: Icons.calendar_month,
          title: 'End Date',
          isEditing: isEditing,
          onTapValue: () => updateEventEndDate(context, ref, event),
          valueWidget: Text(
            endDateText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 5),
        AttributeFieldWidget(
          icon: Icons.calendar_month,
          title: 'End Time',
          isEditing: isEditing,
          onTapValue: () => updateEventEndTime(context, ref, event),
          valueWidget: Text(
            endTimeText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
