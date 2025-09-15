import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/long_tap_bottom_sheet.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/zoe_sheet_floating_actoin_button.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class BulletDetailScreen extends ConsumerWidget {
  final String bulletId;

  const BulletDetailScreen({super.key, required this.bulletId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editContentId = ref.watch(editContentIdProvider);
    final isEditing = editContentId == bulletId;
    final bullet = ref.watch(bulletProvider(bulletId));

    return NotebookPaperBackgroundWidget(
      child: bullet != null
          ? _buildDataBulletWidget(context, ref, bullet, isEditing)
          : _buildEmptyBulletWidget(context),
    );
  }

  Widget _buildEmptyBulletWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(automaticallyImplyLeading: false, title: ZoeAppBar()),
      body: Center(
        child: EmptyStateWidget(
          message: L10n.of(context).bulletNotFound,
          icon: Icons.format_list_bulleted_outlined,
        ),
      ),
    );
  }

  Widget _buildDataBulletWidget(
    BuildContext context,
    WidgetRef ref,
    BulletModel bullet,
    bool isEditing,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(actions: [ContentMenuButton(parentId: bulletId)]),
      ),
      body: MaxWidthWidget(
        child: Column(
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
      ),
      floatingActionButton: ZoeSheetFloatingActionButton(
        parentId: bulletId,
        sheetId: bullet.sheetId,
      ),
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
                onLongTapText: () => showLongTapBottomSheet(
                  context,
                  contentId: bulletId,
                ),
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
          editorId: 'bullet-description-$bulletId',
          // Add unique editor ID
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
