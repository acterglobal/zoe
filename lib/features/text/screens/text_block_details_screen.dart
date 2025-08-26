import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/edit_view_toggle_button.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class TextBlockDetailsScreen extends ConsumerWidget {
  final String textBlockId;

  const TextBlockDetailsScreen({super.key, required this.textBlockId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditValueProvider(textBlockId));
    final textBlock = ref.watch(textProvider(textBlockId));
    if (textBlock == null) {
      return Center(child: Text(L10n.of(context).textBlockNotFound));
    }
    return NotebookPaperBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: ZoeAppBar(actions: [EditViewToggleButton(parentId: textBlockId)]),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildBody(context, ref, textBlock, isEditing),
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

  /// Builds the main body
  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    TextModel textBlock,
    bool isEditing,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextBlockHeader(context, ref, textBlock, isEditing),
          const SizedBox(height: 16),
          ContentWidget(parentId: textBlockId, sheetId: textBlock.sheetId),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildTextBlockHeader(
    BuildContext context,
    WidgetRef ref,
    TextModel textBlock,
    bool isEditing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: L10n.of(context).title,
                isEditing: isEditing,
                text: textBlock.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) => ref
                    .read(textListProvider.notifier)
                    .updateTextTitle(textBlockId, value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZoeHtmlTextEditWidget(
          hintText: L10n.of(context).addADescription,
          isEditing: isEditing,
          description: textBlock.description,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          editorId: 'text-block-description-$textBlockId', // Add unique editor ID
          onContentChanged: (description) => Future.microtask(
            () => ref
                .read(textListProvider.notifier)
                .updateTextDescription(textBlockId, description),
          ),
        ),
      ],
    );
  }
}