import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class PdfPreviewWidget extends ConsumerStatefulWidget {
  final DocumentModel document;

  const PdfPreviewWidget({super.key, required this.document});

  @override
  ConsumerState<PdfPreviewWidget> createState() => _PdfPreviewWidgetState();
}

class _PdfPreviewWidgetState extends ConsumerState<PdfPreviewWidget> {
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
    return Center(child: _buildPdfContainer(context));
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

    return StyledIconContainer(icon: Icons.picture_as_pdf, size: 100);
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
