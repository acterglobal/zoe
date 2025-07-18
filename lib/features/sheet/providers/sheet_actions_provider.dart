import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoey/core/routing/app_routes.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_list_provider.dart';

/// Actions provider for sheet operations
class SheetActionsNotifier extends StateNotifier<void> {
  final Ref ref;

  SheetActionsNotifier(this.ref) : super(null);

  /// Delete or discard a sheet
  Future<void> deleteSheet({
    required BuildContext context,
    required String? sheetId,
  }) async {
    final result = await showDialog<bool>(
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
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              sheetId == null || sheetId == 'new' ? 'Discard' : 'Delete',
              style: const TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      if (sheetId != null && sheetId != 'new') {
        // Delete existing sheet
        final sheetListNotifier = ref.read(sheetListProvider.notifier);
        sheetListNotifier.deleteSheet(sheetId);
      }

      // Navigate back to home
      if (context.mounted) {
        context.go(AppRoutes.home.route);
      }
    }
  }

  /// Duplicate a sheet
  void duplicateSheet({
    required BuildContext context,
    required ZoeSheetModel currentSheet,
  }) {
    final duplicatedSheet = ZoeSheetModel(
      title: '${currentSheet.title} (Copy)',
      description: currentSheet.description,
      emoji: currentSheet.emoji,
      contentList: currentSheet.contentList,
    );

    final sheetListNotifier = ref.read(sheetListProvider.notifier);
    sheetListNotifier.addSheet(duplicatedSheet);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Page duplicated successfully')),
    );
  }

  /// Create a new sheet
  void createNewSheet({
    required BuildContext context,
    String? title,
    String? description,
    String? emoji,
  }) {
    final newSheet = ZoeSheetModel(
      title: title ?? 'Untitled',
      description: description ?? '',
      emoji: emoji ?? '📄',
    );

    final sheetListNotifier = ref.read(sheetListProvider.notifier);
    sheetListNotifier.addSheet(newSheet);

    // Navigate to the new sheet
    context.push(AppRoutes.sheet.route.replaceAll(':sheetId', newSheet.id));
  }

  /// Save a sheet (used by sheet detail provider)
  void saveSheet({required ZoeSheetModel sheet, required String? sheetId}) {
    final sheetListNotifier = ref.read(sheetListProvider.notifier);

    if (sheetId != null && sheetId != 'new') {
      sheetListNotifier.updateSheet(sheet);
    } else {
      sheetListNotifier.addSheet(sheet);
    }
  }

  /// Get a sheet by ID
  ZoeSheetModel? getSheetById(String sheetId) {
    final sheetListNotifier = ref.read(sheetListProvider.notifier);
    return sheetListNotifier.getSheetById(sheetId);
  }

  /// Clear all sheets
  void clearAllSheets() {
    final sheetListNotifier = ref.read(sheetListProvider.notifier);
    sheetListNotifier.clearSheets();
  }

  /// Initialize with sample data
  void initializeWithSampleData() {
    final sheetListNotifier = ref.read(sheetListProvider.notifier);
    sheetListNotifier.initializeWithSampleData();
  }
}

/// Provider for sheet actions
final sheetActionsProvider = StateNotifierProvider<SheetActionsNotifier, void>((
  ref,
) {
  return SheetActionsNotifier(ref);
});

/// Convenience provider for sheet actions
final sheetActionsNotifierProvider = Provider<SheetActionsNotifier>((ref) {
  return ref.read(sheetActionsProvider.notifier);
});
