import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/providers/common_providers.dart';
import 'package:zoey/common/widgets/max_width_widget.dart';
import 'package:zoey/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/task/widgets/task_item_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class TasksListScreen extends ConsumerStatefulWidget {
  const TasksListScreen({super.key});

  @override
  ConsumerState<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends ConsumerState<TasksListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(searchValueProvider.notifier).state = '',
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MaxWidthWidget(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              ZoeAppBar(title: L10n.of(context).tasks),
              const SizedBox(height: 16),
              ZoeSearchBarWidget(
                controller: searchController,
                onChanged: (value) =>
                    ref.read(searchValueProvider.notifier).state = value,
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildTaskList(context, ref)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListSearchProvider);
    if (tasks.isEmpty) {
      return EmptyStateWidget(message: L10n.of(context).noTasksFound);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      padding: const EdgeInsets.only(bottom: 30),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskItem(context, task);
      },
    );
  }

  Widget _buildTaskItem(BuildContext context, TaskModel task) {
    return Card(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: TaskWidget(key: Key(task.id), taskId: task.id, isEditing: false),
      ),
    );
  }
}
