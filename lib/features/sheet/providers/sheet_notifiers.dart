import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/data/sheet_data.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class SheetNotifier extends StateNotifier<List<SheetModel>> {
  SheetNotifier() : super(sheetList);

  void addSheet(SheetModel sheet) {
    state = [...state, sheet];
  }

  void deleteSheet(String sheetId) {
    state = state.where((s) => s.id != sheetId).toList();
  }

  void updateSheetTitle(String sheetId, String title) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId) sheet.copyWith(title: title) else sheet,
    ];
  }

  void updateSheetDescription(String sheetId, String description) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId)
          sheet.copyWith(description: description)
        else
          sheet,
    ];
  }

  void updateSheetEmoji(String sheetId, String emoji) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId) sheet.copyWith(emoji: emoji) else sheet,
    ];
  }
}
