import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/emoji_picker/widgets/custom_emoji_picker_widget.dart';
import 'package:zoe/common/widgets/edit_view_toggle_button.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_delete_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/add_content_bottom_sheet.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/sheet/actions/delete_sheet.dart';
import 'package:zoe/features/sheet/actions/sheet_data_updates.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/users/widgets/user_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

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
          automaticallyImplyLeading: false,
          title: ZoeAppBar(
            title: L10n.of(context).sheet,
            actions: [
              EditViewToggleButton(parentId: sheetId),
              _buildDeleteButton(context, ref),
            ],
          ),
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
        floatingActionButton: _buildFloatingActionButton(context, isEditing),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, bool isEditing) {
    if (!isEditing) return const SizedBox.shrink();
    return ZoeFloatingActionButton(
      icon: Icons.add_rounded,
      onPressed: () => showAddContentBottomSheet(context, parentId: sheetId, sheetId: sheetId),
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
    final usersInSheet = ref.watch(listOfUsersBySheetIdProvider(sheetId));
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
        if (usersInSheet.isNotEmpty) ...[
          _buildUsersCountWidget(context, usersInSheet, ref),
          const SizedBox(height: 8),
        ],
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

  /// users count widget
  Widget _buildUsersCountWidget(
    BuildContext context,
    List<String> usersInSheet,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final userCount = usersInSheet.length;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => UserListWidget(
            userIdList: listOfUsersBySheetIdProvider(sheetId),
            title: l10n.usersInSheet,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              '$userCount ${userCount == 1 ? l10n.user : l10n.users}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
