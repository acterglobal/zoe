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
}
