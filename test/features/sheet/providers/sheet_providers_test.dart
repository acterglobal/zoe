import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/common/providers/common_providers.dart';

void main() {
  group('Sheet Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
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
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🧪'),
        );

        notifier.addSheet(newSheet);

        final updatedList = container.read(sheetListProvider);
        expect(updatedList.length, equals(initialLength + 1));
        expect(updatedList.last.id, equals('test-sheet'));
        expect(updatedList.last.title, equals('Test Sheet'));
        expect(updatedList.last.sheetAvatar.data, equals('🧪'));
      });

      test('deleteSheet removes sheet from list', () {
        final notifier = container.read(sheetListProvider.notifier);
        final initialList = container.read(sheetListProvider);
        final initialLength = initialList.length;

        // Add a test sheet first
        final testSheet = SheetModel(
          id: 'delete-test-sheet',
          title: 'Delete Test Sheet',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🗑️'),
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
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📝'),
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
        expect(
          updatedSheet.sheetAvatar.data,
          equals('📝'),
        ); // Other properties unchanged
      });

      test('updateSheetDescription updates sheet description', () {
        final notifier = container.read(sheetListProvider.notifier);

        // Add a test sheet
        final testSheet = SheetModel(
          id: 'desc-test-sheet',
          title: 'Description Test',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
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
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        notifier.addSheet(testSheet);

        // Update the emoji
        notifier.updateSheetAvatar(
          sheetId: 'emoji-test-sheet',
          type: AvatarType.emoji,
          data: '🎉',
        );

        // Verify the emoji was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'emoji-test-sheet',
        );
        expect(updatedSheet.sheetAvatar.data, equals('🎉'));
        expect(
          updatedSheet.title,
          equals('Emoji Test'),
        ); // Other properties unchanged
      });

      test('updateSheetTitle does not affect other sheets', () {
        final notifier = container.read(sheetListProvider.notifier);

        // Add two test sheets
        final sheet1 = SheetModel(
          id: 'sheet1',
          title: 'Sheet 1',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        final sheet2 = SheetModel(
          id: 'sheet2',
          title: 'Sheet 2',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
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

      test('updateSheetIconAndColor updates sheet icon and color', () {
        final notifier = container.read(sheetListProvider.notifier);

        // Add a test sheet
        final title = 'Icon Color Test';
        final testSheet = SheetModel(
          title: title,
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        notifier.addSheet(testSheet);

        // Update the icon and color
        final newIcon = ZoeIcon.car;
        final newColor = Colors.blue;
        notifier.updateSheetAvatar(
          sheetId: testSheet.id,
          type: AvatarType.icon,
          data: newIcon.name,
          color: newColor,
        );

        // Verify the icon and color were updated
        final updatedSheet = container.read(sheetProvider(testSheet.id));
        expect(updatedSheet?.sheetAvatar.data, equals(newIcon.name));
        expect(updatedSheet?.sheetAvatar.color, equals(newColor));
        expect(updatedSheet?.title, equals(title));
      });

      test('updateSheetIconAndColor does not affect other sheets', () {
        final notifier = container.read(sheetListProvider.notifier);

        // Add two test sheets
        final sheet1 = SheetModel(
          sheetAvatar: SheetAvatar(
            type: AvatarType.icon,
            data: ZoeIcon.book.name,
            color: Colors.red,
          ),
        );
        final sheet2 = SheetModel(
          sheetAvatar: SheetAvatar(
            type: AvatarType.icon,
            data: ZoeIcon.calendar.name,
            color: Colors.green,
          ),
        );
        notifier.addSheet(sheet1);
        notifier.addSheet(sheet2);

        // Update only sheet1
        notifier.updateSheetAvatar(
          sheetId: sheet1.id,
          type: AvatarType.icon,
          data: ZoeIcon.car.name,
          color: Colors.blue,
        );

        // Verify only sheet1 was updated
        final updatedSheet1 = container.read(sheetProvider(sheet1.id));
        expect(updatedSheet1?.sheetAvatar.data, equals(ZoeIcon.car.name));
        expect(updatedSheet1?.sheetAvatar.type, equals(AvatarType.icon));
        expect(updatedSheet1?.sheetAvatar.color, equals(Colors.blue));

        final unchangedSheet2 = container.read(sheetProvider(sheet2.id));
        expect(
          unchangedSheet2?.sheetAvatar.data,
          equals(ZoeIcon.calendar.name),
        );
        expect(unchangedSheet2?.sheetAvatar.type, equals(AvatarType.icon));
        expect(unchangedSheet2?.sheetAvatar.color, equals(Colors.green));
      });

      test('updateSheetAvatarImage updates sheet avatar image', () {
        final notifier = container.read(sheetListProvider.notifier);

        // Add a test sheet
        final title = 'Image Test';
        final testSheet = SheetModel(
          title: title,
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        notifier.addSheet(testSheet);

        // Update the avatar image
        const newImage = 'https://example.com/image.png';
        notifier.updateSheetAvatar(
          sheetId: testSheet.id,
          type: AvatarType.image,
          data: newImage,
        );

        // Verify the image was updated
        final updatedSheet = container.read(sheetProvider(testSheet.id));

        expect(updatedSheet?.sheetAvatar.data, equals(newImage));
        expect(updatedSheet?.sheetAvatar.type, equals(AvatarType.image));
        expect(updatedSheet?.title, equals(title));
      });

      test('updateSheetAvatarImage does not affect other sheets', () {
        final notifier = container.read(sheetListProvider.notifier);

        // Add two test sheets
        final sheet1 = SheetModel(
          sheetAvatar: SheetAvatar(type: AvatarType.image, data: 'image1.png'),
        );
        final sheet2 = SheetModel(
          sheetAvatar: SheetAvatar(type: AvatarType.image, data: 'image2.png'),
        );
        notifier.addSheet(sheet1);
        notifier.addSheet(sheet2);

        // Update only sheet1
        notifier.updateSheetAvatar(
          sheetId: sheet1.id,
          type: AvatarType.image,
          data: 'updated-image1.png',
        );

        // Verify only sheet1 was updated
        final updatedSheet1 = container.read(sheetProvider(sheet1.id));
        final unchangedSheet2 = container.read(sheetProvider(sheet2.id));

        expect(updatedSheet1?.sheetAvatar.data, equals('updated-image1.png'));
        expect(unchangedSheet2?.sheetAvatar.data, equals('image2.png'));
      });
    });

    group('sheetListSearch Provider', () {
      test('returns all sheets when search is empty', () {
        final searchResults = container.read(sheetListSearchProvider);
        final allSheets = container.read(sheetListProvider);

        expect(searchResults.length, equals(allSheets.length));
        expect(searchResults, equals(allSheets));
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
        expect(users.contains('user_1'), isTrue);
        expect(users.contains('user_3'), isTrue);
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
        final allSheets = container.read(sheetListProvider);

        expect(sortedSheets.length, equals(allSheets.length));

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
