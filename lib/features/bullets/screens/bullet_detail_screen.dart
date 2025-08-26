import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/edit_view_toggle_button.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';

import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/add_content_bottom_sheet.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class BulletDetailScreen extends ConsumerWidget {
  final String bulletId;

  const BulletDetailScreen({super.key, required this.bulletId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditValueProvider(bulletId));
    final bullet = ref.watch(bulletProvider(bulletId));
    if (bullet == null) {
      return Center(child: Text(L10n.of(context).bulletNotFound));
    }
    return NotebookPaperBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: ZoeAppBar(actions: [EditViewToggleButton(parentId: bulletId)]),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildBody(context, ref, bullet, isEditing),
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
        floatingActionButton: _buildFloatingActionButton(context, isEditing, bullet),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, bool isEditing, BulletModel bullet) {
    if (!isEditing) return const SizedBox.shrink();
    return ZoeFloatingActionButton(
      icon: Icons.add_rounded,
      onPressed: () => showAddContentBottomSheet(context, parentId: bulletId, sheetId: bullet.sheetId),
    );
  }

  /// Builds the main body
  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    BulletModel bullet,
    bool isEditing,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletHeader(context, ref, bullet, isEditing),
          const SizedBox(height: 16),
          ContentWidget(parentId: bulletId, sheetId: bullet.sheetId),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildBulletHeader(
    BuildContext context,
    WidgetRef ref,
    BulletModel bullet,
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
                text: bullet.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) => ref
                    .read(bulletListProvider.notifier)
                    .updateBulletTitle(bulletId, value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZoeHtmlTextEditWidget(
          hintText: L10n.of(context).addADescription,
          isEditing: isEditing,
          description: bullet.description,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          editorId: 'bullet-description-$bulletId', // Add unique editor ID
          onContentChanged: (description) => Future.microtask(
            () => ref
                .read(bulletListProvider.notifier)
                .updateBulletDescription(bulletId, description),
          ),
        ),
      ],
    );
  }
}
