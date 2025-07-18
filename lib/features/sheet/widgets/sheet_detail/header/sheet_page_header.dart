import 'package:flutter/material.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/header/sheet_emoji_widget.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/header/sheet_title_widget.dart';
import 'package:zoey/features/sheet/widgets/sheet_detail/header/sheet_description_widget.dart';

/// Page header widget for sheet detail screen
class SheetPageHeader extends StatelessWidget {
  final String? sheetId;

  const SheetPageHeader({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmojiAndTitleRow(context),
        const SizedBox(height: 16),
        SheetDescriptionWidget(sheetId: sheetId),
      ],
    );
  }

  Widget _buildEmojiAndTitleRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SheetEmojiWidget(sheetId: sheetId),
        const SizedBox(width: 4),
        Expanded(child: SheetTitleWidget(sheetId: sheetId)),
      ],
    );
  }
}
