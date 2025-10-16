import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/documents/actions/text_preview_actions.dart';

void main() {
  group('Text Preview Actions Tests', () {
    group('getTextSearchIndices', () {
      test('returns empty list when query is empty', () {
        const content = 'This is a test content\nwith multiple lines\nof text';
        const query = '';

        final result = getTextSearchIndices(content, query);

        expect(result, isEmpty);
      });

      test('finds single match in single line content', () {
        const content = 'This is a test content';
        const query = 'test';

        final result = getTextSearchIndices(content, query);

        expect(result, equals([0]));
      });

      test('finds matches across multiple lines', () {
        const content = 'First line\nSecond line with test\nThird line\nFourth line test';
        const query = 'test';

        final result = getTextSearchIndices(content, query);

        expect(result, equals([1, 3]));
      });

      test('is case insensitive', () {
        const content = 'First line\nSecond line with TEST\nThird line\nFourth line Test';
        const query = 'test';

        final result = getTextSearchIndices(content, query);

        expect(result, equals([1, 3]));
      });

      test('returns empty list when no matches found', () {
        const content = 'First line\nSecond line\nThird line\nFourth line';
        const query = 'nonexistent';

        final result = getTextSearchIndices(content, query);

        expect(result, isEmpty);
      });

      test('handles partial word matches', () {
        const content = 'First line\nSecond line with testing\nThird line';
        const query = 'test';

        final result = getTextSearchIndices(content, query);

        expect(result, equals([1]));
      });
    });
  });
}
