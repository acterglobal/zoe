import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/document_error_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ImagePreviewWidget extends ConsumerStatefulWidget {
  final DocumentModel document;

  const ImagePreviewWidget({super.key, required this.document});

  @override
  ConsumerState<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends ConsumerState<ImagePreviewWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _buildImageContainer(context));
  }

  Widget _buildImageContainer(BuildContext context) {

    return GlassyContainer(
      borderRadius: BorderRadius.circular(20),
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(widget.document.filePath),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return DocumentErrorWidget(errorName:L10n.of(context).failedToLoadImage);
          },
        ),
      ),
    );
  }
}
