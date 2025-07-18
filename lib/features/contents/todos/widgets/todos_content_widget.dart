import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/todos/models/todos_content_model.dart';
import 'package:zoey/features/contents/todos/providers/todos_content_item_proivder.dart';

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
    final todosContent = ref.watch(todosContentItemProvider(todosContentId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        isEditing
            ? _buildTitleTextField(context, ref, todosContent.title)
            : _buildTitleText(context, ref, todosContent.title),
        const SizedBox(height: 6),
        isEditing
            ? _buildDataTextField(context, ref, todosContent.items)
            : _buildDataText(context, ref, todosContent.items),
      ],
    );
  }

  Widget _buildTitleTextField(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) {
    final controller = ref.watch(
      todosContentTitleControllerProvider(todosContentId),
    );
    final updateContent = ref.read(todosContentUpdateProvider);

    return TextField(
      controller: controller,
      maxLines: null,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: const InputDecoration(
        hintText: 'Title',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      onChanged: (value) {
        updateContent(todosContentId, title: value);
      },
    );
  }

  Widget _buildDataTextField(
    BuildContext context,
    WidgetRef ref,
    List<TodoItem> items,
  ) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final titleControllerKey = '$todosContentId-$index';
        final titleController = ref.watch(
          todosContentItemTitleControllerProvider(titleControllerKey),
        );
        final descriptionController = ref.watch(
          todosContentItemDescriptionControllerProvider(titleControllerKey),
        );
        final updateContent = ref.read(todosContentUpdateProvider);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              items[index].isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Task title...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      final updatedItems = List<TodoItem>.from(items);
                      updatedItems[index] = items[index].copyWith(title: value);
                      updateContent(todosContentId, items: updatedItems);
                    },
                  ),
                  TextField(
                    controller: descriptionController,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Description...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      final updatedItems = List<TodoItem>.from(items);
                      updatedItems[index] = items[index].copyWith(
                        description: value,
                      );
                      updateContent(todosContentId, items: updatedItems);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleText(BuildContext context, WidgetRef ref, String title) {
    return Text(
      title.isEmpty ? 'Untitled' : title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildDataText(
    BuildContext context,
    WidgetRef ref,
    List<TodoItem> items,
  ) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Row(
        children: [
          Icon(
            items[index].isCompleted
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  items[index].title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (items[index].description?.isNotEmpty == true)
                  Text(
                    items[index].description!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
