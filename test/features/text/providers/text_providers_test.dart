import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/data/text_list.dart';

void main() {
  late ProviderContainer container;

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
    test('initial state contains textList data', () {
      final textList = getTextList();

      expect(textList, isA<List<TextModel>>());
      expect(textList.length, equals(4)); // Based on text_list.dart
      expect(textList.first.id, equals('text-content-1'));
      expect(textList[1].id, equals('text-content-2'));
      expect(textList[2].id, equals('text-content-3'));
      expect(textList[3].id, equals('text-content-4'));
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

    test('deleteText removes text from the list', () {
      container.read(textListProvider.notifier).deleteText('text-content-2');

      final updatedList = getTextList();
      expect(updatedList.length, equals(3));
      expect(updatedList.any((t) => t.id == 'text-content-2'), isFalse);
    });

    test('updateTextTitle changes title of specific text', () {
      container
          .read(textListProvider.notifier)
          .updateTextTitle('text-content-1', 'Updated Title');

      final updatedList = getTextList();
      final targetText = updatedList.firstWhere(
        (t) => t.id == 'text-content-1',
      );
      expect(targetText.title, equals('Updated Title'));

      // Other texts should remain unchanged
      final otherText = updatedList.firstWhere((t) => t.id == 'text-content-2');
      expect(otherText.title, equals('Understanding Sheets'));
    });

    test('updateTextDescription changes description of specific text', () {
      final newDescription = (
        plainText: 'Updated description content',
        htmlText: '<p>Updated description content</p>',
      );

      container
          .read(textListProvider.notifier)
          .updateTextDescription('text-content-1', newDescription);

      final updatedList = getTextList();
      final targetText = updatedList.firstWhere(
        (t) => t.id == 'text-content-1',
      );
      expect(targetText.description, equals(newDescription));

      // Other texts should remain unchanged
      final otherText = updatedList.firstWhere((t) => t.id == 'text-content-2');
      expect(
        otherText.description?.plainText,
        contains('Sheets are your main workspaces'),
      );
    });

    test('updateTextEmoji changes emoji of specific text', () {
      container
          .read(textListProvider.notifier)
          .updateTextEmoji('text-content-1', '🎉');

      final updatedList = getTextList();
      final targetText = updatedList.firstWhere(
        (t) => t.id == 'text-content-1',
      );
      expect(targetText.emoji, equals('🎉'));

      // Other texts should remain unchanged
      final otherText = updatedList.firstWhere((t) => t.id == 'text-content-2');
      expect(otherText.emoji, equals('📋'));
    });

    test('updateTextOrderIndex changes order index of specific text', () {
      container
          .read(textListProvider.notifier)
          .updateTextOrderIndex('text-content-1', 99);

      final updatedList = getTextList();
      final targetText = updatedList.firstWhere(
        (t) => t.id == 'text-content-1',
      );
      expect(targetText.orderIndex, equals(99));

      // Other texts should remain unchanged
      final otherText = updatedList.firstWhere((t) => t.id == 'text-content-2');
      expect(otherText.orderIndex, equals(2));
    });

    test('multiple operations maintain list integrity', () {
      // Add a text based on existing data
      final newText = textList.first.copyWith(
        id: 'new-text-id',
        title: 'New Text',
        emoji: '🆕',
      );
      container.read(textListProvider.notifier).addText(newText);

      // Update existing text
      container
          .read(textListProvider.notifier)
          .updateTextTitle('text-content-1', 'Modified Title');

      // Delete a text
      container.read(textListProvider.notifier).deleteText('text-content-3');

      final finalList = getTextList();
      expect(finalList.length, equals(4)); // 5 - 1 deleted = 4

      final modifiedText = finalList.firstWhere(
        (t) => t.id == 'text-content-1',
      );
      expect(modifiedText.title, equals('Modified Title'));

      expect(finalList.any((t) => t.id == 'text-content-3'), isFalse);
      expect(finalList.any((t) => t.id == 'new-text-id'), isTrue);
    });
  });

  group('Text Provider (by ID)', () {
    test('returns correct text for existing ID', () {
      final text = getTextById('text-content-1');

      expect(text, isNotNull);
      expect(text!.id, equals('text-content-1'));
      expect(text.title, equals('Welcome to Zoe!'));
      expect(text.emoji, equals('👋'));
    });

    test('returns null for non-existent ID', () {
      final text = getTextById('non-existent-id');

      expect(text, isNull);
    });

    test('updates when textList changes', () {
      // Initial state
      final text1 = container.read(textProvider('text-content-1'));
      expect(text1!.title, equals('Welcome to Zoe!'));

      // Update title
      container
          .read(textListProvider.notifier)
          .updateTextTitle('text-content-1', 'Updated Welcome Title');

      // Check updated state
      final text2 = container.read(textProvider('text-content-1'));
      expect(text2!.title, equals('Updated Welcome Title'));
    });
  });

  group('TextByParent Provider', () {
    test('returns texts filtered by parent ID', () {
      final texts = getTextsByParent('sheet-1');

      expect(texts, isA<List<TextModel>>());
      expect(
        texts.length,
        equals(4),
      ); // All texts in our data have parentId 'sheet-1'

      // Verify all texts have the correct parentId
      for (final text in texts) {
        expect(text.parentId, equals('sheet-1'));
      }
    });

    test('returns empty list for non-existent parent ID', () {
      final texts = getTextsByParent('non-existent-parent');

      expect(texts, isEmpty);
    });

    test('returns texts sorted by orderIndex', () {
      final texts = getTextsByParent('sheet-1');

      expect(texts.length, equals(4));

      // Verify sorting by orderIndex
      expect(texts[0].orderIndex, equals(1));
      expect(texts[1].orderIndex, equals(2));
      expect(texts[2].orderIndex, equals(3));
      expect(texts[3].orderIndex, equals(9));
    });

    test('updates when textList changes', () {
      // Add new text with different parent based on existing data
      final newText = textList.first.copyWith(
        sheetId: 'sheet-2',
        parentId: 'sheet-2',
        id: 'new-parent-text',
        title: 'New Parent Text',
        emoji: '📝',
      );
      container.read(textListProvider.notifier).addText(newText);

      // Check original parent
      final originalParent = container.read(textByParentProvider('sheet-1'));
      expect(originalParent.length, equals(4)); // Should still have 4 texts

      // Check new parent
      final newParent = container.read(textByParentProvider('sheet-2'));
      expect(newParent.length, equals(1)); // Should have 1 text
      expect(newParent.first.id, equals('new-parent-text'));
    });

    test('updates order when orderIndex changes', () {
      // Change orderIndex of one text
      container
          .read(textListProvider.notifier)
          .updateTextOrderIndex('text-content-4', 0);

      final texts = getTextsByParent('sheet-1');

      // Should now be first in sorted list
      expect(texts[0].id, equals('text-content-4'));
      expect(texts[0].orderIndex, equals(0));
    });
  });

  group('TextListSearch Provider', () {
    test('returns all texts when search term is empty', () {
      final texts = searchTexts('');

      expect(texts.length, equals(4));
      expect(texts, contains(container.read(textProvider('text-content-1'))));
      expect(texts, contains(container.read(textProvider('text-content-2'))));
      expect(texts, contains(container.read(textProvider('text-content-3'))));
      expect(texts, contains(container.read(textProvider('text-content-4'))));
    });

    test(
      'returns filtered texts that match search term (case insensitive)',
      () {
        final texts = searchTexts('welcome');

        expect(texts.length, equals(1));
        expect(texts.first.title, equals('Welcome to Zoe!'));
      },
    );

    test('returns filtered texts with partial match', () {
      final texts = searchTexts('sheet');

      expect(texts.length, equals(1));
      expect(texts.first.title, equals('Understanding Sheets'));
    });

    test('returns empty list for no matches', () {
      final texts = searchTexts('nonexistent');

      expect(texts, isEmpty);
    });

    test('search is case insensitive', () {
      final lowerTexts = searchTexts('welcome');
      final upperTexts = searchTexts('WELCOME');

      expect(lowerTexts.length, equals(1));
      expect(upperTexts.length, equals(1));
      expect(lowerTexts.first.title, equals(upperTexts.first.title));
    });

    test('updates when textList changes', () {
      // Add new text based on existing data
      final newText = textList.first.copyWith(
        sheetId: 'sheet-2',
        parentId: 'sheet-2',
        id: 'new-search-text',
        title: 'Welcome to Search',
        emoji: '🔍',
      );
      container.read(textListProvider.notifier).addText(newText);

      // Search for "welcome" should now return 2 results
      final texts = searchTexts('welcome');
      expect(texts.length, equals(2));

      // Both should contain "welcome" in title
      expect(
        texts.every((t) => t.title.toLowerCase().contains('welcome')),
        isTrue,
      );
    });
  });

  group('SortedTexts Provider', () {
    test('returns texts sorted alphabetically by title', () {
      final sortedTexts = getSortedTexts();

      expect(sortedTexts.length, equals(4));

      // Verify alphabetical sorting
      expect(sortedTexts[0].title, equals('Content Block Types'));
      expect(sortedTexts[1].title, equals('Tips for Success'));
      expect(sortedTexts[2].title, equals('Understanding Sheets'));
      expect(sortedTexts[3].title, equals('Welcome to Zoe!'));
    });

    test('updates when textList changes', () {
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

      expect(sortedTexts.length, equals(5));
      expect(sortedTexts[0].title, equals('A First Alphabetical Text'));
    });

    test('handles duplicate titles gracefully', () {
      // Add text with same title as existing
      final newText = textList.first.copyWith(
        sheetId: 'sheet-2',
        parentId: 'sheet-2',
        id: 'duplicate-title',
      );
      container.read(textListProvider.notifier).addText(newText);

      final sortedTexts = getSortedTexts();

      // Should handle duplicates without error
      expect(sortedTexts.length, equals(5));

      // Both texts with same title should be present
      final welcomeTexts = sortedTexts.where(
        (t) => t.title == 'Welcome to Zoe!',
      );
      expect(welcomeTexts.length, equals(2));
    });
  });

  group('Provider Integration Tests', () {
    test('read methods work with listener', () {
      // Test that we can listen to provider changes
      var receivedTexts = <List<TextModel>>[];

      container.listen(textListProvider, (previous, next) {
        receivedTexts.add(next);
      });

      // Trigger updates
      container
          .read(textListProvider.notifier)
          .updateTextTitle('text-content-1', 'Listener Test Title');

      container
          .read(textListProvider.notifier)
          .addText(
            textList.first.copyWith(
              sheetId: 'sheet-2',
              parentId: 'sheet-2',
              id: 'listener-test',
              title: 'Listener Test',
              emoji: '👂',
            ),
          );

      // Verify listener received updates
      expect(receivedTexts.length, equals(2));
      expect(receivedTexts[0].length, equals(4));
      expect(receivedTexts[1].length, equals(5));
    });

    test('derived providers update when base provider updates', () {
      // Get initial values
      final initialSearch = container.read(textListSearchProvider('welcome'));
      final initialSorted = container.read(sortedTextsProvider);

      expect(initialSearch.length, equals(1));
      expect(initialSorted.length, equals(4));

      // Change base provider
      final newText = textList.first.copyWith(
        sheetId: 'sheet-2',
        parentId: 'sheet-2',
        id: 'welcome-derivative',
        title: 'Welcome Aboard',
        emoji: '🚀',
      );
      container.read(textListProvider.notifier).addText(newText);

      // Check derived providers updated
      final updatedSearch = container.read(textListSearchProvider('welcome'));
      final updatedSorted = container.read(sortedTextsProvider);

      expect(
        updatedSearch.length,
        equals(2),
      ); // Should now have 2 "welcome" texts
      expect(updatedSorted.length, equals(5)); // Should now have 5 total texts
    });

    test('error handling for invalid operations', () {
      // These should not throw exceptions
      expect(() {
        container.read(textListProvider.notifier).deleteText('');
      }, returnsNormally);

      expect(() {
        container
            .read(textListProvider.notifier)
            .updateTextTitle('', 'New Title');
      }, returnsNormally);

      expect(() {
        container.read(textListProvider.notifier).updateTextEmoji('', '😀');
      }, returnsNormally);
    });
  });
}
