import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../../users/utils/users_utils.dart';

void main() {
  group('Sheet Providers', () {
    late ProviderContainer container;
    late String testUserId;

    setUp(() {
      container = ProviderContainer.test();
      testUserId = getUserByIndex(container).id;
      // Create the actual container with the user override
      container = ProviderContainer.test(
        overrides: [
          // Override loggedInUserProvider with a user that exists in test sheets
          loggedInUserProvider.overrideWithValue(AsyncValue.data(testUserId)),
        ],
      );
    });

    group('SheetList Provider', () {
      test('initial state contains sheet data', () {
        final sheetList = container.read(sheetListProvider);

        expect(sheetList, isA<List<SheetModel>>());
        expect(sheetList.isNotEmpty, isTrue);
      });

      test('addSheet adds new sheet to list', () {
        final notifier = container.read(sheetListProvider.notifier);
        final initialLength = container.read(sheetListProvider).length;

        final newSheet = SheetModel(
          id: 'test-sheet',
          title: 'Test Sheet',
          emoji: '🧪',
        );

        notifier.addSheet(newSheet);

        final updatedList = container.read(sheetListProvider);
        expect(updatedList.length, equals(initialLength + 1));
        expect(updatedList.last.id, equals('test-sheet'));
        expect(updatedList.last.title, equals('Test Sheet'));
        expect(updatedList.last.emoji, equals('🧪'));
      });

      test('deleteSheet removes sheet from list', () {
        final notifier = container.read(sheetListProvider.notifier);
        final initialList = container.read(sheetListProvider);
        final initialLength = initialList.length;

        // Add a test sheet first
        final testSheet = SheetModel(
          id: 'delete-test-sheet',
          title: 'Delete Test Sheet',
          emoji: '🗑️',
        );
        notifier.addSheet(testSheet);

        // Verify it was added
        expect(
          container.read(sheetListProvider).length,
          equals(initialLength + 1),
        );

        // Delete the sheet
        notifier.deleteSheet('delete-test-sheet');

        // Verify it was removed
        final updatedList = container.read(sheetListProvider);
        expect(updatedList.length, equals(initialLength));
        expect(updatedList.any((s) => s.id == 'delete-test-sheet'), isFalse);
      });

      test('updateSheetTitle updates sheet title', () {
        final notifier = container.read(sheetListProvider.notifier);

        // Add a test sheet
        final testSheet = SheetModel(
          id: 'title-test-sheet',
          title: 'Original Title',
          emoji: '📝',
        );
        notifier.addSheet(testSheet);

        // Update the title
        notifier.updateSheetTitle('title-test-sheet', 'Updated Title');

        // Verify the title was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'title-test-sheet',
        );
        expect(updatedSheet.title, equals('Updated Title'));
        expect(updatedSheet.emoji, equals('📝')); // Other properties unchanged
      });

      test('updateSheetDescription updates sheet description', () {
        final notifier = container.read(sheetListProvider.notifier);

        // Add a test sheet
        final testSheet = SheetModel(
          id: 'desc-test-sheet',
          title: 'Description Test',
          emoji: '📄',
        );
        notifier.addSheet(testSheet);

        // Update the description
        final newDescription = (
          plainText: 'New plain text description',
          htmlText: '<p>New <strong>HTML</strong> description</p>',
        );
        notifier.updateSheetDescription('desc-test-sheet', newDescription);

        // Verify the description was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'desc-test-sheet',
        );
        expect(
          updatedSheet.description?.plainText,
          equals('New plain text description'),
        );
        expect(
          updatedSheet.description?.htmlText,
          equals('<p>New <strong>HTML</strong> description</p>'),
        );
        expect(
          updatedSheet.title,
          equals('Description Test'),
        ); // Other properties unchanged
      });

      test('updateSheetEmoji updates sheet emoji', () {
        final notifier = container.read(sheetListProvider.notifier);

        // Add a test sheet
        final testSheet = SheetModel(
          id: 'emoji-test-sheet',
          title: 'Emoji Test',
          emoji: '📄',
        );
        notifier.addSheet(testSheet);

        // Update the emoji
        notifier.updateSheetEmoji('emoji-test-sheet', '🎉');

        // Verify the emoji was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'emoji-test-sheet',
        );
        expect(updatedSheet.emoji, equals('🎉'));
        expect(
          updatedSheet.title,
          equals('Emoji Test'),
        ); // Other properties unchanged
      });

      test('updateSheetTitle does not affect other sheets', () {
        final notifier = container.read(sheetListProvider.notifier);

        // Add two test sheets
        final sheet1 = SheetModel(id: 'sheet1', title: 'Sheet 1', emoji: '📄');
        final sheet2 = SheetModel(id: 'sheet2', title: 'Sheet 2', emoji: '📄');
        notifier.addSheet(sheet1);
        notifier.addSheet(sheet2);

        // Update only sheet1
        notifier.updateSheetTitle('sheet1', 'Updated Sheet 1');

        // Verify only sheet1 was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet1 = updatedList.firstWhere((s) => s.id == 'sheet1');
        final unchangedSheet2 = updatedList.firstWhere((s) => s.id == 'sheet2');

        expect(updatedSheet1.title, equals('Updated Sheet 1'));
        expect(unchangedSheet2.title, equals('Sheet 2'));
      });
    });

    group('sheetListSearch Provider', () {
      test('returns all sheets when search is empty', () {
        final searchResults = container.read(sheetListSearchProvider);
        // sheetListSearchProvider filters by logged-in user membership
        // Get sheets that the test user is a member of
        final allSheets = container.read(sheetListProvider);
        final userSheets = allSheets
            .where((s) => s.users.contains(testUserId))
            .toList();

        expect(searchResults.length, equals(userSheets.length));
      });

      test('filters sheets by title when search has value', () {
        // Set search value
        container.read(searchValueProvider.notifier).update('Getting Started');

        final searchResults = container.read(sheetListSearchProvider);

        expect(searchResults.isNotEmpty, isTrue);
        expect(
          searchResults.every(
            (s) => s.title.toLowerCase().contains('getting started'),
          ),
          isTrue,
        );
      });

      test('search is case insensitive', () {
        // Set search value with different case
        container.read(searchValueProvider.notifier).update('CHRISTMAS');

        final searchResults = container.read(sheetListSearchProvider);

        expect(searchResults.isNotEmpty, isTrue);
        expect(
          searchResults.every(
            (s) => s.title.toLowerCase().contains('christmas'),
          ),
          isTrue,
        );
      });

      test('returns empty list when no matches found', () {
        // Set search value that won't match any sheet
        container.read(searchValueProvider.notifier).update('nonexistent');

        final searchResults = container.read(sheetListSearchProvider);

        expect(searchResults, isEmpty);
      });
    });

    group('sheet Provider', () {
      test('returns sheet when ID exists', () {
        final sheet = container.read(sheetProvider('sheet-1'));

        expect(sheet, isNotNull);
        expect(sheet!.id, equals('sheet-1'));
        expect(sheet.title, equals('Getting Started Guide'));
      });

      test('returns null when ID does not exist', () {
        final sheet = container.read(sheetProvider('nonexistent-id'));

        expect(sheet, isNull);
      });
    });

    group('listOfUsersBySheetId Provider', () {
      test('returns users list when sheet exists', () {
        final users = container.read(listOfUsersBySheetIdProvider('sheet-1'));

        expect(users, isA<List<String>>());
        expect(users.isNotEmpty, isTrue);
        // Verify the test user is in the sheet's users list
        expect(users.contains(testUserId), isTrue);
      });

      test('returns empty list when sheet does not exist', () {
        final users = container.read(
          listOfUsersBySheetIdProvider('nonexistent-id'),
        );

        expect(users, isEmpty);
      });
    });

    group('sheetExists Provider', () {
      test('returns true when sheet exists', () {
        final exists = container.read(sheetExistsProvider('sheet-1'));

        expect(exists, isTrue);
      });

      test('returns false when sheet does not exist', () {
        final exists = container.read(sheetExistsProvider('nonexistent-id'));

        expect(exists, isFalse);
      });
    });

    group('sortedSheets Provider', () {
      test('returns sheets sorted by title', () {
        final sortedSheets = container.read(sortedSheetsProvider);
        // sortedSheetsProvider filters by logged-in user membership
        // Get sheets that the test user is a member of
        final allSheets = container.read(sheetListProvider);
        final userSheets = allSheets
            .where((s) => s.users.contains(testUserId))
            .toList();

        expect(sortedSheets.length, equals(userSheets.length));

        // Verify they are sorted alphabetically by title
        for (int i = 0; i < sortedSheets.length - 1; i++) {
          expect(
            sortedSheets[i].title.compareTo(sortedSheets[i + 1].title),
            lessThanOrEqualTo(0),
          );
        }
      });

      test('sorting is case sensitive', () {
        final sortedSheets = container.read(sortedSheetsProvider);

        // Check that titles are in alphabetical order
        final titles = sortedSheets.map((s) => s.title).toList();
        final sortedTitles = [...titles]..sort();

        expect(titles, equals(sortedTitles));
      });
    });

    group('Provider Integration', () {
      test('all providers work together', () {
        // Test that all providers can be read without errors
        final sheetList = container.read(sheetListProvider);
        final searchResults = container.read(sheetListSearchProvider);
        final sheet = container.read(sheetProvider('sheet-1'));
        final users = container.read(listOfUsersBySheetIdProvider('sheet-1'));
        final exists = container.read(sheetExistsProvider('sheet-1'));
        final sorted = container.read(sortedSheetsProvider);

        expect(sheetList, isA<List<SheetModel>>());
        expect(searchResults, isA<List<SheetModel>>());
        expect(sheet, isA<SheetModel>());
        expect(users, isA<List<String>>());
        expect(exists, isA<bool>());
        expect(sorted, isA<List<SheetModel>>());
      });
    });
  });
}
