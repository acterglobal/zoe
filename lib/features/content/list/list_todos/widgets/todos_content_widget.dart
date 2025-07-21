import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/content/list/list_todos/models/todos_content_model.dart';
import 'package:zoey/features/content/list/list_todos/providers/todos_content_item_proivder.dart';

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
              child: Icon(
                Icons.checklist,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'Todo list title',
                isEditing: isEditing,
                text: ref.watch(todosContentItemProvider(todosContentId)).title,
                textStyle: Theme.of(context).textTheme.bodyLarge,
                onTextChanged: (value) => ref
                    .read(todosContentUpdateProvider)
                    .call(todosContentId, title: value),
              ),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () {
                  final todosContent = ref.read(
                    todosContentItemProvider(todosContentId),
                  );
                  ref
                      .read(sheetDetailProvider(todosContent.parentId).notifier)
                      .deleteContent(todosContentId);
                },
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildTodosList(context, ref),
        if (isEditing)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () {
                final currentTodosContent = ref.read(
                  todosContentItemProvider(todosContentId),
                );
                final updatedItems = [
                  ...currentTodosContent.items,
                  TodoItem(title: ''),
                ];
                ref
                    .read(todosContentUpdateProvider)
                    .call(todosContentId, items: updatedItems);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Add to-do',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    return Row(
      children: [
        Checkbox(
          activeColor: AppColors.successColor,
          checkColor: Colors.white,
          side: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
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
            text: todosContent.items[index].title,
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              decoration: todosContent.items[index].isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
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
        const SizedBox(width: 6),
        if (isEditing) ...[
          GestureDetector(
            onTap: () => context.push(
              AppRoutes.taskDetail.route.replaceAll(
                ':taskId',
                todosContent.items[index].id,
              ),
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
          ZoeCloseButtonWidget(
            onTap: () {
              final currentTodosContent = ref.read(
                todosContentItemProvider(todosContentId),
              );
              final updatedItems = [...currentTodosContent.items];
              updatedItems.removeAt(index);
              ref
                  .read(todosContentUpdateProvider)
                  .call(todosContentId, items: updatedItems);
            },
          ),
        ],
      ],
    );
  }
}
