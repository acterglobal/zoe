import 'package:flutter/material.dart';
import 'package:zoe/common/utils/file_utils.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/features/documents/actions/select_document_actions.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class SupportedPreviewWidget extends StatelessWidget {
  final DocumentModel document;

  const SupportedPreviewWidget({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final mimeType = document.mimeType;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StyledIconContainer(
            icon: getFileTypeIcon(mimeType),
            primaryColor: getFileTypeColor(mimeType),
            size: 120,
            iconSize: 60,
            backgroundOpacity: 0.1,
            borderOpacity: 0.15,
            shadowOpacity: 0.12,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 16),
          Text(
            getFileType(document.mimeType).toUpperCase(),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
