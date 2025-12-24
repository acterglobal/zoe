import 'package:mime/mime.dart';
import 'package:zoe/features/documents/models/document_model.dart';

enum DocumentFileType { unknown, image, svg, video, music, pdf, text }

String getFileSize(int bytes) {
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

DocumentFileType getDocumentType(DocumentModel document) {
  if (isImageDocument(document)) return DocumentFileType.image;
  if (isSvgDocument(document)) return DocumentFileType.svg;
  if (isVideoDocument(document)) return DocumentFileType.video;
  if (isMusicDocument(document)) return DocumentFileType.music;
  if (isPdfDocument(document)) return DocumentFileType.pdf;
  if (isTextDocument(document)) return DocumentFileType.text;
  return DocumentFileType.unknown;
}

String getFileType(String mimeType) {
  return extensionFromMime(mimeType) ?? "file";
}

bool isImageDocument(DocumentModel document) {
  final fileType = getFileType(document.mimeType).toLowerCase();
  return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileType);
}

bool isSvgDocument(DocumentModel document) {
  final fileType = getFileType(document.mimeType).toLowerCase();
  return ['svg'].contains(fileType);
}

bool isVideoDocument(DocumentModel document) {
  final fileType = getFileType(document.mimeType).toLowerCase();
  return ['mp4', 'mov', 'avi', 'wmv', 'flv'].contains(fileType);
}

bool isMusicDocument(DocumentModel document) {
  final fileType = getFileType(document.mimeType).toLowerCase();
  return ['mp3', 'mpga', 'wav', 'm4a', 'ogg', 'flac'].contains(fileType);
}

bool isPdfDocument(DocumentModel document) {
  final fileType = getFileType(document.mimeType).toLowerCase();
  return ['pdf'].contains(fileType);
}

bool isTextDocument(DocumentModel document) {
  final fileType = getFileType(document.mimeType).toLowerCase();
  return [
    'txt',
    'md',
    'json',
    'xml',
    'html',
    'htm',
    'css',
    'js',
    'dart',
    'py',
    'java',
    'cpp',
    'c',
    'h',
    'cs',
    'php',
    'rb',
    'go',
    'rs',
    'swift',
    'kt',
    'sql',
    'yaml',
    'yml',
    'ini',
    'cfg',
    'conf',
    'log',
    'csv',
    'tsv',
  ].contains(fileType);
}
