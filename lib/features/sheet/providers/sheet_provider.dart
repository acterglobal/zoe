import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_list_providers.dart';

final sheetProvider = Provider.family<SheetModel, String>((ref, sheetId) {
  return ref.watch(sheetListProvider).firstWhere((s) => s.id == sheetId);
});
