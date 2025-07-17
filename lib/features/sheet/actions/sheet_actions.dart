import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_list_provider.dart';

/// Shows a dialog to delete or discard a sheet
void showDeleteSheetDialog(
  BuildContext context,
  WidgetRef ref, {
  required String? sheetId,
  required bool hasBeenSaved,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        sheetId == null || sheetId == 'new' ? 'Discard Page' : 'Delete Page',
      ),
      content: Text(
        sheetId == null || sheetId == 'new'
            ? 'Are you sure you want to discard this page? Any unsaved changes will be lost.'
            : 'Are you sure you want to delete this page? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (sheetId != null && sheetId != 'new' && hasBeenSaved) {
              // Delete existing page
              final sheetListNotifier = ref.read(sheetListProvider.notifier);
              sheetListNotifier.deleteSheet(sheetId);
            }
            // For both new and existing pages, close dialog and page
            Navigator.of(context).pop(); // Close dialog

            // Navigate back to home
            context.go(AppRoutes.home.route);
          },
          child: Text(
            sheetId == null || sheetId == 'new' ? 'Discard' : 'Delete',
            style: const TextStyle(color: Color(0xFFEF4444)),
          ),
        ),
      ],
    ),
  );
}

/// Duplicates a sheet and shows a success message
void duplicateSheet(
  BuildContext context,
  WidgetRef ref, {
  required ZoeSheetModel currentSheet,
}) {
  final duplicatedPage = ZoeSheetModel(
    title: '${currentSheet.title} (Copy)',
    description: currentSheet.description,
    emoji: currentSheet.emoji,
    contentBlocks: currentSheet.contentBlocks,
  );

  final sheetListNotifier = ref.read(sheetListProvider.notifier);
  sheetListNotifier.addSheet(duplicatedPage);

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('Page duplicated successfully')));
}

/// Cycles through available emojis for a sheet
String getNextEmoji(String? currentEmoji) {
  const emojis = [
    '📄',
    '📝',
    '📋',
    '📊',
    '📈',
    '🎯',
    '💡',
    '🚀',
    '⭐',
    '🎉',
    '📚',
    '💼',
    '🏠',
    '🎨',
    '🔬',
  ];
  final currentIndex = emojis.indexOf(currentEmoji ?? '📄');
  final nextIndex = (currentIndex + 1) % emojis.length;
  return emojis[nextIndex];
}
