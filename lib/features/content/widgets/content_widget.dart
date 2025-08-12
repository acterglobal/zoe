import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/bullets/widgets/bullet_item_widget.dart';
import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/content/providers/content_providers.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/content/utils/content_utils.dart';
import 'package:zoey/features/content/widgets/add_content_widget.dart';
import 'package:zoey/features/documents/widgets/document_widget.dart';
import 'package:zoey/features/events/widgets/event_widget.dart';
import 'package:zoey/features/link/widgets/link_widget.dart';
import 'package:zoey/features/list/widgets/list_widget.dart';
import 'package:zoey/features/task/widgets/task_item_widget.dart';
import 'package:zoey/features/text/widgets/text_widget.dart';

class ContentWidget extends ConsumerWidget {
  final String parentId;
  final String sheetId;

  const ContentWidget({
    super.key,
    required this.parentId,
    required this.sheetId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Watch the content list provider
    final contentList = ref.watch(contentListByParentIdProvider(parentId));
    final isEditing = ref.watch(isEditValueProvider(parentId));

    /// Build the content list
    return Column(
      children: [
        // Use ReorderableListView when editing, regular ListView when not
        isEditing
            ? ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: contentList.length,
                buildDefaultDragHandles:
                    false, // This removes the default trailing drag handles
                onReorder: (oldIndex, newIndex) {
                  _handleReorder(ref, contentList, oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final content = contentList[index];
                  final contentId = content.id;

                  return _buildContentItem(
                    context,
                    content,
                    contentId,
                    isEditing,
                    index,
                  );
                },
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: contentList.length,
                itemBuilder: (context, index) {
                  final content = contentList[index];
                  final contentId = content.id;

                  return _buildContentItem(
                    context,
                    content,
                    contentId,
                    isEditing,
                    index,
                  );
                },
              ),
        AddContentWidget(
          isEditing: isEditing,
          onTapText: () => addNewTextContent(ref, parentId, sheetId),
          onTapEvent: () => addNewEventListContent(ref, parentId, sheetId),
          onTapBulletedList: () =>
              addNewBulletedListContent(ref, parentId, sheetId),
          onTapToDoList: () => addNewTaskListContent(ref, parentId, sheetId),
          onTapLink: () => addNewLinkContent(ref, parentId, sheetId),
          onTapDocument: () => addNewDocumentContent(ref, parentId, sheetId),
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
      ),
      ContentType.list => ListWidget(listId: contentId, isEditing: isEditing),
      ContentType.task => TaskWidget(taskId: contentId, isEditing: isEditing),
      ContentType.bullet => BulletItemWidget(
        bulletId: contentId,
        isEditing: isEditing,
      ),
      ContentType.link => LinkWidget(linkId: contentId, isEditing: isEditing),
      ContentType.document => DocumentWidget(
        documentId: contentId,
        isEditing: isEditing,
      ),
    };

    // For ReorderableListView, we need to wrap with drag handle when editing
    if (isEditing) {
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
