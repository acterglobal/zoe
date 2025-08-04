import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/date_time_utils.dart';
import 'package:zoey/common/widgets/attribute_field_widget.dart';
import 'package:zoey/features/task/actions/update_task_actions.dart';
import 'package:zoey/features/task/models/task_model.dart';


class TaskDetailsAdditionalFields extends ConsumerWidget {
  final TaskModel task;
  final bool isEditing;

  const TaskDetailsAdditionalFields({
    super.key,
    required this.task,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueDate = task.dueDate;
    final dueDateText = DateTimeUtils.formatDate(dueDate);

    return Column(
      children: [
        AttributeFieldWidget(
          icon: Icons.calendar_month,
          title: 'Due Date',
          isEditing: isEditing,
          onTapValue: () => updateTaskDueDate(context, ref, task),
          valueWidget: Text(
            dueDateText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
