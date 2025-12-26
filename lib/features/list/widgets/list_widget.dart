import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/documents/actions/select_document_actions.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/widgets/document_list_widget.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/events/widgets/event_list_widget.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/features/link/widgets/link_list_widget.dart';
import 'package:zoe/features/list/actions/list_actions.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_list_widget.dart';
import 'package:zoe/features/task/providers/task_providers.dart';
import 'package:zoe/features/task/widgets/task_list_widget.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/bullets/widgets/bullet_list_widget.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/text/widgets/text_list_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import 'package:zoe/common/widgets/emoji_picker/widgets/custom_emoji_picker_widget.dart';

class ListWidget extends ConsumerWidget {
  final String listId;

  const ListWidget({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(listItemProvider(listId));
    if (list == null) return const SizedBox.shrink();
    final isEditing = ref.watch(editContentIdProvider) == listId;

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
            _buildListEmoji(context, ref, list, isEditing),
            Expanded(child: _buildListTitle(context, ref, list, isEditing)),
            const SizedBox(width: 6),
            if (isEditing)
              ZoeDeleteButtonWidget(
                onTap: () =>
                    ref.read(listsProvider.notifier).deleteList(list),
              ),
          ],
        ),
        const SizedBox(height: 6),
        _buildListTypeContent(context, ref, list, isEditing),
        if (isEditing) _buildAddListItemButton(context, ref, list),
      ],
    );
  }

  // Builds the list block icon
  Widget _buildListEmoji(
    BuildContext context,
    WidgetRef ref,
    ListModel list,
    bool isEditing,
  ) {
    return EmojiWidget(
      isEditing: isEditing,
      emoji: list.emoji ?? '🔸',
      onTap: (currentEmoji) => showCustomEmojiPicker(
        context,
        ref,
        onEmojiSelected: (emoji) {
          ref.read(listsProvider.notifier).updateListEmoji(listId, emoji);
        },
      ),
    );
  }

  // Builds the list title
  Widget _buildListTitle(
    BuildContext context,
    WidgetRef ref,
    ListModel list,
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: list.listType == ContentType.document
          ? L10n.of(context).documentTitle
          : L10n.of(context).listTitle,
      isEditing: isEditing,
      text: list.title,
      textStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      onTextChanged: (value) =>
          ref.read(listsProvider.notifier).updateListTitle(listId, value),
      onTapText: () => context.push(
        AppRoutes.listDetail.route.replaceAll(':listId', listId),
      ),
      onTapLongPressText: () => showListMenu(
        context: context,
        ref: ref,
        isEditing: isEditing,
        listId: listId,
      ),
    );
  }

  Widget _buildListTypeContent(
    BuildContext context,
    WidgetRef ref,
    ListModel list,
    bool isEditing,
  ) {
    return switch (list.listType) {
      ContentType.bullet => BulletListWidget(
        parentId: listId,
        isEditing: isEditing,
      ),
      ContentType.task => TaskListWidget(
        tasksProvider: taskByParentProvider(listId),
        isEditing: isEditing,
        showCardView: false,
      ),
      ContentType.text => TextListWidget(
        textsProvider: textByParentProvider(listId),
        isEditing: isEditing,
      ),
      ContentType.event => EventListWidget(
        eventsProvider: eventByParentProvider(listId),
        isEditing: isEditing,
      ),
      ContentType.link => LinkListWidget(
        linksProvider: linkByParentProvider(listId),
        isEditing: isEditing,
        showCardView: false,
      ),
      ContentType.document => DocumentListWidget(
        documentsProvider: documentListByParentProvider(listId),
        isEditing: isEditing,
      ),
      ContentType.poll => PollListWidget(
        pollsProvider: pollListByParentProvider(listId),
        isEditing: isEditing,
        showCardView: false,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  // Builds the add list item button
  Widget _buildAddListItemButton(
    BuildContext context,
    WidgetRef ref,
    ListModel list,
  ) {
    final sheetId = list.sheetId;
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 24),
      child: GestureDetector(
        onTap: () {
          final userId = ref.read(currentUserProvider)?.id;
          if (userId == null) return;
          switch (list.listType) {
            case ContentType.bullet:
              ref
                  .read(bulletListProvider.notifier)
                  .addBullet(parentId: listId, sheetId: sheetId);
              break;
            case ContentType.task:
              ref
                  .read(taskListProvider.notifier)
                  .addTask(parentId: listId, sheetId: sheetId);
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
                      createdBy: userId,
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
                      createdBy: userId,
                    ),
                  );
              break;
            case ContentType.link:
              ref
                  .read(linkListProvider.notifier)
                  .addLink(
                    LinkModel(
                      sheetId: sheetId,
                      parentId: listId,
                      title: '',
                      orderIndex: 0,
                      url: '',
                      createdBy: userId,
                    ),
                  );
              break;
            case ContentType.document:
              selectDocumentSource(context, ref, listId, sheetId);
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
              list.listType == ContentType.document
                  ? l10n.addDocuments
                  : l10n.addItem,
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
