import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/emoji_picker/widgets/custom_emoji_picker_widget.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/list/models/list_model.dart';
import 'package:zoe/features/list/providers/list_providers.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ListDetailsScreen extends ConsumerWidget {
  final String listId;
  const ListDetailsScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditValueProvider(listId));
    final list = ref.watch(listItemProvider(listId));
    if (list == null) {
      return Center(child: Text(L10n.of(context).listNotFound));
    }
    return NotebookPaperBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: ZoeAppBar(actions: [ContentMenuButton(parentId: listId)]),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildBody(context, ref, list, isEditing),
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
    ListModel list,
    bool isEditing,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListHeader(context, ref, list, isEditing),
          const SizedBox(height: 16),
          ContentWidget(parentId: listId, sheetId: list.sheetId),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildListHeader(
    BuildContext context,
    WidgetRef ref,
    ListModel list,
    bool isEditing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EmojiWidget(
              isEditing: isEditing,
              emoji: list.emoji ?? '🔸',
              size: 36,
              onTap: (currentEmoji) => showCustomEmojiPicker(
                context,
                ref,
                onEmojiSelected: (emoji) {
                  ref.read(listsrovider.notifier).updateListEmoji(listId, emoji);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: L10n.of(context).title,
                isEditing: isEditing,
                text: list.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) => ref
                    .read(listsrovider.notifier)
                    .updateListTitle(listId, value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZoeHtmlTextEditWidget(
          hintText: L10n.of(context).addADescription,
          isEditing: isEditing,
          description: list.description,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          editorId: 'list-description-$listId', // Add unique editor ID
          onContentChanged: (description) => Future.microtask(
            () => ref
                .read(listsrovider.notifier)
                .updateListDescription(listId, description),
          ),
        ),
      ],
    );
  }
} 