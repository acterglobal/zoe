import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_notifiers.dart';

class MockSheetNotifier extends SheetNotifier {
  MockSheetNotifier(this.ref);

  final Ref ref;

  void setSheets(List<SheetModel> sheets) {
    state = sheets;
  }

  @override
  void addSheet(SheetModel sheet) {
    state = [...state, sheet];
  }

  @override
  void deleteSheet(String sheetId) {
    state = state.where((s) => s.id != sheetId).toList();
  }

  @override
  void updateSheetTitle(String sheetId, String title) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId) sheet.copyWith(title: title) else sheet,
    ];
  }

  @override
  void updateSheetDescription(String sheetId, Description description) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId)
          sheet.copyWith(description: description)
        else
          sheet,
    ];
  }

  @override
  void updateSheetEmoji(String sheetId, String emoji) {
    state = [
      for (final sheet in state)
        if (sheet.id == sheetId) sheet.copyWith(emoji: emoji) else sheet,
    ];
  }
}

final mockSheetListProvider = StateNotifierProvider<SheetNotifier, List<SheetModel>>(
  (ref) => MockSheetNotifier(ref),
);

final mockSheetProvider = Provider.family<SheetModel?, String>((ref, sheetId) {
  final sheetList = ref.watch(mockSheetListProvider);
  return sheetList.where((s) => s.id == sheetId).firstOrNull;
}, dependencies: [mockSheetListProvider]);

final mockSheetListSearchProvider = Provider<List<SheetModel>>((ref) {
  final sheetList = ref.watch(mockSheetListProvider);
  final searchValue = ref.watch(searchValueProvider);
  if (searchValue.isEmpty) return sheetList;
  return sheetList
      .where((s) => s.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
}, dependencies: [mockSheetListProvider, searchValueProvider]);

final mockListOfUsersBySheetIdProvider = Provider.family<List<String>, String>((
  ref,
  sheetId,
) {
  final sheetList = ref.watch(mockSheetListProvider);
  return sheetList.where((s) => s.id == sheetId).firstOrNull?.users ?? [];
}, dependencies: [mockSheetListProvider]);
