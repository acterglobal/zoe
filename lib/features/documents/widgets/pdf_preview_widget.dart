import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class PdfPreviewWidget extends ConsumerStatefulWidget {
  final DocumentModel document;

  const PdfPreviewWidget({super.key, required this.document});

  @override
  ConsumerState<PdfPreviewWidget> createState() => _PdfPreviewWidgetState();
}

class _PdfPreviewWidgetState extends ConsumerState<PdfPreviewWidget> {
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPdfToolbar(context),
        Expanded(child: _buildPdfContainer(context)),
      ],
    );
  }

  Widget _buildPdfToolbar(BuildContext context) {
    final theme = Theme.of(context);

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
        ],
      ),
    );
  }

  Widget _buildToolbarButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return GlassyContainer(
      onTap: onPressed,
      width: 40,
      height: 40,
      borderRadius: BorderRadius.circular(12),
      borderOpacity: 0.1,
      shadowOpacity: 0.05,
      child: Icon(
        icon,
        size: 20,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
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

    return GlassyContainer(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(children: [if (isLoading) _buildLoadingOverlay(context)]),
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
          Icon(icon, size: 64, color: theme.colorScheme.error),
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
