import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/core/theme/app_theme.dart';
import 'package:zoey/features/sheet/actions/sheet_actions.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

/// More menu widget for sheet detail app bar
class SheetMoreMenuWidget extends ConsumerWidget {
  final String sheetId;

  const SheetMoreMenuWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onSelected: (value) => _handleMenuSelection(context, ref, value),
      itemBuilder: (context) => [
        _buildMenuItem(
          context,
          'duplicate',
          Icons.copy_rounded,
          'Duplicate',
          AppTheme.getTextSecondary(context),
        ),
        _buildMenuItem(
          context,
          'delete',
          Icons.delete_rounded,
          'Delete',
          const Color(0xFFEF4444),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    BuildContext context,
    String value,
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, WidgetRef ref, String value) {
    final currentSheet = ref.watch(sheetProvider(sheetId));
    switch (value) {
      case 'delete':
        showDeleteSheetDialog(context, ref, sheetId: sheetId);
        break;
      case 'duplicate':
        duplicateSheet(context, ref, currentSheet: currentSheet);
        break;
    }
  }
}
