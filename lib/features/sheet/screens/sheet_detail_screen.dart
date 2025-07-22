import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/common/widgets/edit_view_toggle_button.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/content/widgets/content_widget.dart';
import 'package:zoey/features/sheet/actions/delete_sheet.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';

class SheetDetailScreen extends ConsumerWidget {
  final String sheetId;

  const SheetDetailScreen({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [EditViewToggleButton(), _buildDeleteButton(context, ref)],
      ),
      body: _buildBody(context, ref),
    );
  }

  Widget _buildDeleteButton(BuildContext context, WidgetRef ref) {
    return ZoeDeleteButtonWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      size: 24,
      onTap: () => showDeleteSheetConfirmation(context, ref, sheetId),
    );
  }

  /// Builds the main body
  Widget _buildBody(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSheetHeader(context, ref),
          const SizedBox(height: 16),
          ContentWidget(parentId: sheetId, sheetId: sheetId),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildSheetHeader(BuildContext context, WidgetRef ref) {
    final sheet = ref.watch(sheetListProvider.notifier).getSheetById(sheetId);
    if (sheet == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => ref
                  .read(sheetListProvider.notifier)
                  .updateSheetEmoji(
                    sheetId,
                    CommonUtils.getNextEmoji(sheet.emoji),
                  ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(sheet.emoji, style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'Title',
                isEditing: ref.watch(isEditValueProvider),
                text: sheet.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) => ref
                    .read(sheetListProvider.notifier)
                    .updateSheetTitle(sheetId, value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZoeInlineTextEditWidget(
          hintText: 'Add a description',
          isEditing: ref.watch(isEditValueProvider),
          text: sheet.description,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          onTextChanged: (value) => ref
              .read(sheetListProvider.notifier)
              .updateSheetDescription(sheetId, value),
        ),
      ],
    );
  }
}
