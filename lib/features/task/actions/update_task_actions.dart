import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Zoe/common/utils/date_time_utils.dart';
import 'package:Zoe/features/task/models/task_model.dart';
import 'package:Zoe/features/task/providers/task_providers.dart';

Future<void> updateTaskDueDate(
  BuildContext context,
  WidgetRef ref,
  TaskModel task,
) async {
  // Show date picker dialog
  final selectedDate = await DateTimeUtils.showDatePickerDialog(
    context,
    selectedDate: task.dueDate,
  );
  if (selectedDate == null) return;

  // Update the task due date
  ref.read(taskListProvider.notifier).updateTaskDueDate(task.id, selectedDate);
}
