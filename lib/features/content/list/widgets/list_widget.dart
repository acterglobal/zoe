import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/content/list/list_bullets/providers/bullet_list_providers.dart';
import 'package:zoey/features/content/list/list_task/providers/task_list_providers.dart';
import 'package:zoey/features/content/list/list_task/widgets/task_list_widget.dart';
import 'package:zoey/features/content/list/models/list_model.dart';
import 'package:zoey/features/content/list/providers/list_proivder.dart';
import 'package:zoey/features/content/list/list_bullets/widgets/bullet_list_widget.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

class ListWidget extends ConsumerWidget {
  final String listId;
  final bool isEditing;
  const ListWidget({super.key, required this.listId, this.isEditing = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(listProvider(listId));
    if (list == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildListBlockIcon(context, list.listType),
            Expanded(child: _buildListBlockTitle(context, ref, list.title)),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () {
                  ref
                      .read(sheetDetailProvider(list.parentId).notifier)
                      .deleteContent(listId);
                },
              ),
          ],
        ),
        const SizedBox(height: 6),
        list.listType == ListType.bulleted
            ? BulletListWidget(listId: listId, isEditing: isEditing)
            : TaskListWidget(listId: listId, isEditing: isEditing),
        if (isEditing) _buildAddListItemButton(context, ref, list.listType),
      ],
    );
  }

  // Builds the list block icon
  Widget _buildListBlockIcon(BuildContext context, ListType listType) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 6),
      child: Icon(
        listType == ListType.bulleted
            ? Icons.format_list_bulleted
            : Icons.checklist,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  // Builds the list block title
  Widget _buildListBlockTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'List title',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      onTextChanged: (value) =>
          ref.read(listTitleUpdateProvider).call(listId, value),
    );
  }

  // Builds the add list item button
  Widget _buildAddListItemButton(
    BuildContext context,
    WidgetRef ref,
    ListType listType,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: () => listType == ListType.bulleted
            ? ref.read(bulletListProvider.notifier).addBullet('', listId)
            : ref.read(taskListProvider.notifier).addTask('', listId),
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'Add item',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
