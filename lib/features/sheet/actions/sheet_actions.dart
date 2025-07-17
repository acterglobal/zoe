import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_actions_provider.dart';

/// Shows a dialog to delete or discard a sheet
void showDeleteSheetDialog(
  BuildContext context,
  WidgetRef ref, {
  required String? sheetId,
  required bool hasBeenSaved,
}) {
  final sheetActions = ref.read(sheetActionsNotifierProvider);
  sheetActions.deleteSheet(
    context: context,
    sheetId: sheetId,
    hasBeenSaved: hasBeenSaved,
  );
}

/// Duplicates a sheet and shows a success message
void duplicateSheet(
  BuildContext context,
  WidgetRef ref, {
  required ZoeSheetModel currentSheet,
}) {
  final sheetActions = ref.read(sheetActionsNotifierProvider);
  sheetActions.duplicateSheet(context: context, currentSheet: currentSheet);
}

/// Creates a new sheet
void createNewSheet(
  BuildContext context,
  WidgetRef ref, {
  String? title,
  String? description,
  String? emoji,
}) {
  final sheetActions = ref.read(sheetActionsNotifierProvider);
  sheetActions.createNewSheet(
    context: context,
    title: title,
    description: description,
    emoji: emoji,
  );
}

/// Cycles through available emojis for a sheet
String getNextEmoji(String? currentEmoji) {
  const emojis = [
    '📄',
    '📝',
    '📋',
    '📊',
    '📈',
    '🎯',
    '💡',
    '🚀',
    '⭐',
    '🎉',
    '📚',
    '💼',
    '🏠',
    '🎨',
    '🔬',
  ];
  final currentIndex = emojis.indexOf(currentEmoji ?? '📄');
  final nextIndex = (currentIndex + 1) % emojis.length;
  return emojis[nextIndex];
}
