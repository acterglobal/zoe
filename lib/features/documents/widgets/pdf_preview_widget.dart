import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfViewer.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class PdfPreviewWidget extends ConsumerStatefulWidget {
  final DocumentModel document;

  const PdfPreviewWidget({
    super.key,
    required this.document,
  });

  @override
  ConsumerState<PdfPreviewWidget> createState() => _PdfPreviewWidgetState();
}

class _PdfPreviewWidgetState extends ConsumerState<PdfPreviewWidget> {
  late PdfViewerController _pdfViewerController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        _buildPdfToolbar(context),
        Expanded(
          child: _buildPdfContainer(context),
        ),
      ],
    );
  }

  Widget _buildPdfToolbar(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    return GlassyContainer(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          Icon(
            Icons.picture_as_pdf_rounded,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.pdfViewer,
              style: theme.textTheme.titleMedium
            ),
          ),
          _buildToolbarButton(
            context,
            Icons.zoom_in_rounded,
            l10n.zoomIn,
            () => _pdfViewerController.zoomLevel = 
                (_pdfViewerController.zoomLevel * 1.25).clamp(0.25, 3.0),
          ),
          const SizedBox(width: 8),
          _buildToolbarButton(
            context,
            Icons.zoom_out_rounded,
            l10n.zoomOut,
            () => _pdfViewerController.zoomLevel = 
                (_pdfViewerController.zoomLevel / 1.25).clamp(0.25, 3.0),
          ),
          const SizedBox(width: 8),
          _buildToolbarButton(
            context,
            Icons.fit_screen_rounded,
            l10n.zoomToFit,
            () => _pdfViewerController.zoomLevel = 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: GlassyContainer(
        width: 40,
        height: 40,
        borderRadius: BorderRadius.circular(12),
        borderOpacity: 0.1,
        shadowOpacity: 0.05,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildPdfContainer(BuildContext context) {
    final file = File(widget.document.filePath);
    
    if (!file.existsSync()) {
      return _buildErrorContainer(
        context,
        L10n.of(context).pdfFileNotFound,
        Icons.error_outline_rounded,
      );
    }

    if (_errorMessage != null) {
      return _buildErrorContainer(
        context,
        _errorMessage!,
        Icons.broken_image_rounded,
      );
    }

    return GlassyContainer(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            SfPdfViewer.file(
              file,
              controller: _pdfViewerController,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                setState(() {
                  _isLoading = false;
                });
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                setState(() {
                  _isLoading = false;
                  _errorMessage = 'Failed to load PDF: ${details.error}';
                });
              },
            ),
            if (_isLoading)
              _buildLoadingOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface.withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              L10n.of(context).loadingPDF,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContainer(
    BuildContext context,
    String message,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return GlassyContainer(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            L10n.of(context).pdfFileNotFoundDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
