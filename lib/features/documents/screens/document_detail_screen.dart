import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/quill_editor/widgets/quill_editor_positioned_toolbar_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/add_content_bottom_sheet.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class DocumentDetailScreen extends ConsumerWidget {
  final String documentId;

  const DocumentDetailScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(documentProvider(documentId));
    final isEditing = ref.watch(isEditValueProvider(documentId));
    
    return NotebookPaperBackgroundWidget(
      child: document != null
          ? _buildDataDocumentWidget(context, ref, document, isEditing)
          : _buildEmptyDocumentWidget(context),
    );
  }

  Widget _buildEmptyDocumentWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(automaticallyImplyLeading: false, title: ZoeAppBar()),
      body: Center(
        child: EmptyStateWidget(
          message: L10n.of(context).documentNotFound,
          icon: Icons.description_outlined,
        ),
      ),
    );
  }

  Widget _buildDataDocumentWidget(
    BuildContext context,
    WidgetRef ref,
    DocumentModel document,
    bool isEditing,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(actions: [ContentMenuButton(parentId: documentId)]),
      ),
      body: MaxWidthWidget(
        child: Stack(
          children: [
            _buildBody(context, ref, document, isEditing),
            buildQuillEditorPositionedToolbar(
              context,
              ref,
              isEditing: isEditing,
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(
        context,
        isEditing,
        document,
      ),
    );
  }

  Widget _buildFloatingActionButton(
    BuildContext context,
    bool isEditing,
    DocumentModel document,
  ) {
    if (!isEditing) return const SizedBox.shrink();
    return ZoeFloatingActionButton(
      icon: Icons.add_rounded,
      onPressed: () => showAddContentBottomSheet(
        context,
        parentId: documentId,
        sheetId: document.sheetId,
      ),
    );
  }

  /// Builds the main body
  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    DocumentModel document,
    bool isEditing,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentHeader(context, ref, document, isEditing),
          const SizedBox(height: 16),
          ContentWidget(parentId: documentId, sheetId: document.sheetId),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildDocumentHeader(
    BuildContext context,
    WidgetRef ref,
    DocumentModel document,
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
                text: document.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) => ref
                    .read(documentListProvider.notifier)
                    .updateDocumentTitle(documentId, value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
