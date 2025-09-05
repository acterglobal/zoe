import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'mock_data.dart';

/// Mock providers for Widgetbook testing
class MockProviders {
  static final mockSheetListProvider =
      StateNotifierProvider<MockSheetNotifier, List<SheetModel>>(
    (ref) => MockSheetNotifier(),
  );

  static final mockSheetProvider =
      Provider.family<SheetModel?, String>((ref, sheetId) {
    final sheetList = ref.watch(mockSheetListProvider);
    return sheetList.where((s) => s.id == sheetId).firstOrNull;
  });

  static final mockIsEditingProvider =
      StateProvider.family<bool, String>((ref, id) => true);
}

class MockSheetNotifier extends StateNotifier<List<SheetModel>> {
  // ✅ Start with mock data immediately
  MockSheetNotifier() : super(MockData.sheets);

  void addSheet(SheetModel sheet) {
    state = [...state, sheet];
  }

  void updateSheetTitle(String sheetId, String title) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId) sheet.copyWith(title: title) else sheet,
    ];
  }

  void updateSheetEmoji(String sheetId, String emoji) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId) sheet.copyWith(emoji: emoji) else sheet,
    ];
  }

  void updateSheetDescription(String sheetId, Description description) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId)
          sheet.copyWith(description: description)
        else
          sheet,
    ];
  }
}
