import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class MediaService {
  MediaService._();

  static final MediaService instance = MediaService._();

  final Dio _dio = Dio();

  Future<void> downloadMedia(BuildContext context, String url) async {
    final l10n = L10n.of(context);
    try {
      CommonUtils.showSnackBar(context, l10n.downloadingStarted);

      // Extract and decode the actual file name
      final encodedPath = Uri.parse(url).pathSegments.last;
      final fileName = Uri.decodeComponent(encodedPath).split('/').last;

      final downloadDirectory = await getDownloadDirectory();
      String savePath = "${downloadDirectory.path}/$fileName";

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint("${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      if (!context.mounted) return;
      CommonUtils.showSnackBar(context, l10n.downloadCompletedSuccessfully);
    } catch (e) {
      debugPrint("Download error: $e");
      CommonUtils.showSnackBar(context, l10n.downloadFailed);
    }
  }
}
