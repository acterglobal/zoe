import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/common/actions/select_files_actions.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class UnsupportedPreviewWidget extends StatelessWidget {
  final DocumentModel document;
  const UnsupportedPreviewWidget({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final path = document.filePath;
    final fileTypeColor = getFileTypeColor(path);
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StyledIconContainer(
            icon: getFileTypeIcon(path),
            primaryColor: fileTypeColor,
            size: 80,
            iconSize: 40,
            backgroundOpacity: 0.1,
            borderOpacity: 0.15,
            shadowOpacity: 0.12,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 16),
          Text(
            L10n.of(context).thisFileIsNotSupported,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}