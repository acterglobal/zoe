import 'package:flutter/material.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/sheet/models/content_block/content_block.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/blocks/content_block_widget.dart';

/// Content blocks widget for sheet detail screen
class SheetContentBlocks extends StatelessWidget {
  final ZoeSheetModel currentSheet;
  final bool isEditing;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(String blockId, ContentBlockModel updatedBlock) onUpdate;
  final Function(String blockId) onDelete;

  const SheetContentBlocks({
    super.key,
    required this.currentSheet,
    required this.isEditing,
    required this.onReorder,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (currentSheet.contentBlocks.isEmpty) {
      return const SizedBox.shrink();
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentSheet.contentBlocks.length,
      buildDefaultDragHandles: false,
      onReorder: onReorder,
      itemBuilder: _buildContentBlockItem,
    );
  }

  Widget _buildContentBlockItem(BuildContext context, int index) {
    final block = currentSheet.contentBlocks[index];
    return Padding(
      key: ValueKey(block.id),
      padding: const EdgeInsets.only(bottom: 24),
      child: ContentBlockWidget(
        block: block,
        blockIndex: index,
        isEditing: isEditing,
        onUpdate: (updatedBlock) => onUpdate(block.id, updatedBlock),
        onDelete: () => onDelete(block.id),
      ),
    );
  }
}
