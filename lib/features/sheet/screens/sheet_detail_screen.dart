import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/quill_editor/providers/quill_toolbar_providers.dart';
import 'package:zoey/common/widgets/edit_view_toggle_button.dart';
import 'package:zoey/common/widgets/emoji_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/common/widgets/quill_editor/widgets/quill_editor_toolbar_widget.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/content/widgets/content_widget.dart';
import 'package:zoey/features/sheet/actions/delete_sheet.dart';
import 'package:zoey/features/sheet/actions/sheet_data_updates.dart';
import 'package:zoey/features/sheet/providers/sheet_providers.dart';

class SheetDetailScreen extends ConsumerWidget {
  final String sheetId;

  const SheetDetailScreen({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditValueProvider);
    final toolbarState = ref.watch(quillToolbarProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [EditViewToggleButton(), _buildDeleteButton(context, ref)],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _buildBody(context, ref),
                if (isEditing)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: QuillEditorToolbarWidget(
                      controller: toolbarState.activeController,
                      focusNode: toolbarState.activeFocusNode,
                      isToolbarVisible: toolbarState.isToolbarVisible,
                      onReturnFocusToEditor: () {
                        ref
                            .read(quillToolbarProvider.notifier)
                            .returnFocusToEditor();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
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
    final isEditing = ref.watch(isEditValueProvider);
    final sheet = ref.watch(sheetProvider(sheetId));
    if (sheet == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmojiWidget(
              emoji: sheet.emoji,
              size: 32,
              onTap: (emoji) => updateSheetEmoji(ref, sheetId, emoji),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'Title',
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
          hintText: 'Add a description',
          isEditing: isEditing,
          initialContent: sheet.description?.plainText,
          initialRichContent: sheet.description?.htmlText,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          editorId: 'sheet-description-$sheetId', // Add unique editor ID
          onContentChanged: (plainText, htmlText) => Future.microtask(
            () => updateSheetDescription(ref, sheetId, (
              plainText: plainText,
              htmlText: htmlText,
            )),
          ),
        ),
      ],
    );
  }
}
