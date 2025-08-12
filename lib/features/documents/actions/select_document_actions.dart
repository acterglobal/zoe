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
  
  try {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      allowCompression: false,
      withData: false,
      withReadStream: true,
    );

    if (result == null || result.files.isEmpty) {
      // User cancelled or no files selected
      return;
    }

    // Validate files before processing
    final validFiles = result.files.where((file) {
      if (file.name.isEmpty) return false;
      if (file.size > 100 * 1024 * 1024) return false; // 100MB limit
      return true;
    }).toList();

    if (validFiles.isEmpty) {
      if (context.mounted) {
        CommonUtils.showSnackBar(
          context,
          'No valid files selected',
        );
      }
      return;
    }

    // Process valid files
    int successCount = 0;
    int errorCount = 0;

    for (final file in validFiles) {
      try {
        // Add the document first
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

        successCount++;
      } catch (e) {
        errorCount++;
        // Log error for debugging
        debugPrint('Error processing file ${file.name}: $e');
      }
    }

    // Show appropriate result message
    if (context.mounted) {
      if (successCount > 0 && errorCount == 0) {
        CommonUtils.showSnackBar(
          context,
          l10n.addedDocuments(successCount),
        );
      } else if (successCount > 0 && errorCount > 0) {
        CommonUtils.showSnackBar(
          context,
          '${l10n.addedDocuments(successCount)}. Failed to add $errorCount documents.',
        );
      } else {
        CommonUtils.showSnackBar(
          context,
          'Failed to add $errorCount documents.',
        );
      }
    }

  } catch (e) {
    // Handle file picker errors
    if (context.mounted) {
      CommonUtils.showSnackBar(
        context,
        l10n.failedToPickFile(e.toString()),
      );
    }
    debugPrint('File picker error: $e');
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
