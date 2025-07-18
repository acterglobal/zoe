import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/actions/sheet_actions.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

/// More menu widget for sheet detail app bar
class SheetMoreMenuWidget extends ConsumerWidget {
  final String? sheetId;

  const SheetMoreMenuWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onSelected: (value) {
        final currentSheet = ref.watch(sheetProvider(sheetId));
        switch (value) {
          case 'Duplicate':
            duplicateSheet(context, ref, currentSheet: currentSheet);
            break;
          case 'Delete':
            showDeleteSheetDialog(context, ref, sheetId: sheetId);
            break;
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem(
          Icons.copy_rounded,
          'Duplicate',
          Theme.of(context).colorScheme.onSurface,
        ),
        _buildMenuItem(
          Icons.delete_rounded,
          'Delete',
          Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem(
      value: text,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
