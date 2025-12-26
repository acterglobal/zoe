import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/utils/file_utils.dart';
import 'package:zoe/common/widgets/media_selection_bottom_sheet.dart';
import 'package:zoe/features/documents/providers/document_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void selectDocumentSource(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String sheetId,
) {
  final l10n = L10n.of(context);

  showMediaSelectionBottomSheet(
    context,
    title: l10n.selectDocument,
    subtitle: l10n.chooseHowToAddDocument,
    allowMultiple: true,
    onTapCamera: (image) =>
        _handleDocumentCameraSelection(context, ref, image, listId, sheetId),
    onTapGallery: (images) =>
        _handleDocumentGallerySelection(context, ref, images, listId, sheetId),
    onTapFileChooser: (files) => _handleDocumentFileChooserSelection(
      context,
      ref,
      files,
      listId,
      sheetId,
    ),
  );
}

Future<void> _handleDocumentCameraSelection(
  BuildContext context,
  WidgetRef ref,
  XFile image,
  String listId,
  String sheetId,
) async {
  await ref
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

Future<void> _handleDocumentGallerySelection(
  BuildContext context,
  WidgetRef ref,
  List<XFile> images,
  String listId,
  String sheetId,
) async {
  for (final img in images) {
    await ref
        .read(documentListProvider.notifier)
        .addDocument(
          parentId: listId,
          sheetId: sheetId,
          title: img.name,
          filePath: img.path,
        );
  }
  if (!context.mounted) return;
  CommonUtils.showSnackBar(
    context,
    L10n.of(context).photosAddedSuccessfully(images.length),
  );
}

Future<void> _handleDocumentFileChooserSelection(
  BuildContext context,
  WidgetRef ref,
  List<XFile> files,
  String listId,
  String sheetId,
) async {
  for (final file in files) {
    if (!context.mounted) return;
    await ref
        .read(documentListProvider.notifier)
        .addDocument(
          parentId: listId,
          sheetId: sheetId,
          title: file.name,
          filePath: file.path,
        );
  }
  if (!context.mounted) return;
  CommonUtils.showSnackBar(
    context,
    L10n.of(context).filesAddedSuccessfully(files.length),
  );
}

Color getFileTypeColor(String mimeType) {
  final ext = getFileType(mimeType);
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

IconData getFileTypeIcon(String mimeType) {
  final ext = getFileType(mimeType);
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
