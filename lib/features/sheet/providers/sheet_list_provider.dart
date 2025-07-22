import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/data/sheet_data.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class SheetListNotifier extends StateNotifier<List<SheetModel>> {
  SheetListNotifier() : super([]);

  // Initialize with sample data
  void initializeWithSampleData() {
    state = [gettingStartedSheet];
  }

  // Sheet management
  void addSheet(SheetModel sheet) {
    state = [...state, sheet];
  }

  void updateSheet(SheetModel updatedSheet) {
    state = state.map((sheet) {
      return sheet.id == updatedSheet.id ? updatedSheet : sheet;
    }).toList();
  }

  void deleteSheet(String sheetId) {
    state = state.where((sheet) => sheet.id != sheetId).toList();
  }

  SheetModel? getSheetById(String sheetId) {
    try {
      return state.firstWhere((sheet) => sheet.id == sheetId);
    } catch (e) {
      return null;
    }
  }

  // Clear all sheets
  void clearSheets() {
    state = [];
  }
}

// Main Riverpod provider for sheet list
final sheetListProvider =
    StateNotifierProvider<SheetListNotifier, List<SheetModel>>((ref) {
      return SheetListNotifier();
    });
