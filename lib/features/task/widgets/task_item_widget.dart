import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_providers.dart';

class TaskWidget extends ConsumerWidget {
  final String taskId;
  final bool isEditing;

  const TaskWidget({super.key, required this.taskId, this.isEditing = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditValueProvider);
    final task = ref.watch(taskProvider(taskId));

    if (task == null) return const SizedBox.shrink();

    return _buildTaskItemContent(context, ref, task, isEditing);
  }

  Widget _buildTaskItemContent(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
    bool isEditing,
  ) {
    return Row(
      children: [
        _buildTaskItemIcon(context, ref, task),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTaskItemTitle(
            context,
            ref,
            task.title,
            task.isCompleted,
          ),
        ),
        const SizedBox(width: 6),
        if (isEditing) _buildTaskItemActions(context, ref),
      ],
    );
  }

  // Builds the task item icon
  Widget _buildTaskItemIcon(
    BuildContext context,
    WidgetRef ref,
    TaskModel taskItem,
  ) {
    return Checkbox(
      value: taskItem.isCompleted,
      activeColor: AppColors.successColor,
      checkColor: Colors.white,
      side: BorderSide(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      onChanged: (value) {
        ref
            .read(taskListProvider.notifier)
            .updateTaskCompletion(taskId, value ?? false);
      },
    );
  }

  // Builds the task item title
  Widget _buildTaskItemTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
    bool isCompleted,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'Bullet item',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        decoration: isCompleted
            ? TextDecoration.lineThrough
            : TextDecoration.none,
      ),
      onTextChanged: (value) {
        ref.read(taskListProvider.notifier).updateTaskTitle(taskId, value);
      },
    );
  }

  // Builds the task item actions
  Widget _buildTaskItemActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Edit list item
        GestureDetector(
          onTap: () => context.push(
            AppRoutes.taskDetail.route.replaceAll(':taskId', taskId),
          ),
          child: Icon(
            Icons.edit,
            size: 16,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(width: 6),

        // Delete list item
        ZoeCloseButtonWidget(
          onTap: () {
            ref.read(taskListProvider.notifier).deleteTask(taskId);
          },
        ),
      ],
    );
  }
}
