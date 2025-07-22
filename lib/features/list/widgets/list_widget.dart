import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/common/widgets/emoji_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/bullets/providers/bullet_providers.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/list/providers/list_providers.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/task/widgets/task_list_widget.dart';
import 'package:zoey/features/list/models/list_model.dart';
import 'package:zoey/features/bullets/widgets/bullet_list_widget.dart';

class ListWidget extends ConsumerWidget {
  final String listId;
  const ListWidget({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the content edit mode provider
    final isEditing = ref.watch(isEditValueProvider);

    final list = ref.watch(listItemProvider(listId));
    if (list == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _buildListContent(context, ref, list, isEditing),
    );
  }

  Widget _buildListContent(
    BuildContext context,
    WidgetRef ref,
    ListModel list,
    bool isEditing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildListBlockIcon(
              context,
              ref,
              listId,
              list.listType,
              list.emoji,
            ),
            Expanded(
              child: _buildListBlockTitle(context, ref, list.title, isEditing),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () => ref.read(listsrovider.notifier).deleteList(listId),
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
  Widget _buildListBlockIcon(
    BuildContext context,
    WidgetRef ref,
    String listId,
    ListType listType,
    String? emoji,
  ) {
    if (emoji != null) {
      return EmojiWidget(
        emoji: emoji,
        onTap: (currentEmoji) => ref
            .read(listsrovider.notifier)
            .updateListEmoji(listId, CommonUtils.getNextEmoji(currentEmoji)),
      );
    }
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
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'List title',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      onTextChanged: (value) =>
          ref.read(listsrovider.notifier).updateListTitle(listId, value),
    );
  }

  // Builds the add list item button
  Widget _buildAddListItemButton(
    BuildContext context,
    WidgetRef ref,
    ListType listType,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 24),
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
