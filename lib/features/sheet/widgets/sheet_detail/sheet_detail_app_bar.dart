import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoey/features/sheet/actions/sheet_actions.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

/// App bar widget for sheet detail screen
class SheetDetailAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? sheetId;

  const SheetDetailAppBar({super.key, required this.sheetId});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider(sheetId));
    return AppBar(
      actions: [
        ZoePrimaryButton(
          text: isEditing ? 'View' : 'Edit',
          icon: isEditing ? Icons.visibility_rounded : Icons.edit_rounded,
          backgroundColor: isEditing
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onPressed: () =>
              ref.read(sheetDetailProvider(sheetId).notifier).toggleEditSave(),
        ),
        _buildMoreMenu(context, ref),
      ],
    );
  }

  Widget _buildMoreMenu(BuildContext context, WidgetRef ref) {
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
