import 'package:flutter_test/flutter_test.dart';

import 'deep_link_utils.dart';

void main() {
  group('URI Extraction', () {
    test('extracts sheet ID from valid URI', () {
      final uri = Uri.parse('https://hellozoe.app/sheet/test-sheet-id');
      final sheetId = extractSheetIdFromUri(uri);
      expect(sheetId, equals('test-sheet-id'));
    });

    test('returns null for non-https scheme', () {
      final uri = Uri.parse('http://hellozoe.app/sheet/test-sheet-id');
      final sheetId = extractSheetIdFromUri(uri);
      expect(sheetId, isNull);
    });

    test('returns null for wrong host', () {
      final uri = Uri.parse('https://example.com/sheet/test-sheet-id');
      final sheetId = extractSheetIdFromUri(uri);
      expect(sheetId, isNull);
    });

    test('returns null for wrong path prefix', () {
      final uri = Uri.parse('https://hellozoe.app/wrong/test-sheet-id');
      final sheetId = extractSheetIdFromUri(uri);
      expect(sheetId, isNull);
    });

    test('returns null for insufficient path segments', () {
      final uri = Uri.parse('https://hellozoe.app/sheet');
      final sheetId = extractSheetIdFromUri(uri);
      expect(sheetId, isNull);
    });

    test('returns null for empty sheet ID', () {
      final uri = Uri.parse('https://hellozoe.app/sheet/');
      final sheetId = extractSheetIdFromUri(uri);
      expect(sheetId, isNull);
    });

    test('extracts sheet ID with additional path segments', () {
      final uri = Uri.parse(
        'https://hellozoe.app/sheet/test-sheet-id/extra/path',
      );
      final sheetId = extractSheetIdFromUri(uri);
      expect(sheetId, equals('test-sheet-id'));
    });

    test('handles URI with query parameters', () {
      final uri = Uri.parse(
        'https://hellozoe.app/sheet/test-sheet-id?param=value',
      );
      final sheetId = extractSheetIdFromUri(uri);
      expect(sheetId, equals('test-sheet-id'));
    });

    test('handles URI with fragment', () {
      final uri = Uri.parse(
        'https://hellozoe.app/sheet/test-sheet-id#fragment',
      );
      final sheetId = extractSheetIdFromUri(uri);
      expect(sheetId, equals('test-sheet-id'));
    });
  });
}
