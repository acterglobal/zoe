import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/providers/common_providers.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_notifiers.dart';

final sheetListProvider =
    StateNotifierProvider<SheetNotifier, List<SheetModel>>(
      (ref) => SheetNotifier(),
    );

final sheetListSearchProvider = Provider<List<SheetModel>>((ref) {
  final sheetList = ref.watch(sheetListProvider);
  final searchValue = ref.watch(searchValueProvider);
  if (searchValue.isEmpty) return sheetList;
  return sheetList
      .where((s) => s.title.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
});

final sheetProvider = Provider.family<SheetModel?, String>((ref, sheetId) {
  final sheetList = ref.watch(sheetListProvider);
  return sheetList.where((s) => s.id == sheetId).firstOrNull;
});

final listOfUsersBySheetIdProvider = Provider.family<List<String>, String>((
  ref,
  sheetId,
) {
  final sheetList = ref.watch(sheetListProvider);
  return sheetList.where((s) => s.id == sheetId).firstOrNull?.users ?? [];
});
