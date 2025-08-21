import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/utils/file_utils.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/features/documents/widgets/document_selection_bottom_sheet.dart';
import 'package:zoe/l10n/generated/l10n.dart';

Future<void> selectDocumentFile(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) async {
  
  // Show document selection bottom sheet
  final source = await showDocumentSelectionBottomSheet(context);
  if (source == null) return;

  try {
    switch (source) {
      case DocumentSource.camera:
        await handleCameraSelection(context, ref, listId, sheetId);
        break;
      case DocumentSource.photoGallery:
        await handlePhotoGallerySelection(context, ref, listId, sheetId);
        break;
      case DocumentSource.filePicker:
        await handleFilePickerSelection(context, ref, listId, sheetId);
        break;
    }
  } catch (e) {
    if (context.mounted) {
      CommonUtils.showSnackBar(
        context,
        'Failed to add document: $e',
      );
    }
  }
}

Future<void> handleCameraSelection(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) async {
  final imagePicker = ImagePicker();
  final image = await imagePicker.pickImage(
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
        'Photo captured and added successfully',
      );
    }
  }
}

Future<void> handlePhotoGallerySelection(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) async {
  final imagePicker = ImagePicker();
  final images = await imagePicker.pickMultiImage(
    imageQuality: 80,
  );

  if (images.isNotEmpty) {
    for (final image in images) {
      ref
          .read(documentListProvider.notifier)
          .addDocument(
            parentId: listId,
            sheetId: sheetId,
            title: image.name,
            filePath: image.path,
          );
    }

    if (context.mounted) {
      CommonUtils.showSnackBar(
        context,
        '${images.length} photos added successfully',
      );
    }
  }
}

Future<void> handleFilePickerSelection(
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
        '${result.files.length} files added successfully',
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
    _ => Icons.insert_drive_file,
  };
}

  Future<void> shareDocument(BuildContext context, DocumentModel document) async {
    try {
      final file = File(document.filePath);
      if (file.existsSync()) {
        final fileType = isImageDocument(document) ? 'image' : isVideoDocument(document) ? 'video' : 'document';
        await Share.shareXFiles(
          [XFile(document.filePath)],
          text: '${L10n.of(context).checkOutThis} $fileType: ${document.title}',
        );
      }
    } catch (e) {
      if (context.mounted) {
        CommonUtils.showSnackBar(
          context,
          L10n.of(context).failedToShare(isImageDocument(document) ? 'image' : isVideoDocument(document) ? 'video' : 'document'),
        );
      }
    }
  }