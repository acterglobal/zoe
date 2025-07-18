import 'package:flutter/material.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/text/widgets/text_content_widget.dart';
import 'package:zoey/features/todos/widgets/todos_content_widget.dart';
import 'package:zoey/features/events/widgets/events_content_widget.dart';
import 'package:zoey/features/bullet-lists/widgets/bullets_content_widget.dart';

/// Content blocks widget for sheet detail screen
class SheetContentBlocks extends StatelessWidget {
  final ZoeSheetModel currentSheet;
  final bool isEditing;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(String contentId) onDelete;

  const SheetContentBlocks({
    super.key,
    required this.currentSheet,
    required this.isEditing,
    required this.onReorder,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (currentSheet.contentList.isEmpty) {
      return const SizedBox.shrink();
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentSheet.contentList.length,
      buildDefaultDragHandles: false,
      onReorder: onReorder,
      itemBuilder: _buildContentItem,
    );
  }

  Widget _buildContentItem(BuildContext context, int index) {
    final contentId = currentSheet.contentList[index];

    return Padding(
      key: ValueKey(contentId),
      padding: const EdgeInsets.only(bottom: 24),
      child: _buildContentWidget(contentId),
    );
  }

  Widget _buildContentWidget(String contentId) {
    // Determine content type from ID prefix
    if (contentId.startsWith('text-')) {
      return TextContentWidget(textContentId: contentId, isEditing: isEditing);
    } else if (contentId.startsWith('todos-')) {
      return TodosContentWidget(
        todosContentId: contentId,
        isEditing: isEditing,
      );
    } else if (contentId.startsWith('events-')) {
      return EventsContentWidget(
        eventsContentId: contentId,
        isEditing: isEditing,
      );
    } else if (contentId.startsWith('bullets-')) {
      return BulletsContentWidget(
        bulletsContentId: contentId,
        isEditing: isEditing,
      );
    } else {
      // Fallback for unknown content types
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('Unknown content type: $contentId'),
      );
    }
  }
}
