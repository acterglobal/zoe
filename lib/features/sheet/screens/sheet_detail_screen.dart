import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zoey/common/widgets/custom_emoji_picker_widget.dart';
import 'package:zoey/common/widgets/edit_view_toggle_button.dart';
import 'package:zoey/common/widgets/emoji_widget.dart';
import 'package:zoey/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/content/widgets/content_widget.dart';
import 'package:zoey/features/sheet/actions/delete_sheet.dart';
import 'package:zoey/features/sheet/actions/sheet_data_updates.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class SheetDetailScreen extends ConsumerWidget {
  final String sheetId;

  const SheetDetailScreen({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditValueProvider(sheetId));
    return NotebookPaperBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            EditViewToggleButton(parentId: sheetId),
            _buildDeleteButton(context, ref),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildBody(context, ref, isEditing),
                  buildQuillEditorPositionedToolbar(
                    context,
                    ref,
                    isEditing: isEditing,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
  Widget _buildBody(BuildContext context, WidgetRef ref, bool isEditing) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSheetHeader(context, ref, isEditing),
          const SizedBox(height: 16),
          ContentWidget(parentId: sheetId, sheetId: sheetId),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildSheetHeader(
    BuildContext context,
    WidgetRef ref,
    bool isEditing,
  ) {
    final sheet = ref.watch(sheetProvider(sheetId));
    if (sheet == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmojiWidget(
              isEditing: isEditing,
              emoji: sheet.emoji,
              size: 32,
              onTap: (emoji) {
                showCustomEmojiPicker(
                  context,
                  ref,
                  onEmojiSelected: (emoji) {
                    updateSheetEmoji(ref, sheetId, emoji);
                  },
                );
              },
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: L10n.of(context).title,
                isEditing: isEditing,
                text: sheet.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) => Future.microtask(
                  () => updateSheetTitle(ref, sheetId, value),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZoeHtmlTextEditWidget(
          hintText: L10n.of(context).addADescription,
          isEditing: isEditing,
          description: sheet.description,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          editorId: 'sheet-description-$sheetId', // Add unique editor ID
          onContentChanged: (description) => Future.microtask(
            () => updateSheetDescription(ref, sheetId, description),
          ),
        ),
      ],
    );
  }
}
