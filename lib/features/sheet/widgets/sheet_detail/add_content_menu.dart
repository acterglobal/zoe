import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/models/sheet_content_model.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

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
          _buildAddContentOption(
            context,
            ref,
            icon: Icons.text_fields,
            title: 'Text',
            description: 'Start writing with plain text',
            onTap: () => ref
                .read(sheetDetailProvider(sheetId).notifier)
                .addContent(ContentType.text),
          ),
          _buildAddContentOption(
            context,
            ref,
            icon: Icons.check_box_outlined,
            title: 'To-do list',
            description: 'Track tasks with checkboxes',
            onTap: () => ref
                .read(sheetDetailProvider(sheetId).notifier)
                .addContent(ContentType.todo),
          ),
          _buildAddContentOption(
            context,
            ref,
            icon: Icons.event_outlined,
            title: 'Event',
            description: 'Schedule and track events',
            onTap: () => ref
                .read(sheetDetailProvider(sheetId).notifier)
                .addContent(ContentType.event),
          ),
          _buildAddContentOption(
            context,
            ref,
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

  Widget _buildAddContentOption(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
