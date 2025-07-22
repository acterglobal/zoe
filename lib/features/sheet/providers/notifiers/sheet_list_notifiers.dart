import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/data/sheet_data.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class SheetListNotifier extends StateNotifier<List<SheetModel>> {
  SheetListNotifier() : super(sheetLists);

  void addSheet(SheetModel sheet) {
    state = [...state, sheet];
  }

  void updateSheet(SheetModel sheet) {
    state = state.map((s) => s.id == sheet.id ? sheet : s).toList();
  }

  void deleteSheet(String sheetId) {
    state = state.where((s) => s.id != sheetId).toList();
  }

  SheetModel? getSheetById(String sheetId) {
    return state.firstWhere((s) => s.id == sheetId);
  }

  void updateSheetTitle(String sheetId, String title) {
    state = state
        .map((s) => s.id == sheetId ? s.copyWith(title: title) : s)
        .toList();
  }

  void updateSheetDescription(String sheetId, String description) {
    state = state
        .map((s) => s.id == sheetId ? s.copyWith(description: description) : s)
        .toList();
  }

  void updateSheetEmoji(String sheetId, String emoji) {
    state = state
        .map((s) => s.id == sheetId ? s.copyWith(emoji: emoji) : s)
        .toList();
  }
}
