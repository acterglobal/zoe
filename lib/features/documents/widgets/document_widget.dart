import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/file_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/features/documents/actions/select_document_actions.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/screens/document_preview_screen.dart';

class DocumentWidget extends ConsumerWidget {
  final String documentId;
  final bool isEditing;
  final bool isVertical;

  const DocumentWidget({
    super.key,
    required this.documentId,
    required this.isEditing,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentItem = ref.watch(documentProvider(documentId));

    if (documentItem == null) return const SizedBox.shrink();

    return !isVertical
        ? _buildDocumentThumbnail(context, ref, documentItem)
        : _buildDocumentItem(context, documentItem);
  }

  Widget _buildDocumentItem(BuildContext context, DocumentModel document) {
    final theme = Theme.of(context);
    final fileTypeColor = getFileTypeColor(document.filePath);
    final fileTypeIcon = getFileTypeIcon(document.filePath);

    return GlassyContainer(
      margin: const EdgeInsets.only(bottom: 8),
      borderRadius: BorderRadius.circular(12),
      onTap: () => _handleDocumentTap(context, document),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: StyledIconContainer(
          icon: fileTypeIcon,
          primaryColor: fileTypeColor,
          size: 48,
          iconSize: 24,
          backgroundOpacity: 0.1,
          borderOpacity: 0.15,
          shadowOpacity: 0.12,
        ),
        title: Text(
          document.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${getFileSize(document.filePath)}  •  ${getFileType(document.filePath).toUpperCase()}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void _handleDocumentTap(BuildContext context, DocumentModel document) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentPreviewScreen(
          document: document,
          isImage: isImageDocument(document),
          isVideo: isVideoDocument(document),
          isMusic: isMusicDocument(document),
          isPdf: isPdfDocument(document),
        ),
      ),
    );
  }

  Widget _buildDocumentThumbnail(
    BuildContext context,
    WidgetRef ref,
    DocumentModel document,
  ) {
    return GlassyContainer(
        onTap: () => _handleDocumentTap(context, document),
        width: 80,
        height: 100,
        margin: const EdgeInsets.only(bottom: 16),
        borderRadius: BorderRadius.circular(12),
        borderOpacity: 0.05,
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
    final fileTypeColor = getFileTypeColor(document.filePath);
    return StyledIconContainer(
      icon: getFileTypeIcon(document.filePath),
      primaryColor: fileTypeColor,
      size: 32,
      iconSize: 16,
      backgroundOpacity: 0.1,
      borderOpacity: 0.15,
      shadowOpacity: 0.12,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildDocumentFileName(BuildContext context, DocumentModel document) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 22,
      child: Text(
        document.title,
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
    return GlassyContainer(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.only(top: 2),
      borderOpacity: 0.08,
      shadowOpacity: 0.05,
      child: Text(
        getFileType(document.filePath).toUpperCase(),
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
    return GlassyContainer(
      width: 20,
      height: 20,
      borderRadius: BorderRadius.circular(12),
      shadowColor: theme.colorScheme.error,
      borderOpacity: 0.05,
      shadowOpacity: 1,
      child: Icon(
        Icons.close_rounded,
        color: theme.colorScheme.error,
        size: 12,
      ),
      onTap: () {
        ref.read(documentListProvider.notifier).deleteDocument(document.id);
      },
    );
  }
}
