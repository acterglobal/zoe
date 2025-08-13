import 'dart:io';

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