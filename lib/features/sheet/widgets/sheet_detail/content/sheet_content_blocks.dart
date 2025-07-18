import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/text/widgets/text_content_widget.dart';
import 'package:zoey/features/todos/widgets/todos_content_widget.dart';
import 'package:zoey/features/events/widgets/events_content_widget.dart';
import 'package:zoey/features/bullet-lists/widgets/bullets_content_widget.dart';

/// Content blocks widget for sheet detail screen
class SheetContentBlocks extends ConsumerWidget {
  final String sheetId;
  final bool isEditing;

  const SheetContentBlocks({
    super.key,
    required this.sheetId,
    required this.isEditing,
  });

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
      onReorder: (oldIndex, newIndex) => ref
          .read(sheetDetailProvider(sheetId).notifier)
          .reorderContent(oldIndex, newIndex),
      itemBuilder: (context, index) => _buildContentItem(context, ref, index),
    );
  }

  Widget _buildContentItem(BuildContext context, WidgetRef ref, int index) {
    final contentId = ref.watch(sheetProvider(sheetId)).contentList[index];

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
