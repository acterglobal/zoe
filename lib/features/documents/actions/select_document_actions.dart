import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/documents/providers/document_providers.dart';
import 'package:zoey/l10n/generated/l10n.dart';

Future<void> pickDocumentFile(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) async {
  final l10n = L10n.of(context);
  final result = await FilePicker.platform.pickFiles(allowMultiple: true);

  if (result != null && result.files.isNotEmpty) {
    for (final file in result.files) {
      ref
          .read(documentListProvider.notifier)
          .addDocument(parentId: listId, sheetId: sheetId);

      // Get the newly added document to update it with file info
      final documents = ref.read(documentListProvider);
      final newDocument = documents.last;

      // Update the document with file information
      ref
          .read(documentListProvider.notifier)
          .updateDocumentFile(
            newDocument.id,
            file.name,
            file.extension ?? 'unknown',
            file.path ?? '',
          );
    }

    // Show success message
    if (context.mounted) {
      CommonUtils.showSnackBar(
        context,
        l10n.addedDocuments(result.files.length),
      );
    }
  }
}

Color getFileTypeColor(String fileType) {
  final ext = fileType.toLowerCase();
  switch (ext) {
    case 'pdf':
      return Colors.red;
    case 'doc':
    case 'docx':
      return Colors.blue;
    case 'xls':
    case 'xlsx':
      return Colors.green;
    case 'ppt':
    case 'pptx':
      return Colors.orange;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'webp':
      return Colors.purple;
    case 'mp3':
    case 'wav':
      return Colors.teal;
    case 'mp4':
    case 'avi':
    case 'mov':
      return Colors.indigo;
    default:
      return Colors.blueGrey;
  }
}

IconData getFileTypeIcon(String fileType) {
  final ext = fileType.toLowerCase();
  switch (ext) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'doc':
    case 'docx':
      return Icons.description;
    case 'xls':
    case 'xlsx':
      return Icons.table_chart;
    case 'ppt':
    case 'pptx':
      return Icons.slideshow;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'webp':
      return Icons.image;
    case 'mp3':
    case 'wav':
      return Icons.audiotrack;
    case 'mp4':
    case 'avi':
    case 'mov':
      return Icons.video_file;
    default:
      return Icons.insert_drive_file;
  }
}
