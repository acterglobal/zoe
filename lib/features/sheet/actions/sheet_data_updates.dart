import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';

/// Updates the title of the sheet
void updateSheetTitle(WidgetRef ref, String sheetId, String title) {
  ref.read(sheetListProvider.notifier).updateSheetTitle(sheetId, title);
}

/// Updates the description of the sheet  
void updateSheetDescription(WidgetRef ref, String sheetId, Description description) {
  String htmlText = description.htmlText ?? '';
  
  if (htmlText.isNotEmpty && (htmlText.startsWith('[') || htmlText.startsWith('{'))) {
      // This is likely JSON from Quill - we need to convert it to plain text
      // For now, we'll parse it with Quill to extract plain text
      final deltaJson = jsonDecode(htmlText);
      final delta = Delta.fromJson(deltaJson);
      final document = Document.fromDelta(delta);
      htmlText = document.toPlainText();
    }

  ref.read(sheetListProvider.notifier).updateSheetDescription(sheetId, (
    plainText: description.plainText ?? '',
    htmlText: htmlText,
  ));
}

/// Updates the emoji of the sheet
void updateSheetEmoji(WidgetRef ref, String sheetId, String emoji) {
  ref
      .read(sheetListProvider.notifier)
      .updateSheetEmoji(sheetId, CommonUtils.getNextEmoji(emoji));
}
