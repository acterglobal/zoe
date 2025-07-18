import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/sheet/providers/sheet_detail_provider.dart';

/// Title widget for sheet header
class SheetTitleWidget extends ConsumerWidget {
  final String? sheetId;

  const SheetTitleWidget({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider(sheetId));
    return isEditing
        ? _buildSheetTitleTextField(context, ref)
        : _buildSheetTitleText(context, ref);
  }

  Widget _buildSheetTitleTextField(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(titleControllerProvider(sheetId));

    return TextField(
      controller: controller,
      style: _getSheetTitleTextStyle(context),
      decoration: InputDecoration(hintText: 'Untitled'),
      maxLines: null,
      onChanged: (value) =>
          ref.read(sheetDetailProvider(sheetId).notifier).updateTitle(value),
    );
  }

  Widget _buildSheetTitleText(BuildContext context, WidgetRef ref) {
    final currentSheet = ref.watch(sheetProvider(sheetId));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        currentSheet.title.isEmpty ? 'Untitled' : currentSheet.title,
        style: _getSheetTitleTextStyle(context),
      ),
    );
  }

  TextStyle _getSheetTitleTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
      height: 1.2,
    );
  }
}
