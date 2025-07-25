import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/date_time_utils.dart';
import 'package:zoey/common/widgets/details_additional_field.dart';
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
        DetailsAdditionalField(
          icon: Icons.calendar_month,
          title: 'Due Date',
          isEditing: isEditing,
          onChildTap: () => updateTaskDueDate(context, ref, task),
          child: Text(
            dueDateText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 10),
        DetailsAdditionalField(
          icon: Icons.check_box,
          title: 'Completed',
          child: SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: task.isCompleted,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (value) => updateTaskCompletion(context, ref, task),
            ),
          ),
        ),
      ],
    );
  }
}
