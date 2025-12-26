import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_network_local_image_view.dart';
import 'package:zoe/features/documents/models/document_model.dart';

class ImagePreviewWidget extends StatelessWidget {
  final DocumentModel document;

  const ImagePreviewWidget({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final borderRadius = 20.0;

    return GlassyContainer(
      borderRadius: BorderRadius.circular(borderRadius),
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      child: ZoeNetworkLocalImageView(
        imageUrl: document.filePath,
        borderRadius: borderRadius,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        placeholderIconSize: 200,
      ),
    );
  }
}
