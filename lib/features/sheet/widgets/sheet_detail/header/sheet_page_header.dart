import 'package:flutter/material.dart';
import 'package:zoey/features/sheet/models/zoe_sheet_model.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/header/sheet_emoji_widget.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/header/sheet_title_widget.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/header/sheet_description_widget.dart';

/// Page header widget for sheet detail screen
class SheetPageHeader extends StatelessWidget {
  final ZoeSheetModel currentSheet;
  final bool isEditing;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final ValueChanged<String> onDescriptionChanged;

  const SheetPageHeader({
    super.key,
    required this.currentSheet,
    required this.isEditing,
    required this.titleController,
    required this.descriptionController,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmojiAndTitleRow(context),
        const SizedBox(height: 16),
        SheetDescriptionWidget(
          currentSheet: currentSheet,
          isEditing: isEditing,
          controller: descriptionController,
          onChanged: onDescriptionChanged,
        ),
      ],
    );
  }

  Widget _buildEmojiAndTitleRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SheetEmojiWidget(sheetId: currentSheet.id),
        const SizedBox(width: 4),
        Expanded(child: SheetTitleWidget(sheetId: currentSheet.id)),
      ],
    );
  }
}
