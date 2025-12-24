import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';

class ImagePreviewWidget extends StatelessWidget {
  final DocumentModel document;

  const ImagePreviewWidget({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return GlassyContainer(
      borderRadius: BorderRadius.circular(20),
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(imageUrl: document.filePath),
      ),
    );
  }
}
