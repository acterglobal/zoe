import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/task/actions/add_assignee_action.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class TaskAssigneeHeaderWidget extends ConsumerWidget {
  final bool isEditing;
  final TaskModel task;
  final double? iconSize;
  final double? textSize;
  
  const TaskAssigneeHeaderWidget({
    super.key,
    required this.isEditing,
    required this.task,
    this.iconSize = 20,
    this.textSize = 14,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.people_rounded, size: iconSize),
        const SizedBox(width: 8),
        Text(
          L10n.of(context).assignees,
          style: theme.textTheme.titleMedium?.copyWith(fontSize: textSize),
        ),
        const Spacer(),
        if (isEditing)
          IconButton(
            onPressed: () => assignTask(context, ref, task),
            icon: Icon(Icons.add_circle_outline_rounded, size: 24),
          ),
      ],
    );
  }
}
