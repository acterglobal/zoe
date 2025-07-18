import 'package:flutter/material.dart';
import 'package:zoey/features/sheet/models/content_block/content_block.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/add_block/add_block_option_widget.dart';

/// Add block menu widget
class AddBlockMenu extends StatelessWidget {
  final Function(ContentType type) onAddBlock;

  const AddBlockMenu({super.key, required this.onAddBlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          AddBlockOptionWidget(
            icon: Icons.text_fields,
            title: 'Text',
            description: 'Start writing with plain text',
            onTap: () => onAddBlock(ContentType.text),
          ),
          AddBlockOptionWidget(
            icon: Icons.check_box_outlined,
            title: 'To-do list',
            description: 'Track tasks with checkboxes',
            onTap: () => onAddBlock(ContentType.todo),
          ),
          AddBlockOptionWidget(
            icon: Icons.event_outlined,
            title: 'Event',
            description: 'Schedule and track events',
            onTap: () => onAddBlock(ContentType.event),
          ),
          AddBlockOptionWidget(
            icon: Icons.list,
            title: 'Bulleted list',
            description: 'Create a simple bulleted list',
            onTap: () => onAddBlock(ContentType.bullet),
            isLast: true,
          ),
        ],
      ),
    );
  }
}
