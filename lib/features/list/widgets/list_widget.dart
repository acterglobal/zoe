import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/common/widgets/emoji_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/bullets/providers/bullet_providers.dart';
import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/events/models/events_model.dart';
import 'package:zoey/features/events/providers/events_proivder.dart';
import 'package:zoey/features/events/widgets/event_list_widget.dart';
import 'package:zoey/features/list/providers/list_providers.dart';
import 'package:zoey/features/task/providers/task_providers.dart';
import 'package:zoey/features/task/widgets/task_list_widget.dart';
import 'package:zoey/features/list/models/list_model.dart';
import 'package:zoey/features/bullets/widgets/bullet_list_widget.dart';
import 'package:zoey/features/text/models/text_model.dart';
import 'package:zoey/features/text/providers/text_providers.dart';
import 'package:zoey/features/text/widgets/text_list_widget.dart';

class ListWidget extends ConsumerWidget {
  final String listId;
  const ListWidget({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(listItemProvider(listId));
    if (list == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _buildListContent(context, ref, list),
    );
  }

  Widget _buildListContent(
    BuildContext context,
    WidgetRef ref,
    ListModel list,
  ) {
    /// Watch the content edit mode provider
    final isEditing = ref.watch(isEditValueProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildListEmoji(context, ref, listId, list.listType, list.emoji),
            Expanded(
              child: _buildListTitle(context, ref, list.title, isEditing),
            ),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () => ref.read(listsrovider.notifier).deleteList(listId),
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildListTypeContent(context, ref, list),
        if (isEditing)
          _buildAddListItemButton(context, ref, list.listType, list.sheetId),
      ],
    );
  }

  // Builds the list block icon
  Widget _buildListEmoji(
    BuildContext context,
    WidgetRef ref,
    String listId,
    ContentType contentType,
    String? emoji,
  ) {
    return EmojiWidget(
      emoji: emoji ?? '🔸',
      onTap: (currentEmoji) => ref
          .read(listsrovider.notifier)
          .updateListEmoji(listId, CommonUtils.getNextEmoji(currentEmoji)),
    );
  }

  // Builds the list title
  Widget _buildListTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: 'List title',
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      onTextChanged: (value) =>
          ref.read(listsrovider.notifier).updateListTitle(listId, value),
    );
  }

  Widget _buildListTypeContent(
    BuildContext context,
    WidgetRef ref,
    ListModel list,
  ) {
    return switch (list.listType) {
      ContentType.bullet => BulletListWidget(parentId: listId),
      ContentType.task => TaskListWidget(parentId: listId),
      ContentType.text => TextListWidget(parentId: listId),
      ContentType.event => EventListWidget(parentId: listId),
      _ => const SizedBox.shrink(),
    };
  }

  // Builds the add list item button
  Widget _buildAddListItemButton(
    BuildContext context,
    WidgetRef ref,
    ContentType contentType,
    String sheetId,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 24),
      child: GestureDetector(
        onTap: () {
          switch (contentType) {
            case ContentType.bullet:
              ref
                  .read(bulletListProvider.notifier)
                  .addBullet('', listId, sheetId);
              break;
            case ContentType.task:
              ref.read(taskListProvider.notifier).addTask('', listId, sheetId);
              break;
            case ContentType.event:
              ref
                  .read(eventListProvider.notifier)
                  .addEvent(
                    EventModel(
                      sheetId: sheetId,
                      parentId: listId,
                      title: '',
                      orderIndex: 0,
                      startDate: DateTime.now(),
                      endDate: DateTime.now(),
                    ),
                  );
              break;
            case ContentType.text:
              ref
                  .read(textListProvider.notifier)
                  .addText(
                    TextModel(
                      sheetId: sheetId,
                      parentId: listId,
                      title: '',
                      orderIndex: 0,
                      description: (plainText: '', htmlText: ''),
                    ),
                  );
              break;
            default:
              break;
          }
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
