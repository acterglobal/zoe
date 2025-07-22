import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_list_providers.dart';

final sheetProvider = Provider.family<SheetModel?, String>((ref, sheetId) {
  final sheetList = ref.watch(sheetListProvider);
  try {
    return sheetList.firstWhere((s) => s.id == sheetId);
  } catch (e) {
    return null;
  }
});

final deleteSheetProvider = Provider<void Function(String)>((ref) {
  return (String sheetId) {
    ref.read(sheetListProvider.notifier).deleteSheet(sheetId);
  };
});
