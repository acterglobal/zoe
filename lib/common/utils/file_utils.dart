import 'dart:io';

import 'package:zoe/features/documents/models/document_model.dart';

String fileSizeFormat(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  } else if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  } else {
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

String getFileType(String filePath) {
  return filePath.split('.').last.toLowerCase();
}

String getFileSize(String filePath) {
  final file = File(filePath);
  return file.existsSync() ? fileSizeFormat(file.lengthSync()) : '0 B';
}

String convertToLowerCase(DocumentModel document) {
  return getFileType(document.filePath).toLowerCase();
}

bool isImageDocument(DocumentModel document) {
  final fileType = convertToLowerCase(document);
  return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileType);
}

bool isVideoDocument(DocumentModel document) {
  final fileType = convertToLowerCase(document);
  return ['mp4', 'mov', 'avi', 'wmv', 'flv'].contains(fileType);
}

bool isMusicDocument(DocumentModel document) {
  final fileType = convertToLowerCase(document);
  return ['mp3', 'wav', 'm4a', 'ogg', 'flac'].contains(fileType);
}

bool isPdfDocument(DocumentModel document) {
  final fileType = convertToLowerCase(document);
  return ['pdf'].contains(fileType);
}
