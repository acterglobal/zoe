import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

SheetModel getSheetByIndex(ProviderContainer container, {int index = 0}) {
  final sheetList = container.read(sheetListProvider);
  if (sheetList.isEmpty) fail('Sheet list is empty');
  if (index < 0 || index >= sheetList.length) {
    fail('Sheet index is out of bounds');
  }
  return sheetList[index];
}
