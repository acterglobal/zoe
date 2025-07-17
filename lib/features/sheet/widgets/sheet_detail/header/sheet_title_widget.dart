import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/core/theme/app_theme.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

/// Title widget for sheet header
class SheetTitleWidget extends ConsumerWidget {
  final String sheetId;

  const SheetTitleWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSheet = ref.watch(sheetProvider(sheetId));
    final isEditing = ref.watch(isEditingProvider(sheetId));
    return isEditing
        ? _buildTitleTextField(context, ref)
        : _buildTitleText(context, currentSheet);
  }

  Widget _buildTitleTextField(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(titleControllerProvider(sheetId));

    return TextField(
      controller: controller,
      style: _getTitleTextStyle(context),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        hintText: 'Untitled',
        hintStyle: TextStyle(
          color: AppTheme.getTextSecondary(context),
          fontWeight: FontWeight.bold,
        ),
        contentPadding: const EdgeInsets.all(8.0),
      ),
      maxLines: null,
      onChanged: (value) =>
          ref.read(sheetDetailProvider(sheetId).notifier).updateTitle(value),
    );
  }

  Widget _buildTitleText(BuildContext context, ZoeSheetModel currentSheet) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        currentSheet.title.isEmpty ? 'Untitled' : currentSheet.title,
        style: _getTitleTextStyle(context),
      ),
    );
  }

  TextStyle _getTitleTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
      height: 1.2,
    );
  }
}
