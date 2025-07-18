import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/todos/models/todos_content_model.dart';
import 'package:zoey/features/todos/providers/todos_content_item_proivder.dart';

class TodosContentWidget extends ConsumerWidget {
  final String todosContentId;
  final bool isEditing;
  const TodosContentWidget({
    super.key,
    required this.todosContentId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(Icons.checklist, size: 16),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'Todo list title',
                isEditing: isEditing,
                controller: ref.watch(
                  todosContentTitleControllerProvider(todosContentId),
                ),
                textStyle: Theme.of(context).textTheme.titleMedium,
                onTextChanged: (value) => ref
                    .read(todosContentUpdateProvider)
                    .call(todosContentId, title: value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _buildTodosList(context, ref),
      ],
    );
  }

  Widget _buildTodosList(BuildContext context, WidgetRef ref) {
    final todosContent = ref.watch(todosContentItemProvider(todosContentId));
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: todosContent.items.length,
      itemBuilder: (context, index) =>
          _buildTodoItem(context, ref, todosContent, index),
    );
  }

  Widget _buildTodoItem(
    BuildContext context,
    WidgetRef ref,
    TodosContentModel todosContent,
    int index,
  ) {
    final titleControllerKey = '$todosContentId-$index';
    final titleController = ref.watch(
      todosContentItemTitleControllerProvider(titleControllerKey),
    );
    return Row(
      children: [
        Checkbox(
          value: todosContent.items[index].isCompleted,
          onChanged: (value) => ref
              .read(todosContentUpdateProvider)
              .call(
                todosContentId,
                items: [
                  ...todosContent.items.asMap().entries.map(
                    (entry) => entry.key == index
                        ? entry.value.copyWith(isCompleted: value)
                        : entry.value,
                  ),
                ],
              ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: ZoeInlineTextEditWidget(
            hintText: 'Todo item',
            isEditing: isEditing,
            controller: titleController,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            onTextChanged: (value) => ref
                .read(todosContentUpdateProvider)
                .call(
                  todosContentId,
                  items: [
                    ...todosContent.items.asMap().entries.map(
                      (entry) => entry.key == index
                          ? entry.value.copyWith(title: value)
                          : entry.value,
                    ),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}
