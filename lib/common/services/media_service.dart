import 'dart:io';

import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/utils/file_utils.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class MediaService {
  MediaService._();

  static final MediaService instance = MediaService._();

  final Dio _dio = Dio();

  Future<File?> _downloadMedia({
    required String url,
    bool isDownloadDirectory = false,
  }) async {
    try {
      // Extract and decode the actual file name
      final encodedPath = Uri.parse(url).pathSegments.last;
      final fileName = Uri.decodeComponent(encodedPath).split('/').last;

      String directoryPath;
      if (isDownloadDirectory) {
        final downloadDirectory = await getDownloadDirectory();
        directoryPath = downloadDirectory.path;
      } else {
        final tempDirectory = await getTemporaryDirectory();
        directoryPath = tempDirectory.path;
      }
      final savePath = "$directoryPath/$fileName";

      final file = File(savePath);
      if (file.existsSync() && !isDownloadDirectory) return file;

      await _dio.download(url, savePath);

      if (file.existsSync()) return file;
    } catch (e) {
      debugPrint("Download error: $e");
      return null;
    }
    return null;
  }

  Future<void> downloadDocumentMedia({
    required BuildContext context,
    required String url,
  }) async {
    final l10n = L10n.of(context);
    try {
      CommonUtils.showSnackBar(context, l10n.downloadingStarted);

      final file = await _downloadMedia(url: url, isDownloadDirectory: true);

      if (!context.mounted) return;
      if (file != null && file.existsSync()) {
        CommonUtils.showSnackBar(context, l10n.downloadCompletedSuccessfully);
      } else {
        CommonUtils.showSnackBar(context, l10n.downloadFailed);
      }
    } catch (e) {
      debugPrint("Download error: $e");
      CommonUtils.showSnackBar(context, l10n.downloadFailed);
    }
  }

  Future<void> shareDocument(
    BuildContext context,
    DocumentModel document,
  ) async {
    try {
      final file = await _downloadMedia(url: document.filePath);
      if (file == null || !file.existsSync()) {
        if (!context.mounted) return;
        CommonUtils.showSnackBar(
          context,
          L10n.of(context).failedToShare(getFileType(document.mimeType)),
        );
        return;
      }

      final params = ShareParams(
        files: [XFile(file.path)],
        fileNameOverrides: [document.title],
      );
      SharePlus.instance.share(params);
    } catch (e) {
      if (!context.mounted) return;
      CommonUtils.showSnackBar(
        context,
        L10n.of(context).failedToShare(getFileType(document.mimeType)),
      );
    }
  }
}
