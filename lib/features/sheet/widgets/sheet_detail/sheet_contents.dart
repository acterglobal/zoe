import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/events/widgets/event_widget.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/content/text/widgets/text_content_widget.dart';
import 'package:zoey/features/content/list/list_todos/widgets/todos_content_widget.dart';
import 'package:zoey/features/content/list/widgets/list_widget.dart';

/// Contents widget for sheet detail screen
class SheetContents extends ConsumerWidget {
  final String? sheetId;

  const SheetContents({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSheet = ref.watch(sheetProvider(sheetId));
    if (currentSheet.contentList.isEmpty) {
      return const SizedBox.shrink();
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentSheet.contentList.length,
      buildDefaultDragHandles: false,
      onReorder: (oldIndex, newIndex) {
        HapticFeedback.mediumImpact();
        ref
            .read(sheetDetailProvider(sheetId).notifier)
            .reorderContent(oldIndex, newIndex);
      },
      itemBuilder: (context, index) => _buildContentItem(context, ref, index),
    );
  }

  Widget _buildContentItem(BuildContext context, WidgetRef ref, int index) {
    final isEditing = ref.watch(isEditingProvider(sheetId));
    final contentId = ref.watch(sheetProvider(sheetId)).contentList[index];

    return Container(
      key: ValueKey(contentId),
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle - only visible in editing mode
          if (isEditing)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 4),
              child: ReorderableDragStartListener(
                index: index,
                child: GestureDetector(
                  onTapDown: (_) => HapticFeedback.lightImpact(),
                  child: Icon(
                    Icons.drag_indicator_rounded,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 20,
                  ),
                ),
              ),
            ),
          Expanded(child: _buildContentWidget(contentId, isEditing)),
        ],
      ),
    );
  }

  Widget _buildContentWidget(String blockId, bool isEditing) {
    // Determine content type from ID prefix
    if (blockId.startsWith('text-')) {
      return TextContentWidget(textContentId: blockId, isEditing: isEditing);
    } else if (blockId.startsWith('todos-')) {
      return TodosContentWidget(todosContentId: blockId, isEditing: isEditing);
    } else if (blockId.startsWith('events-')) {
      return EventWidget(eventsId: blockId, isEditing: isEditing);
    } else if (blockId.startsWith('list-')) {
      return ListWidget(listId: blockId, isEditing: isEditing);
    } else {
      // Fallback for unknown content types
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('Unknown content type: $blockId'),
      );
    }
  }
}
