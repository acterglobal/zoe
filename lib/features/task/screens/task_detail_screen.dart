import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/edit_view_toggle_button.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/content/widgets/content_widget.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_providers.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskProvider(taskId));
    if (task == null) return const Center(child: Text('Task not found'));
    return Scaffold(
      appBar: AppBar(
        actions: [EditViewToggleButton(), const SizedBox(width: 12)],
      ),
      body: _buildBody(context, ref, task),
    );
  }

  /// Builds the main body
  Widget _buildBody(BuildContext context, WidgetRef ref, TaskModel task) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskHeader(context, ref, task),
          const SizedBox(height: 16),
          ContentWidget(parentId: taskId, sheetId: task.sheetId),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildTaskHeader(BuildContext context, WidgetRef ref, TaskModel task) {
    final isEditing = ref.watch(isEditValueProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'Title',
                isEditing: isEditing,
                text: task.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZoeInlineTextEditWidget(
          hintText: 'Add a description',
          isEditing: isEditing,
          text: task.description?.plainText,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          onTextChanged: (value) {},
        ),
      ],
    );
  }
}
