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
          .addDocument(
            parentId: listId,
            sheetId: sheetId,
            title: file.name,
            fileType: file.extension ?? 'unknown',
            filePath: file.path ?? '',
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
  return switch (ext) {
    'pdf' => Colors.red,
    'doc' || 'docx' => Colors.blue,
    'xls' || 'xlsx' => Colors.green,
    'ppt' || 'pptx' => Colors.orange,
    'jpg' || 'jpeg' || 'png' || 'gif' || 'webp' => Colors.purple,
    'mp3' || 'wav' => Colors.teal,
    'mp4' || 'avi' || 'mov' => Colors.indigo,
    _ => Colors.blueGrey,
  };
}

IconData getFileTypeIcon(String fileType) {
  final ext = fileType.toLowerCase();
  return switch (ext) {
    'pdf' => Icons.picture_as_pdf,
    'doc' || 'docx' => Icons.description,
    'xls' || 'xlsx' => Icons.table_chart,
    'ppt' || 'pptx' => Icons.slideshow,
    'jpg' || 'jpeg' || 'png' || 'gif' || 'webp' => Icons.image,
    'mp3' || 'wav' => Icons.audiotrack,
    'mp4' || 'avi' || 'mov' => Icons.video_file,
    _ => Icons.insert_drive_file,
  };
}
