import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';

class TaskCheckboxWidget extends ConsumerWidget {
  final TaskModel task;

  const TaskCheckboxWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Checkbox(
      value: task.isCompleted,
      activeColor: AppColors.successColor,
      checkColor: Colors.white,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      side: BorderSide(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        width: 2.0,
      ),
      onChanged: (value) {
        ref
            .read(taskListProvider.notifier)
            .updateTaskCompletion(task.id, value ?? false);
      },
    );
  }
}
