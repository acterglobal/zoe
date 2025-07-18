import 'package:flutter/material.dart';
import 'package:zoey/features/sheet/models/content_block.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/add_block/add_block_menu.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/add_block/add_block_trigger.dart';

/// Add block widget for sheet detail screen
class SheetAddBlock extends StatelessWidget {
  final bool isEditing;
  final bool showAddMenu;
  final VoidCallback onTriggerTap;
  final Function(ContentType type) onAddBlock;

  const SheetAddBlock({
    super.key,
    required this.isEditing,
    required this.showAddMenu,
    required this.onTriggerTap,
    required this.onAddBlock,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEditing) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddBlockTrigger(showAddMenu: showAddMenu, onTap: onTriggerTap),
        if (showAddMenu) AddBlockMenu(onAddBlock: onAddBlock),
      ],
    );
  }
}
