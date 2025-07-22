import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/sheet/providers/notifiers/sheet_list_notifiers.dart';

final sheetListProvider =
    StateNotifierProvider<SheetListNotifier, List<SheetModel>>((ref) {
      return SheetListNotifier();
    });
