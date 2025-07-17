import 'package:flutter/material.dart';
import 'package:zoey/core/theme/app_theme.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';

/// Title widget for sheet header
class SheetTitleWidget extends StatelessWidget {
  final ZoeSheetModel currentSheet;
  final bool isEditing;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SheetTitleWidget({
    super.key,
    required this.currentSheet,
    required this.isEditing,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isEditing ? _buildTitleTextField(context) : _buildTitleText(context);
  }

  Widget _buildTitleTextField(BuildContext context) {
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
      onChanged: onChanged,
    );
  }

  Widget _buildTitleText(BuildContext context) {
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
