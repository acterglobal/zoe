import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/bullets/widgets/bullet_item_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/utils/content_utils.dart';
import 'package:zoe/features/content/widgets/add_content_widget.dart';
import 'package:zoe/features/documents/widgets/document_widget.dart'
    show DocumentWidget;
import 'package:zoe/features/events/widgets/event_widget.dart';
import 'package:zoe/features/link/widgets/link_widget.dart';
import 'package:zoe/features/list/widgets/list_widget.dart';
import 'package:zoe/features/polls/widgets/poll_widget.dart';
import 'package:zoe/features/task/widgets/task_item_widget.dart';
import 'package:zoe/features/text/widgets/text_widget.dart';

class ContentWidget extends ConsumerWidget {
  final String parentId;
  final String sheetId;
  final bool showSheetName;

  const ContentWidget({
    super.key,
    required this.parentId,
    required this.sheetId,
    this.showSheetName = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the content list provider
    final contentList = ref.watch(contentListByParentIdProvider(parentId));
    final isEditing = ref.watch(isEditValueProvider(parentId));

    // Separate documents from other content
    final documents = contentList
        .where((content) => content.type == ContentType.document)
        .toList();
    final otherContent = contentList
        .where((content) => content.type != ContentType.document)
        .toList();

    /// Build the content list
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Documents content type
        if (documents.isNotEmpty) ...[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: documents
                .map(
                  (doc) => _buildContentItem(
                    context,
                    doc,
                    doc.id,
                    isEditing,
                    contentList.indexOf(doc),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
        ],

        // Other content type
        if (otherContent.isNotEmpty)
          isEditing
              ? ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: otherContent.length,
                  buildDefaultDragHandles: false,
                  onReorder: (oldIndex, newIndex) {
                    _handleReorder(ref, otherContent, oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final content = otherContent[index];
                    return _buildContentItem(
                      context,
                      content,
                      content.id,
                      isEditing,
                      index,
                    );
                  },
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: otherContent.length,
                  itemBuilder: (context, index) {
                    final content = otherContent[index];
                    return _buildContentItem(
                      context,
                      content,
                      content.id,
                      isEditing,
                      index,
                    );
                  },
                ),

        AddContentWidget(
          isEditing: isEditing,
          onTapText: () =>
              addNewTextContent(ref: ref, parentId: parentId, sheetId: sheetId),
          onTapEvent: () => addNewEventContent(
            ref: ref,
            parentId: parentId,
            sheetId: sheetId,
          ),
          onTapBulletedList: () => addNewBulletedListContent(
            ref: ref,
            parentId: parentId,
            sheetId: sheetId,
          ),
          onTapToDoList: () => addNewTaskListContent(
            ref: ref,
            parentId: parentId,
            sheetId: sheetId,
          ),
          onTapLink: () =>
              addNewLinkContent(ref: ref, parentId: parentId, sheetId: sheetId),
          onTapDocument: () => addNewDocumentContent(
            ref: ref,
            parentId: parentId,
            sheetId: sheetId,
          ),
          onTapPoll: () =>
              addNewPollContent(ref: ref, parentId: parentId, sheetId: sheetId),
        ),
        const SizedBox(height: 200),
      ],
    );
  }

  Widget _buildContentItem(
    BuildContext context,
    ContentModel content,
    String contentId,
    bool isEditing,
    int index,
  ) {
    final key = ValueKey('${content.type.name}-$contentId');

    Widget contentWidget = switch (content.type) {
      ContentType.text => TextWidget(textId: contentId, isEditing: isEditing),
      ContentType.event => EventWidget(
        eventsId: contentId,
        isEditing: isEditing,
        showSheetName: showSheetName,
      ),
      ContentType.list => ListWidget(listId: contentId, isEditing: isEditing),
      ContentType.task => TaskWidget(
        taskId: contentId,
        isEditing: isEditing,
        showSheetName: showSheetName,
      ),
      ContentType.bullet => BulletItemWidget(
        bulletId: contentId,
        isEditing: isEditing,
      ),
      ContentType.link => LinkWidget(
        linkId: contentId,
        isEditing: isEditing,
        showSheetName: showSheetName,
      ),
      ContentType.document => DocumentWidget(
        documentId: contentId,
        isEditing: isEditing,
        showSheetName: showSheetName,
      ),
      ContentType.poll => PollWidget(
        pollId: contentId,
        isEditing: isEditing,
        showSheetName: showSheetName,
      ),
    };

    if (isEditing && content.type != ContentType.document) {
      return Container(
        key: key,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: ReorderableDragStartListener(
                index: index,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Icon(
                    Icons.drag_indicator,
                    size: 20,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            // Content
            Expanded(child: contentWidget),
          ],
        ),
      );
    }

    return Container(key: key, child: contentWidget);
  }

  void _handleReorder(
    WidgetRef ref,
    List<ContentModel> contentList,
    int oldIndex,
    int newIndex,
  ) {
    // Adjust newIndex for the way ReorderableListView works
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // Get the content being moved
    final movedContent = contentList[oldIndex];

    // Create a new list with reordered items
    final reorderedList = List<ContentModel>.from(contentList);
    reorderedList.removeAt(oldIndex);
    reorderedList.insert(newIndex, movedContent);

    // Update orderIndex for all affected items
    for (int i = 0; i < reorderedList.length; i++) {
      final content = reorderedList[i];
      reorderContent(ref, content.id, i);
    }
  }
}
