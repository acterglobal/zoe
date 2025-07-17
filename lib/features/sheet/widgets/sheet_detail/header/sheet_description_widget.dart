import 'package:flutter/material.dart';
import 'package:zoey/core/theme/app_theme.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';

/// Description widget for sheet header
class SheetDescriptionWidget extends StatelessWidget {
  final ZoeSheetModel currentSheet;
  final bool isEditing;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SheetDescriptionWidget({
    super.key,
    required this.currentSheet,
    required this.isEditing,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? _buildDescriptionTextField(context)
        : _buildDescriptionText(context);
  }

  Widget _buildDescriptionTextField(BuildContext context) {
    return TextField(
      controller: controller,
      style: _getDescriptionTextStyle(context),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        hintText: 'Add a description...',
        hintStyle: TextStyle(
          color: AppTheme.getTextSecondary(context).withValues(alpha: 0.6),
        ),
        contentPadding: const EdgeInsets.all(8.0),
      ),
      maxLines: null,
      onChanged: onChanged,
    );
  }

  Widget _buildDescriptionText(BuildContext context) {
    if (currentSheet.description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        currentSheet.description,
        style: _getDescriptionTextStyle(context),
      ),
    );
  }

  TextStyle _getDescriptionTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: AppTheme.getTextSecondary(context),
      height: 1.5,
    );
  }
}
