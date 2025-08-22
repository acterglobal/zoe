import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
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
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(widget.document.filePath),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildImageError(context);
          },
        ),
      ),
    );
  }

  Widget _buildImageError(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_rounded,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            L10n.of(context).failedToLoadImage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
