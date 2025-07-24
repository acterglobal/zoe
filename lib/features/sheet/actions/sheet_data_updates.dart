import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';

/// Updates the title of the sheet
void updateSheetTitle(WidgetRef ref, String sheetId, String title) {
  ref.read(sheetListProvider.notifier).updateSheetTitle(sheetId, title);
}

/// Updates the description of the sheet  
void updateSheetDescription(WidgetRef ref, String sheetId, Description description) {
  // Directly use the plain text and HTML content provided by the widget
  // The ZoeHtmlTextEditWidget already provides correctly formatted content
  ref.read(sheetListProvider.notifier).updateSheetDescription(sheetId, (
    plainText: description.plainText ?? '',
    htmlText: description.htmlText ?? '',
  ));
}

/// Updates the emoji of the sheet
void updateSheetEmoji(WidgetRef ref, String sheetId, String emoji) {
  ref
      .read(sheetListProvider.notifier)
      .updateSheetEmoji(sheetId, CommonUtils.getNextEmoji(emoji));
}
