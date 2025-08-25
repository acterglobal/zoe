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

void selectDocumentSource(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) {
  final source = showModalBottomSheet<DocumentSource>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    enableDrag: true,
    showDragHandle: true,
    elevation: 6,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => const DocumentSelectionBottomSheetWidget(),
  );

  source.then((selectedSource) {
    if (selectedSource == null || !context.mounted) return;

    try {
      final result = switch (selectedSource) {
        DocumentSource.camera => handleCameraSelection(
          context,
          ref,
          listId,
          sheetId,
        ),
        DocumentSource.photoGallery => handlePhotoGallerySelection(
          context,
          ref,
          listId,
          sheetId,
        ),
        DocumentSource.fileChooser => handleFileChooserSelection(
          context,
          ref,
          listId,
          sheetId,
        ),
      };
      result;
    } catch (e) {
      if (context.mounted) {
        CommonUtils.showSnackBar(
          context,
          L10n.of(context).failedToAddDocument(e.toString()),
        );
      }
    }
  });
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
        L10n.of(context).photoCapturedAndAddedSuccessfully,
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
  final images = await imagePicker.pickMultiImage(imageQuality: 80);

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
        L10n.of(context).photosAddedSuccessfully(images.length),
      );
    }
  }
}

Future<void> handleFileChooserSelection(
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
    'txt' || 'md' || 'json' || 'xml' || 'html' || 'css' || 'js' || 'dart' || 'py' || 'java' || 'cpp' || 'c' || 'cs' || 'php' || 'rb' || 'go' || 'rs' || 'swift' || 'kt' || 'sql' || 'yaml' || 'yml' => Colors.amber,
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
    'txt' || 'md' || 'json' || 'xml' || 'html' || 'css' || 'js' || 'dart' || 'py' || 'java' || 'cpp' || 'c' || 'cs' || 'php' || 'rb' || 'go' || 'rs' || 'swift' || 'kt' || 'sql' || 'yaml' || 'yml' => Icons.text_fields,
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
      await Share.shareXFiles([
        XFile(document.filePath),
      ], text: '${L10n.of(context).checkOutThis} $fileType: ${document.title}');
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
