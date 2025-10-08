import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/data/text_list.dart';

void main() {
  late ProviderContainer container;
  late String testTextId = 'text-content-1';

  setUp(() {
    container = ProviderContainer.test();
  });

  // Helper methods to reduce repetitive container.read calls
  List<TextModel> getTextList() => container.read(textListProvider);

  TextModel? getTextById(String id) => container.read(textProvider(id));

  List<TextModel> getTextsByParent(String parentId) =>
      container.read(textByParentProvider(parentId));

  List<TextModel> searchTexts(String searchTerm) =>
      container.read(textListSearchProvider(searchTerm));

  List<TextModel> getSortedTexts() => container.read(sortedTextsProvider);

  group('TextList Provider', () {
    test('initial state contains data', () {
      final textList = getTextList();

      expect(textList, isA<List<TextModel>>());
      expect(textList.first.id, equals(testTextId));
      expect(textList.first.title, equals('Welcome to Zoe!'));
      expect(textList.first.emoji, isNull);
    });

    test('addText adds new text to the list', () {
      final newText = textList.first.copyWith(
        id: 'new-text-id',
        title: 'New Text',
        emoji: '🆕',
      );

      container.read(textListProvider.notifier).addText(newText);

      final updatedList = getTextList();
      expect(updatedList.last.id, equals('new-text-id'));
      expect(updatedList.last.title, equals('New Text'));
    });

    test('deleteText removes data from the list', () {
      container.read(textListProvider.notifier).deleteText(testTextId);

      final updatedList = getTextList();
      expect(updatedList.any((t) => t.id == testTextId), isFalse);
    });

    test('updateTextTitle changes title of data', () {
      container
          .read(textListProvider.notifier)
          .updateTextTitle(testTextId, 'Updated Title');

      final updatedList = getTextList();
      final targetText = updatedList.firstWhere(
        (t) => t.id == testTextId,
      );
      expect(targetText.title, equals('Updated Title'));
    });

    test('updateTextDescription changes description of data', () {
      final newDescription = (
        plainText: 'Updated description content',
        htmlText: '<p>Updated description content</p>',
      );

      container
          .read(textListProvider.notifier)
          .updateTextDescription(testTextId, newDescription);

      final updatedList = getTextList();
      final targetText = updatedList.firstWhere(
        (t) => t.id == testTextId,
      );
      expect(targetText.description, equals(newDescription));
    });

    test('updateTextEmoji changes emoji of data', () {
      container
          .read(textListProvider.notifier)
          .updateTextEmoji(testTextId, '🎉');

      final updatedList = getTextList();
      final targetText = updatedList.firstWhere(
        (t) => t.id == testTextId,
      );
      expect(targetText.emoji, equals('🎉'));
    });

    test('updateTextOrderIndex changes order index of data', () {
      container
          .read(textListProvider.notifier)
          .updateTextOrderIndex(testTextId, 99);

      final updatedList = getTextList();
      final targetText = updatedList.firstWhere(
        (t) => t.id == testTextId,
      );
      expect(targetText.orderIndex, equals(99));
    });

    test('multiple operations maintain list integrity', () {
      // Add a text based on existing data
      final newText = textList.first.copyWith(
        id: 'new-text-id',
        title: 'New Text',
        emoji: '🆕',
      );
      container.read(textListProvider.notifier).addText(newText);

      // Update text-content-1
      container
          .read(textListProvider.notifier)
          .updateTextTitle(testTextId, 'Modified Title');

      final finalList = getTextList();

      final modifiedText = finalList.firstWhere(
        (t) => t.id == testTextId,
      );
      expect(modifiedText.title, equals('Modified Title'));

      expect(finalList.any((t) => t.id == 'new-text-id'), isTrue);
    });
  });

  group('Text Provider (by ID)', () {
    test('returns correct text for data', () {
      final text = getTextById(testTextId);

      expect(text, isNotNull);
      expect(text!.id, equals(testTextId));
      expect(text.title, equals('Welcome to Zoe!'));
      expect(text.emoji, isNull); // text-content-1 doesn't have an emoji
    });

    test('returns null for non-existent ID', () {
      final text = getTextById('non-existent-id');

      expect(text, isNull);
    });
  });

  group('TextByParent Provider', () {
    test('returns text-content-1 when filtered by sheet-1', () {
      final texts = getTextsByParent('sheet-1');

      expect(texts, isA<List<TextModel>>());
      
      // Find text-content-1 in the filtered list
      final textContent1 = texts.firstWhere(
        (text) => text.id == testTextId,
        orElse: () => throw Exception('text-content-1 not found'),
      );
      
      expect(textContent1.id, equals(testTextId));
      expect(textContent1.parentId, equals('sheet-1'));
      expect(textContent1.title, equals('Welcome to Zoe!'));
    });

    test('data has correct orderIndex in sheet-1', () {
      final texts = getTextsByParent('sheet-1');

      final textContent1 = texts.firstWhere(
        (text) => text.id == testTextId,
        orElse: () => throw Exception('text-content-1 not found'),
      );
      
      expect(textContent1.orderIndex, equals(1));
    });

    test('updates order when data orderIndex changes', () {
      // Change orderIndex of text-content-1
      container
          .read(textListProvider.notifier)
          .updateTextOrderIndex(testTextId, 0);

      final texts = getTextsByParent('sheet-1');

      // Find text-content-1 in the updated list
      final textContent1 = texts.firstWhere(
        (text) => text.id == testTextId,
        orElse: () => throw Exception('text-content-1 not found'),
      );
      
      expect(textContent1.orderIndex, equals(0));
    });
  });

  group('TextListSearch Provider', () {
    test('returns data when search term is empty', () {
      final texts = searchTexts('');

      expect(texts, contains(container.read(textProvider(testTextId))));
      
      // Verify text-content-1 is in the results
      final textContent1 = texts.firstWhere(
        (text) => text.id == testTextId,
        orElse: () => throw Exception('text-content-1 not found'),
      );
      
      expect(textContent1.title, equals('Welcome to Zoe!'));
    });
  
    test('returns data when searching for "welcome"', () {
      final texts = searchTexts('welcome');

      expect(texts.length, greaterThanOrEqualTo(1));
      
      // Find text-content-1 in the results
      final textContent1 = texts.firstWhere(
        (text) => text.id == testTextId,
        orElse: () => throw Exception('text-content-1 not found'),
      );
      
      expect(textContent1.title, equals('Welcome to Zoe!'));
    });

    test('returns data when searching for "zoe"', () {
      final texts = searchTexts('zoe');

      expect(texts.length, greaterThanOrEqualTo(1));
      
      // Find text-content-1 in the results
      final textContent1 = texts.firstWhere(
        (text) => text.id == testTextId,
        orElse: () => throw Exception('text-content-1 not found'),
      );
      
      expect(textContent1.title, equals('Welcome to Zoe!'));
    });

    test('returns empty list when searching for text not in data', () {
      final texts = searchTexts('nonexistent');

      expect(texts, isEmpty);
    });
  });

  group('SortedTexts Provider', () {
    test('data appears in sorted list', () {
      final sortedTexts = getSortedTexts();

      // Find text-content-1 in the sorted list
      final textContent1 = sortedTexts.firstWhere(
        (text) => text.id == testTextId,
        orElse: () => throw Exception('text-content-1 not found'),
      );
      
      expect(textContent1.title, equals('Welcome to Zoe!'));
    });

    test('data maintains position when new text is added', () {
      // Add new text with title that would be first alphabetically
      final newText = textList.first.copyWith(
        sheetId: 'sheet-2',
        parentId: 'sheet-2',
        id: 'alphabetical-first',
        title: 'A First Alphabetical Text',
        emoji: '🔤',
      );
      container.read(textListProvider.notifier).addText(newText);

      final sortedTexts = getSortedTexts();

      // Verify new text is first
      expect(sortedTexts[0].title, equals('A First Alphabetical Text'));
      
      // Verify text-content-1 is still in the list
      final textContent1 = sortedTexts.firstWhere(
        (text) => text.id == testTextId,
        orElse: () => throw Exception('text-content-1 not found'),
      );
      
      expect(textContent1.title, equals('Welcome to Zoe!'));
    });
  });
}
