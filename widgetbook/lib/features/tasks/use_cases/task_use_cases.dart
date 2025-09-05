import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/screens/task_detail_screen.dart';
import 'package:zoe/features/task/screens/tasks_list_screen.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';
import 'package:zoe/features/task/widgets/task_list_widget.dart';
import 'package:widgetbook_workspace/features/tasks/mock_task_providers.dart';
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';

@widgetbook.UseCase(name: 'Task List Screen', type: TaskListWidget)
Widget buildTaskListScreenUseCase(BuildContext context) {
  final isEditing = context.knobs.boolean(
    label: 'Is Editing',
    description: 'Toggle edit mode',
    initialValue: false,
  );

  final shrinkWrap = context.knobs.boolean(
    label: 'Shrink Wrap',
    description: 'Whether to shrink wrap the list',
    initialValue: true,
  );

  final maxItems = context.knobs.int.input(
    label: 'Max Items',
    description: 'Maximum number of items to display',
    initialValue: 3,
  );

  return Consumer(
    builder: (context, ref, _) {
      final taskCount = context.knobs.int.input(
        label: 'Task Count',
        initialValue: 3,
      );

      final tasks = List.generate(taskCount, (index) {
        return TaskModel(
          id: 'task-$index',
          title: context.knobs.string(
            label: 'Task $index Title',
            initialValue: 'Task $index',
          ),
          dueDate: DateTime.now().add(Duration(days: index - 1)),
          isCompleted: context.knobs.boolean(
            label: 'Task $index Completed',
            initialValue: index.isEven,
          ),
          parentId: 'list-1',
          orderIndex: index,
          assignedUsers: ['user_1'],
          sheetId: '',
        );
      });

      return ProviderScope(
        overrides: [
          taskListProvider.overrideWith(
            (ref) => MockTaskNotifier(ref)..setTasks(tasks),
          ),
          taskProvider.overrideWith((ref, taskId) {
            final taskList = ref.watch(taskListProvider);
            return taskList.where((t) => t.id == taskId).firstOrNull;
          }),
          todaysTasksProvider.overrideWith(
            (ref) => ref.watch(mockTodaysTasksProvider),
          ),
          upcomingTasksProvider.overrideWith(
            (ref) => ref.watch(mockUpcomingTasksProvider),
          ),
          pastDueTasksProvider.overrideWith(
            (ref) => ref.watch(mockPastDueTasksProvider),
          ),
        ],
        child: ZoePreview(
          child: TaskListWidget(
            tasksProvider: taskListProvider,
            isEditing: isEditing,
            shrinkWrap: shrinkWrap,
            maxItems: maxItems,
          ),
        ),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Task Detail Screen', type: TaskDetailScreen)
Widget buildTaskDetailScreenUseCase(BuildContext context) {
  final taskId = context.knobs.string(label: 'Task ID', initialValue: 'task-1');

  final task = TaskModel(
    id: taskId,
    title: context.knobs.string(
      label: 'Task Title',
      initialValue: 'Sample Task',
    ),
    dueDate: DateTime.now(),
    isCompleted: context.knobs.boolean(
      label: 'Is Completed',
      initialValue: false,
    ),
    parentId: 'list-1',
    orderIndex: 0,
    assignedUsers: ['user_1'],
    sheetId: '',
  );

  return Consumer(
    builder: (context, ref, _) {
      return ProviderScope(
        overrides: [
          taskListProvider.overrideWith(
            (ref) => MockTaskNotifier(ref)..setTasks([task]),
          ),
          taskProvider.overrideWith((ref, id) => id == taskId ? task : null),
        ],
        child: ZoePreview(child: TaskDetailScreen(taskId: taskId)),
      );
    },
  );
}

@widgetbook.UseCase(name: 'Tasks List Screen', type: TasksListScreen)
Widget buildTasksListScreenUseCase(BuildContext context) {
  return ZoePreview(child: TasksListScreen());
}

@widgetbook.UseCase(name: 'Task Widget', type: TaskWidget)
Widget buildTaskWidgetUseCase(BuildContext context) {
  final taskId = context.knobs.string(label: 'Task ID', initialValue: 'task-1');

  return ZoePreview(child: TaskWidget(taskId: taskId, isEditing: false));
}
