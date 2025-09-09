import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/edit_view_toggle_button.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/add_content_bottom_sheet.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/task/models/task_model.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_details_additional_fields.dart';
import 'package:zoe/features/task/widgets/task_assignees_widget.dart';
import 'package:zoe/features/task/widgets/task_checkbox_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskProvider(taskId));
    final editContentId = ref.watch(editContentIdProvider);
    final isEditing = editContentId == taskId;
    return NotebookPaperBackgroundWidget(
      child: task != null
          ? _buildDataTaskWidget(context, ref, task, isEditing)
          : _buildEmptyTaskWidget(context),
    );
  }

  Widget _buildEmptyTaskWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(automaticallyImplyLeading: false, title: ZoeAppBar()),
      body: Center(
        child: EmptyStateWidget(
          message: L10n.of(context).taskNotFound,
          icon: Icons.task_alt_outlined,
        ),
      ),
    );
  }

  Widget _buildDataTaskWidget(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
    bool isEditing,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(
          actions: [
            EditViewToggleButton(parentId: taskId),
            const SizedBox(width: 10),
            ContentMenuButton(parentId: taskId),
          ],
        ),
      ),
      body: MaxWidthWidget(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildBody(context, ref, task, isEditing),
                  buildQuillEditorPositionedToolbar(
                    context,
                    ref,
                    isEditing: isEditing,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CommonUtils.isKeyboardOpen(context) ? null : _buildFloatingActionButton(
        context,
        isEditing,
        task,
      ),
    );
  }

  Widget _buildFloatingActionButton(
    BuildContext context,
    bool isEditing,
    TaskModel task,
  ) {
    if (!isEditing) return const SizedBox.shrink();
    return ZoeFloatingActionButton(
      icon: Icons.add_rounded,
      onPressed: () => showAddContentBottomSheet(
        context,
        parentId: taskId,
        sheetId: task.sheetId,
      ),
    );
  }

  /// Builds the main body
  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
    bool isEditing,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskHeader(context, ref, task, isEditing),
          const SizedBox(height: 16),
          ContentWidget(parentId: taskId, sheetId: task.sheetId),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildTaskHeader(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
    bool isEditing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Transform.scale(
                scale: 1.5,
                child: TaskCheckboxWidget(task: task),
              ),
            ),
            const SizedBox(width: 16),
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
          editorId: 'task-description-$taskId',
          // Add unique editor ID
          onContentChanged: (description) => Future.microtask(
            () => ref
                .read(taskListProvider.notifier)
                .updateTaskDescription(taskId, description),
          ),
        ),
        const SizedBox(height: 16),
        TaskDetailsAdditionalFields(task: task, isEditing: isEditing),
        const SizedBox(height: 16),
        TaskAssigneesWidget(task: task, isEditing: isEditing),
      ],
    );
  }
}
