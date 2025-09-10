import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/utils/file_utils.dart';
import 'package:zoe/common/actions/select_files_actions.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/widgets/document_action_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/document_error_widget.dart';
import 'package:zoe/features/documents/widgets/image_preview_widget.dart';
import 'package:zoe/features/documents/widgets/music_preview_widget.dart';
import 'package:zoe/features/documents/widgets/pdf_preview_widget.dart';
import 'package:zoe/features/documents/widgets/text_preview_widget.dart';
import 'package:zoe/features/documents/widgets/unsupported_preview_widget.dart';
import 'package:zoe/features/documents/widgets/video_preview_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class DocumentPreviewScreen extends ConsumerWidget {
  final String documentId;

  const DocumentPreviewScreen({
    super.key,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(documentProvider(documentId));

    if (document == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: ZoeAppBar(title: L10n.of(context).unknownDocument),
        ),
        body: DocumentErrorWidget(errorName: L10n.of(context).unknownDocument),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ZoeAppBar(
          title: document.title,
          actions: [
            DocumentActionButtons(
              onDownload: () => CommonUtils.showSnackBar(
                context,
                L10n.of(context).downloadingWillBeAvailableSoon,
              ),
              onShare: () => shareDocument(context, document),
            ),
          ],
        ),
      ),
      body: _buildBody(context, document),
    );
  }

  Widget _buildBody(BuildContext context, DocumentModel document) {
    final file = File(document.filePath);
    
    if (!file.existsSync()) {
      return DocumentErrorWidget(errorName: L10n.of(context).failedToLoadFile);
    }
    
    final fileType = getDocumentType(document);
    
    return switch (fileType) {
      DocumentFileType.image => ImagePreviewWidget(document: document),
      DocumentFileType.video => VideoPreviewWidget(document: document),
      DocumentFileType.music => MusicPreviewWidget(document: document),
      DocumentFileType.pdf => PdfPreviewWidget(document: document),
      DocumentFileType.text => TextPreviewWidget(document: document),
      DocumentFileType.unknown => UnsupportedPreviewWidget(document: document),
    };
  }
}

