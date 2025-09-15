import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/utils/file_utils.dart';
import 'package:zoe/common/widgets/document_selection_bottom_sheet.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void selectDocumentSource(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) {
  showFileSelectionBottomSheet(
    context,
    onTapCamera: () =>
        _handleDocumentCameraSelection(context, ref, listId, sheetId),
    onTapGallery: () =>
        _handleDocumentGallerySelection(context, ref, listId, sheetId),
    onTapFileChooser: () =>
        _handleDocumentFileChooserSelection(context, ref, listId, sheetId),
  );
}

Future<void> _handleDocumentCameraSelection(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 80,
  );

  if (image != null) {
    ref
        .read(documentListProvider.notifier)
        .addDocument(
          parentId: listId,
          sheetId: sheetId,
          title: 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
          filePath: image.path,
        );

    if (context.mounted) {
      CommonUtils.showSnackBar(
        context,
        L10n.of(context).photoCapturedAndAddedSuccessfully,
      );
    }
  }
}

Future<void> _handleDocumentGallerySelection(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) async {
  final picker = ImagePicker();
  final images = await picker.pickMultiImage(imageQuality: 80);

  if (images.isNotEmpty) {
    for (final img in images) {
      ref
          .read(documentListProvider.notifier)
          .addDocument(
            parentId: listId,
            sheetId: sheetId,
            title: img.name,
            filePath: img.path,
          );
    }
    if (context.mounted) {
      CommonUtils.showSnackBar(
        context,
        L10n.of(context).photosAddedSuccessfully(images.length),
      );
    }
  }
}

Future<void> _handleDocumentFileChooserSelection(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) async {
  final result = await FilePicker.platform.pickFiles(allowMultiple: true);

  if (result != null && result.files.isNotEmpty) {
    for (final file in result.files) {
      ref
          .read(documentListProvider.notifier)
          .addDocument(
            parentId: listId,
            sheetId: sheetId,
            title: file.name,
            filePath: file.path ?? '',
          );
    }
    if (context.mounted) {
      CommonUtils.showSnackBar(
        context,
        L10n.of(context).filesAddedSuccessfully(result.files.length),
      );
    }
  }
}

Color getFileTypeColor(String filePath) {
  final ext = getFileType(filePath);
  return switch (ext) {
    'pdf' => Colors.red,
    'doc' || 'docx' => Colors.blue,
    'xls' || 'xlsx' => Colors.green,
    'ppt' || 'pptx' => Colors.orange,
    'jpg' || 'jpeg' || 'png' || 'gif' || 'webp' => Colors.purple,
    'mp3' || 'wav' => Colors.teal,
    'mp4' || 'avi' || 'mov' => Colors.indigo,
    'txt' ||
    'md' ||
    'json' ||
    'xml' ||
    'html' ||
    'css' ||
    'js' ||
    'dart' ||
    'py' ||
    'java' ||
    'cpp' ||
    'c' ||
    'cs' ||
    'php' ||
    'rb' ||
    'go' ||
    'rs' ||
    'swift' ||
    'kt' ||
    'sql' ||
    'yaml' ||
    'yml' => Colors.amber,
    _ => Colors.blueGrey,
  };
}

IconData getFileTypeIcon(String filePath) {
  final ext = getFileType(filePath);
  return switch (ext) {
    'pdf' => Icons.picture_as_pdf,
    'doc' || 'docx' => Icons.description,
    'xls' || 'xlsx' => Icons.table_chart,
    'ppt' || 'pptx' => Icons.slideshow,
    'jpg' || 'jpeg' || 'png' || 'gif' || 'webp' => Icons.image,
    'mp3' || 'wav' => Icons.audiotrack,
    'mp4' || 'avi' || 'mov' => Icons.video_file,
    'txt' ||
    'md' ||
    'json' ||
    'xml' ||
    'html' ||
    'css' ||
    'js' ||
    'dart' ||
    'py' ||
    'java' ||
    'cpp' ||
    'c' ||
    'cs' ||
    'php' ||
    'rb' ||
    'go' ||
    'rs' ||
    'swift' ||
    'kt' ||
    'sql' ||
    'yaml' ||
    'yml' => Icons.text_fields,
    _ => Icons.insert_drive_file,
  };
}

Future<void> shareDocument(BuildContext context, DocumentModel document) async {
  final fileType = isImageDocument(document)
      ? 'image'
      : isVideoDocument(document)
      ? 'video'
      : isMusicDocument(document)
      ? 'audio'
      : isPdfDocument(document)
      ? 'PDF'
      : isTextDocument(document)
      ? 'text'
      : 'file';
  try {
    final file = File(document.filePath);
    if (file.existsSync()) {
      final params = ShareParams(
        files: [XFile(document.filePath)],
        fileNameOverrides: [document.title],
      );
      SharePlus.instance.share(params);
    }
  } catch (e) {
    if (context.mounted) {
      CommonUtils.showSnackBar(
        context,
        L10n.of(context).failedToShare(fileType),
      );
    }
  }
}
