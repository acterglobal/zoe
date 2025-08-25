import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/utils/file_utils.dart';
import 'package:zoe/features/documents/actions/select_document_actions.dart';
import 'package:zoe/features/documents/widgets/document_action_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/image_preview_widget.dart';
import 'package:zoe/features/documents/widgets/music_preview_widget.dart';
import 'package:zoe/features/documents/widgets/pdf_preview_widget.dart';
import 'package:zoe/features/documents/widgets/text_preview_widget.dart';
import 'package:zoe/features/documents/widgets/unsupported_preview_widget.dart';
import 'package:zoe/features/documents/widgets/video_preview_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class DocumentPreviewScreen extends ConsumerStatefulWidget {
  final DocumentModel document;
  final bool isEditing;
  final DocumentFileType fileType;

  const DocumentPreviewScreen({
    super.key,
    required this.document,
    this.isEditing = false,
    required this.fileType,
  });

  @override
  ConsumerState<DocumentPreviewScreen> createState() =>
      _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends ConsumerState<DocumentPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(
          title: widget.document.title,
          actions:
              widget.fileType != DocumentFileType.unknown
              ? [
                  DocumentActionButtons(
                    onDownload: () => CommonUtils.showSnackBar(
                      context,
                      L10n.of(context).downloadingWillBeAvailableSoon,
                    ),
                    onShare: () => shareDocument(context, widget.document),
                  ),
                ]
              : null,
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final file = File(widget.document.filePath);
    final theme = Theme.of(context);
    if (!file.existsSync()) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              L10n.of(context).documentNotFound,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      );
    }

    switch (widget.fileType) {
      case DocumentFileType.image : return ImagePreviewWidget(document: widget.document);
      case DocumentFileType.video : return VideoPreviewWidget(document: widget.document);
      case DocumentFileType.music : return MusicPreviewWidget(document: widget.document);
      case DocumentFileType.pdf : return PdfPreviewWidget(document: widget.document);
      case DocumentFileType.text : return TextPreviewWidget(document: widget.document);
      default : return UnsupportedPreviewWidget(document: widget.document);
    }
  }
}

