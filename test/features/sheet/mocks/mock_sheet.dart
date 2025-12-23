import 'package:flutter/material.dart';
import 'package:zoe/features/sheet/data/sheet_data.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

class MockSheetList extends SheetList {
  @override
  List<SheetModel> build() => sheetList;

  @override
  Future<void> addSheet(SheetModel sheet) async {
    state = [...state, sheet];
  }

  // Helper method for tests to update state directly
  void updateSheet(SheetModel sheet) {
    state = [
      for (final s in state)
        if (s.id == sheet.id) sheet else s,
    ];
  }

  @override
  Future<void> updateSheetTheme({
    required String sheetId,
    required Color primary,
    required Color secondary,
  }) async {
    state = [
      for (final s in state)
        if (s.id == sheetId)
          s.copyWith(
            theme: SheetTheme(primary: primary, secondary: secondary),
          )
        else
          s,
    ];
  }

  @override
  Future<void> updateSheetShareInfo({
    required String sheetId,
    String? sharedBy,
    String? message,
  }) async {
    state = [
      for (final s in state)
        if (s.id == sheetId)
          s.copyWith(sharedBy: sharedBy, message: message)
        else
          s,
    ];
  }
}
