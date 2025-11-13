import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

/// Updates the title of the sheet
void updateSheetTitle(WidgetRef ref, String sheetId, String title) {
  ref.read(sheetListProvider.notifier).updateSheetTitle(sheetId, title);
}

/// Updates the description of the sheet
void updateSheetDescription(
  WidgetRef ref,
  String sheetId,
  Description description,
) {
  // Directly use the plain text and HTML content provided by the widget
  // The ZoeHtmlTextEditWidget already provides correctly formatted content
  ref.read(sheetListProvider.notifier).updateSheetDescription(sheetId, (
    plainText: description.plainText ?? '',
    htmlText: description.htmlText ?? '',
  ));
}

/// Updates the sheet icon, image and emoji
void updateSheetAvatar({
  required WidgetRef ref,
  required String sheetId,
  required AvatarType type,
  required String data,
  Color? color,
}) {
  ref
      .read(sheetListProvider.notifier)
      .updateSheetAvatar(
        sheetId: sheetId,
        type: type,
        data: data,
        color: color,
      );
}
