import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/models/sheet_content_model.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/add_content/add_content_option_widget.dart';

/// Add content menu widget
class AddContentMenu extends ConsumerWidget {
  final String? sheetId;

  const AddContentMenu({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          AddContentOptionWidget(
            icon: Icons.text_fields,
            title: 'Text',
            description: 'Start writing with plain text',
            onTap: () => ref
                .read(sheetDetailProvider(sheetId).notifier)
                .addContent(ContentType.text),
          ),
          AddContentOptionWidget(
            icon: Icons.check_box_outlined,
            title: 'To-do list',
            description: 'Track tasks with checkboxes',
            onTap: () => ref
                .read(sheetDetailProvider(sheetId).notifier)
                .addContent(ContentType.todo),
          ),
          AddContentOptionWidget(
            icon: Icons.event_outlined,
            title: 'Event',
            description: 'Schedule and track events',
            onTap: () => ref
                .read(sheetDetailProvider(sheetId).notifier)
                .addContent(ContentType.event),
          ),
          AddContentOptionWidget(
            icon: Icons.list,
            title: 'Bulleted list',
            description: 'Create a simple bulleted list',
            onTap: () => ref
                .read(sheetDetailProvider(sheetId).notifier)
                .addContent(ContentType.bullet),
            isLast: true,
          ),
        ],
      ),
    );
  }
}
