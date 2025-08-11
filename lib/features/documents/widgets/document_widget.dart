import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/documents/models/document_model.dart';
import 'package:zoey/features/documents/providers/document_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

class DocumentWidget extends ConsumerWidget {
  final String documentId;
  final bool isEditing;

  const DocumentWidget({
    super.key,
    required this.documentId,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentItem = ref.watch(documentProvider(documentId));

    if (documentItem == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 2, top: 2, left: 12),
      child: _buildDocumentItemContent(context, ref, documentItem, isEditing),
    );
  }

  Widget _buildDocumentItemContent(
    BuildContext context,
    WidgetRef ref,
    DocumentModel documentItem,
    bool isEditing,
  ) {
    return Row(
      children: [
        _buildDocumentItemIcon(context),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDocumentItemTitle(
            context,
            ref,
            documentItem.title,
            isEditing,
          ),
        ),
        const SizedBox(width: 6),
        if (isEditing) _buildDocumentItemActions(context, ref),
      ],
    );
  }

  // Builds the document item icon
  Widget _buildDocumentItemIcon(BuildContext context) {
    return Icon(
      Icons.upload_file,
      size: 18,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }

  // Builds the document item title
  Widget _buildDocumentItemTitle(
    BuildContext context,
    WidgetRef ref,
    String title,
    bool isEditing,
  ) {
    return ZoeInlineTextEditWidget(
      hintText: L10n.of(context).addADocument,
      isEditing: isEditing,
      text: title,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      onTextChanged: (value) {
        ref
            .read(documentListProvider.notifier)
            .updateDocumentTitle(documentId, value);
      },
      onBackspaceEmptyText: () =>
          ref.read(documentListProvider.notifier).deleteDocument(documentId),
    );
  }

  // Builds the document item actions
  Widget _buildDocumentItemActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Edit list item
        Icon(
          Icons.attach_file,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        ),

        const SizedBox(width: 6),

        // Delete list item
        ZoeCloseButtonWidget(
          onTap: () {
            ref.read(documentListProvider.notifier).deleteDocument(documentId);
          },
        ),
      ],
    );
  }
}
