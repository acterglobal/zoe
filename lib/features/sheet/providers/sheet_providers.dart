import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_notifiers.dart';

final sheetListProvider =
    StateNotifierProvider<SheetNotifier, List<SheetModel>>(
      (ref) => SheetNotifier(),
    );

final sheetProvider = Provider.family<SheetModel?, String>((ref, sheetId) {
  final sheetList = ref.watch(sheetListProvider);
  return sheetList.where((s) => s.id == sheetId).firstOrNull;
});
