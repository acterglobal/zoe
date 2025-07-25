import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/edit_view_toggle_button.dart';

import 'package:zoey/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/content/widgets/content_widget.dart';
import 'package:zoey/features/task/models/task_model.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/task/widgets/task_details_additional_fields.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskProvider(taskId));
    if (task == null) return Center(child: Text(L10n.of(context).taskNotFound));
    return Scaffold(
      appBar: AppBar(
        actions: [
          EditViewToggleButton(parentId: taskId),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildBody(context, ref, task),
                buildQuillEditorPositionedToolbar(context, ref),
              ],
            ),
          ),
        ],
      ),
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
    final isEditing = ref.watch(isEditValueProvider(taskId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: L10n.of(context).title,
                isEditing: isEditing,
                text: task.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) => ref
                    .read(taskListProvider.notifier)
                    .updateTaskTitle(taskId, value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZoeHtmlTextEditWidget(
          hintText: L10n.of(context).addADescription,
          isEditing: isEditing,
          description: task.description,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          editorId: 'task-description-$taskId', // Add unique editor ID
          onContentChanged: (description) => Future.microtask(
            () => ref
                .read(taskListProvider.notifier)
                .updateTaskDescription(taskId, description),
          ),
        ),
        const SizedBox(height: 16),
        TaskDetailsAdditionalFields(task: task, isEditing: isEditing),
      ],
    );
  }
}
