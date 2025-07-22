import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';

/// Updates the title of the sheet
void updateSheetTitle(WidgetRef ref, String sheetId, String title) {
  ref.read(sheetListProvider.notifier).updateSheetTitle(sheetId, title);
}

/// Updates the description of the sheet
void updateSheetDescription(WidgetRef ref, String sheetId, String description) {
  ref.read(sheetListProvider.notifier).updateSheetDescription(sheetId, (
    plainText: description,
    htmlText: null,
  ));
}

/// Updates the emoji of the sheet
void updateSheetEmoji(WidgetRef ref, String sheetId, String emoji) {
  ref
      .read(sheetListProvider.notifier)
      .updateSheetEmoji(sheetId, CommonUtils.getNextEmoji(emoji));
}
