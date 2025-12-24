// import 'dart:io';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:zoe/common/utils/file_utils.dart';
// import 'package:zoe/features/documents/models/document_model.dart';
//
// void main() {
//   group('FileUtils', () {
//     // Helper function
//     DocumentModel createDocumentModel(String filePath) {
//       return DocumentModel(
//         id: 'test_id',
//         parentId: 'parent_id',
//         sheetId: 'sheet_id',
//         title: 'Test Document',
//         filePath: filePath,
//         createdBy: 'user_id',
//       );
//     }
//
//     group('fileSizeFormat', () {
//       test('formats different sizes correctly', () {
//         expect(fileSizeFormat(0), equals('0 B'));
//         expect(fileSizeFormat(1024), equals('1.0 KB'));
//         expect(fileSizeFormat(1048576), equals('1.0 MB'));
//         expect(fileSizeFormat(1073741824), equals('1.0 GB'));
//       });
//     });
//
//     group('getFileType', () {
//       test('extracts file extension correctly', () {
//         expect(getFileType('document.pdf'), equals('pdf'));
//         expect(getFileType('image.jpg'), equals('jpg'));
//         expect(getFileType('video.mp4'), equals('mp4'));
//       });
//
//       test('handles case insensitive extensions', () {
//         expect(getFileType('document.PDF'), equals('pdf'));
//         expect(getFileType('image.JPG'), equals('jpg'));
//       });
//     });
//
//     group('getFileSize', () {
//       test('returns 0 B for non-existing file', () {
//         expect(getFileSize('non_existing_file.txt'), equals('0 B'));
//       });
//
//       test('returns file size for existing file', () {
//         final tempFile = File('test_file.txt');
//         tempFile.writeAsStringSync('test content');
//
//         try {
//           final size = getFileSize('test_file.txt');
//           expect(size, isNotEmpty);
//           expect(size, contains('B'));
//         } finally {
//           tempFile.deleteSync();
//         }
//       });
//     });
//
//     group('Document Type Detection', () {
//       test('detects image documents', () {
//         final document = createDocumentModel('image.jpg');
//         expect(isImageDocument(document), isTrue);
//         expect(getDocumentType(document), equals(DocumentFileType.image));
//       });
//
//       test('detects video documents', () {
//         final document = createDocumentModel('video.mp4');
//         expect(isVideoDocument(document), isTrue);
//         expect(getDocumentType(document), equals(DocumentFileType.video));
//       });
//
//       test('detects music documents', () {
//         final document = createDocumentModel('music.mp3');
//         expect(isMusicDocument(document), isTrue);
//         expect(getDocumentType(document), equals(DocumentFileType.music));
//       });
//
//       test('detects PDF documents', () {
//         final document = createDocumentModel('document.pdf');
//         expect(isPdfDocument(document), isTrue);
//         expect(getDocumentType(document), equals(DocumentFileType.pdf));
//       });
//
//       test('detects text documents', () {
//         final document = createDocumentModel('text.txt');
//         expect(isTextDocument(document), isTrue);
//         expect(getDocumentType(document), equals(DocumentFileType.text));
//       });
//
//       test('returns unknown for unrecognized files', () {
//         final document = createDocumentModel('file.exe');
//         expect(getDocumentType(document), equals(DocumentFileType.unknown));
//       });
//     });
//
//     group('Edge Cases', () {
//       test('handles files without extensions', () {
//         expect(getFileType('README'), equals('readme'));
//         expect(getFileType(''), equals(''));
//       });
//
//       test('handles complex file paths', () {
//         final document = createDocumentModel('/path/to/document.pdf');
//         expect(getDocumentType(document), equals(DocumentFileType.pdf));
//       });
//     });
//   });
// }