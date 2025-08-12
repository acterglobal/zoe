import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';
import 'package:zoey/features/documents/actions/select_document_actions.dart';
import 'package:zoey/features/documents/models/document_model.dart';
import 'package:zoey/features/documents/providers/document_providers.dart';

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

    return _buildDocumentThumbnail(context, ref, documentItem);
  }

  Widget _buildDocumentThumbnail(
    BuildContext context,
    WidgetRef ref,
    DocumentModel document,
  ) {
    final theme = Theme.of(context);
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDocumentIcon(document),
                  const SizedBox(height: 6),
                  _buildDocumentFileName(context, document),
                  const SizedBox(height: 3),
                  _buildDocumentFileTypeBadge(context, document),
                ],
              ),
            ),
          ),
          if (isEditing)
            Positioned(
              top: -5,
              right: -5,
              child: _buildDeleteButton(ref, context, document),
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentIcon(DocumentModel document) {
    final color = getFileTypeColor(document.fileType);
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        getFileTypeIcon(document.fileType),
        color: AppColors.lightBackground,
        size: 16,
      ),
    );
  }

  Widget _buildDocumentFileName(BuildContext context, DocumentModel document) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        document.fileName.isNotEmpty ? document.fileName : document.title,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 8,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        softWrap: true,
      ),
    );
  }

  Widget _buildDocumentFileTypeBadge(
    BuildContext context,
    DocumentModel document,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Text(
        document.fileType.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
          fontSize: 8,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDeleteButton(
    WidgetRef ref,
    BuildContext context,
    DocumentModel document,
  ) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        ref.read(documentListProvider.notifier).deleteDocument(document.id);
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surface.withValues(alpha: 0.8),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.error.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.close_rounded,
          color: theme.colorScheme.error,
          size: 12,
        ),
      ),
    );
  }
}
