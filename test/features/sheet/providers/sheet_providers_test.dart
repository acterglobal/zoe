import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

import '../../users/utils/users_utils.dart';
import '../utils/sheet_utils.dart';

void main() {
  group('SheetList Provider with Firebase', () {
    late ProviderContainer container;
    late FakeFirebaseFirestore fakeFirestore;
    late String testUserId;
    setUp(() async {
      fakeFirestore = FakeFirebaseFirestore();
      testUserId = 'test-user';

      // Add initial data to FakeFirestore
      await fakeFirestore.collection('sheets').doc('sheet-1').set({
        'id': 'sheet-1',
        'title': 'User Sheet 1',
        'users': [testUserId],
        'sheetAvatar': {'type': 'emoji', 'data': '🚀'},
      });
      await fakeFirestore.collection('sheets').doc('sheet-2').set({
        'id': 'sheet-2',
        'title': 'User Sheet 2',
        'users': [testUserId, 'other-user'],
        'sheetAvatar': {'type': 'emoji', 'data': '🌟'},
      });
      await fakeFirestore.collection('sheets').doc('sheet-3').set({
        'id': 'sheet-3',
        'title': 'Another User\'s Sheet',
        'users': ['another-user'],
        'sheetAvatar': {'type': 'emoji', 'data': '🤔'},
      });

      container = ProviderContainer(
        overrides: [
          firestoreProvider.overrideWithValue(fakeFirestore),
          loggedInUserProvider.overrideWithValue(AsyncValue.data(testUserId)),
        ],
      );
    });
    group('Sheet Providers', () {
      late ProviderContainer container;
      late String testUserId;
      late SheetModel testSheet;

      setUp(() async {
        container = ProviderContainer.test();

        testUserId = getUserByIndex(container).id;
        
        // Create and populate fake firestore
        final fakeFirestore = FakeFirebaseFirestore();
        await fakeFirestore.collection('sheets').doc('test-sheet').set({
          'id': 'test-sheet',
          'title': 'Test Sheet',
          'users': [testUserId],
          'sheetAvatar': {'type': 'emoji', 'data': '🧪'},
        });

        container = ProviderContainer.test(
          overrides: [
            loggedInUserProvider.overrideWithValue(AsyncValue.data(testUserId)),
            firestoreProvider.overrideWithValue(fakeFirestore),
          ],
        );

        // Wait for provider to initialize and fetch data
        container.read(sheetListProvider);
        int retries = 0;
        while (container.read(sheetListProvider).isEmpty && retries < 20) {
          await Future.delayed(const Duration(milliseconds: 50));
          retries++;
        }

        testSheet = getSheetByIndex(container);
      });

      group('SheetList Provider', () {

        test('addSheet adds new sheet to list', () async {
          final notifier = container.read(sheetListProvider.notifier);
          final initialLength = container.read(sheetListProvider).length;

          final newSheet = SheetModel(
            id: 'new-test-sheet',
            title: 'New Test Sheet',
            sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🧪'),
          );

          await notifier.addSheet(newSheet);

          final updatedList = container.read(sheetListProvider);
          expect(updatedList.length, equals(initialLength + 1));
          expect(updatedList.last.id, equals('new-test-sheet'));
          expect(updatedList.last.title, equals('New Test Sheet'));
          expect(updatedList.last.sheetAvatar.data, equals('🧪'));
        });

        test('deleteSheet removes sheet from list', () async {
          final notifier = container.read(sheetListProvider.notifier);
          final initialLength = container.read(sheetListProvider).length;

          // Delete the test sheet
          await notifier.deleteSheet(testSheet.id);

          // Verify it was removed
          final updatedList = container.read(sheetListProvider);
          expect(updatedList.length, equals(initialLength - 1));
          expect(updatedList.any((s) => s.id == testSheet.id), isFalse);
        });

        test('updateSheetTitle updates sheet title', () async {
          final notifier = container.read(sheetListProvider.notifier);

          // Update the title
          await notifier.updateSheetTitle(testSheet.id, 'Updated Title');

          // Verify the title was updated
          final updatedList = container.read(sheetListProvider);
          final updatedSheet = updatedList.firstWhere(
            (s) => s.id == testSheet.id,
          );
          expect(updatedSheet.title, equals('Updated Title'));
          expect(
            updatedSheet.sheetAvatar.data,
            equals(testSheet.sheetAvatar.data),
          ); // Other properties unchanged
        });

        test('updateSheetDescription updates sheet description', () async {
          final notifier = container.read(sheetListProvider.notifier);

          // Update the description
          final newDescription = (
            plainText: 'New plain text description',
            htmlText: '<p>New <strong>HTML</strong> description</p>',
          );
          await notifier.updateSheetDescription(testSheet.id, newDescription);

          // Verify the description was updated
          final updatedList = container.read(sheetListProvider);
          final updatedSheet = updatedList.firstWhere(
            (s) => s.id == testSheet.id,
          );
          expect(
            updatedSheet.description?.plainText,
            equals('New plain text description'),
          );
          expect(
            updatedSheet.description?.htmlText,
            equals('<p>New <strong>HTML</strong> description</p>'),
          );
        });

        test('updateSheetEmoji updates sheet emoji', () async {
          final notifier = container.read(sheetListProvider.notifier);

          // Update the emoji
          await notifier.updateSheetAvatar(
            sheetId: testSheet.id,
            type: AvatarType.emoji,
            data: '🎉',
          );

          // Verify the emoji was updated
          final updatedList = container.read(sheetListProvider);
          final updatedSheet = updatedList.firstWhere(
            (s) => s.id == testSheet.id,
          );
          expect(updatedSheet.sheetAvatar.data, equals('🎉'));
        });

        test('updateSheetTitle does not affect other sheets', () async {
          final notifier = container.read(sheetListProvider.notifier);

          // Get a second test sheet
          final sheet2 = getSheetByIndex(container, index: 1);

          // Update only first sheet
          await notifier.updateSheetTitle(testSheet.id, 'Updated Sheet 1');

          // Verify only testSheet was updated
          final updatedList = container.read(sheetListProvider);
          final updatedSheet1 = updatedList.firstWhere(
            (s) => s.id == testSheet.id,
          );
          final unchangedSheet2 = updatedList.firstWhere(
            (s) => s.id == sheet2.id,
          );

          expect(updatedSheet1.title, equals('Updated Sheet 1'));
          expect(unchangedSheet2.title, equals(sheet2.title));
        });

        test('updateSheetIconAndColor updates sheet icon and color', () async {
          final notifier = container.read(sheetListProvider.notifier);

          final originalTitle = testSheet.title;

          // Update the icon and color
          final newIcon = ZoeIcon.car;
          final newColor = Colors.blue;
          await notifier.updateSheetAvatar(
            sheetId: testSheet.id,
            type: AvatarType.icon,
            data: newIcon.name,
            color: newColor,
          );

          // Verify the icon and color were updated
          final updatedSheet = container.read(sheetProvider(testSheet.id));
          expect(updatedSheet?.sheetAvatar.data, equals(newIcon.name));
          expect(updatedSheet?.sheetAvatar.color, equals(newColor));
          expect(updatedSheet?.title, equals(originalTitle));
        });

        test('updateSheetIconAndColor does not affect other sheets', () async {
          final notifier = container.read(sheetListProvider.notifier);

          // Get two test sheets
          final sheet1 = testSheet;
          final sheet2 = getSheetByIndex(container, index: 1);

          // Update only sheet1
          await notifier.updateSheetAvatar(
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
            equals(sheet2.sheetAvatar.data),
          );
          expect(
            unchangedSheet2?.sheetAvatar.type,
            equals(sheet2.sheetAvatar.type),
          );
        });

        test('updateSheetAvatarImage updates sheet avatar image', () async {
          final notifier = container.read(sheetListProvider.notifier);

          final originalTitle = testSheet.title;

          // Update the avatar image
          const newImage = 'https://example.com/image.png';
          await notifier.updateSheetAvatar(
            sheetId: testSheet.id,
            type: AvatarType.image,
            data: newImage,
          );

          // Verify the image was updated
          final updatedSheet = container.read(sheetProvider(testSheet.id));

          expect(updatedSheet?.sheetAvatar.data, equals(newImage));
          expect(updatedSheet?.sheetAvatar.type, equals(AvatarType.image));
          expect(updatedSheet?.title, equals(originalTitle));
        });

        test('updateSheetAvatarImage does not affect other sheets', () async {
          final notifier = container.read(sheetListProvider.notifier);

          // Get two test sheets
          final sheet1 = testSheet;
          final sheet2 = getSheetByIndex(container, index: 1);

          // Update only sheet1
          await notifier.updateSheetAvatar(
            sheetId: sheet1.id,
            type: AvatarType.image,
            data: 'updated-image1.png',
          );

          // Verify only sheet1 was updated
          final updatedSheet1 = container.read(sheetProvider(sheet1.id));
          final unchangedSheet2 = container.read(sheetProvider(sheet2.id));

          expect(updatedSheet1?.sheetAvatar.data, equals('updated-image1.png'));
          expect(
            unchangedSheet2?.sheetAvatar.data,
            equals(sheet2.sheetAvatar.data),
          );
        });

        test(
          'updateSheetShareInfo updates both sharedBy and message',
          () async {
            final notifier = container.read(sheetListProvider.notifier);

            // Update share info
            const sharedBy = 'John Doe';
            const message = 'Check out this amazing sheet!';
            await notifier.updateSheetShareInfo(
              sheetId: testSheet.id,
              sharedBy: sharedBy,
              message: message,
            );

            // Verify the share info was updated
            final updatedSheet = container.read(sheetProvider(testSheet.id));
            expect(updatedSheet?.sharedBy, equals(sharedBy));
            expect(updatedSheet?.message, equals(message));
          },
        );

        test(
          'updateSheetShareInfo updates only sharedBy when message is null',
          () async {
            final notifier = container.read(sheetListProvider.notifier);

            // Update only sharedBy
            const sharedBy = 'Jane Smith';
            await notifier.updateSheetShareInfo(
              sheetId: testSheet.id,
              sharedBy: sharedBy,
              message: null,
            );

            // Verify only sharedBy was updated
            final updatedSheet = container.read(sheetProvider(testSheet.id));
            expect(updatedSheet?.sharedBy, equals(sharedBy));
            expect(updatedSheet?.message, isNull);
          },
        );

        test(
          'updateSheetShareInfo updates only message when sharedBy is null',
          () async {
            final notifier = container.read(sheetListProvider.notifier);

            // Update only message
            const message = 'This is a great sheet to collaborate on!';
            await notifier.updateSheetShareInfo(
              sheetId: testSheet.id,
              sharedBy: null,
              message: message,
            );

            // Verify only message was updated
            final updatedSheet = container.read(sheetProvider(testSheet.id));
            expect(updatedSheet?.sharedBy, isNull);
            expect(updatedSheet?.message, equals(message));
          },
        );

        test('updateSheetShareInfo does not affect other sheets', () async {
          final notifier = container.read(sheetListProvider.notifier);

          // Get two test sheets
          final sheet1 = testSheet;
          final sheet2 = getSheetByIndex(container, index: 1);

          // Update only sheet1
          await notifier.updateSheetShareInfo(
            sheetId: sheet1.id,
            sharedBy: 'User 1',
            message: 'Message 1',
          );

          // Verify only sheet1 was updated
          final updatedSheet1 = container.read(sheetProvider(sheet1.id));
          final unchangedSheet2 = container.read(sheetProvider(sheet2.id));

          expect(updatedSheet1?.sharedBy, equals('User 1'));
          expect(updatedSheet1?.message, equals('Message 1'));
          expect(unchangedSheet2?.sharedBy, equals(sheet2.sharedBy));
          expect(unchangedSheet2?.message, equals(sheet2.message));
        });

        test('updateSheetShareInfo handles empty string values', () async {
          final notifier = container.read(sheetListProvider.notifier);

          // Update with empty strings
          await notifier.updateSheetShareInfo(
            sheetId: testSheet.id,
            sharedBy: '',
            message: '',
          );

          // Verify empty strings are stored (not null)
          final updatedSheet = container.read(sheetProvider(testSheet.id));
          expect(updatedSheet?.sharedBy, equals(''));
          expect(updatedSheet?.message, equals(''));
        });

        test('addSheet applies default theme if not provided', () async {
          final notifier = container.read(sheetListProvider.notifier);
          final initialLength = container.read(sheetListProvider).length;

          final newSheet = SheetModel(
            id: 'no-theme-sheet',
            title: 'No Theme Sheet',
            sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🎨'),
            theme: null, // Explicitly null
          );

          await notifier.addSheet(newSheet);

          final updatedList = container.read(sheetListProvider);
          expect(updatedList.length, equals(initialLength + 1));

          final addedSheet = updatedList.firstWhere(
            (s) => s.id == 'no-theme-sheet',
          );
          expect(addedSheet.theme, isNotNull);
        });

        test('updateSheetTheme updates sheet theme', () async {
          final notifier = container.read(sheetListProvider.notifier);

          // Update the theme
          const newPrimary = Colors.purple;
          const newSecondary = Colors.orange;

          await notifier.updateSheetTheme(
            sheetId: testSheet.id,
            primary: newPrimary,
            secondary: newSecondary,
          );

          // Verify the theme was updated
          final updatedSheet = container.read(sheetProvider(testSheet.id));
          expect(updatedSheet?.theme?.primary, equals(newPrimary));
          expect(updatedSheet?.theme?.secondary, equals(newSecondary));
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
          container
              .read(searchValueProvider.notifier)
              .update('Getting Started');

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
          container.read(searchValueProvider.notifier).update('TEST');

          final searchResults = container.read(sheetListSearchProvider);

          expect(searchResults.isNotEmpty, isTrue);
          expect( 
            searchResults.every(
              (s) => s.title.toLowerCase().contains('test'),
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
          final sheet = container.read(sheetProvider(testSheet.id));

          expect(sheet, isNotNull);
          expect(sheet!.id, equals(testSheet.id));
          expect(sheet.title, equals(testSheet.title));
        });

        test('returns null when ID does not exist', () {
          final sheet = container.read(sheetProvider('nonexistent-id'));

          expect(sheet, isNull);
        });
      });

      group('listOfUsersBySheetId Provider', () {
        test('returns users list when sheet exists', () {
          final users = container.read(
            listOfUsersBySheetIdProvider(testSheet.id),
          );

          expect(users, isA<List<String>>());
          expect(users, equals(testSheet.users));
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
          final exists = container.read(sheetExistsProvider(testSheet.id));

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
          final sheet = container.read(sheetProvider(testSheet.id));
          final users = container.read(
            listOfUsersBySheetIdProvider(testSheet.id),
          );
          final exists = container.read(sheetExistsProvider(testSheet.id));
          final sorted = container.read(sortedSheetsProvider);

          expect(sheetList, isA<List<SheetModel>>());
          expect(searchResults, isA<List<SheetModel>>());
          expect(sheet, isA<SheetModel?>());
          expect(users, isA<List<String>>());
          expect(exists, isA<bool>());
          expect(sorted, isA<List<SheetModel>>());
        });
      });
    });

    test('build fetches only the current user\'s sheets', () async {
      // Trigger build
      container.read(sheetListProvider);
      
      // Wait for data to load
      int retries = 0;
      while (container.read(sheetListProvider).isEmpty && retries < 20) {
        await Future.delayed(const Duration(milliseconds: 50));
        retries++;
      }
      
      final sheetList = container.read(sheetListProvider);

      expect(sheetList.length, 2);
      expect(sheetList.any((s) => s.id == 'sheet-1'), isTrue);
      expect(sheetList.any((s) => s.id == 'sheet-2'), isTrue);
      expect(sheetList.any((s) => s.id == 'sheet-3'), isFalse);
    });

    test('addSheet creates a new document in Firestore', () async {
      final notifier = container.read(sheetListProvider.notifier);
      final newSheet = SheetModel(
        id: 'new-firebase-sheet',
        title: 'New Firebase Sheet',
        sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🔥'),
      );

      await notifier.addSheet(newSheet);

      // Verify in Firestore
      final doc = await fakeFirestore
          .collection('sheets')
          .doc('new-firebase-sheet')
          .get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['title'], 'New Firebase Sheet');
      expect(doc.data()?['users'], contains(testUserId));
    });

    test('deleteSheet removes the document from Firestore', () async {
      final notifier = container.read(sheetListProvider.notifier);

      await notifier.deleteSheet('sheet-1');

      // Verify in Firestore
      final doc = await fakeFirestore.collection('sheets').doc('sheet-1').get();
      expect(doc.exists, isFalse);
    });

    test('updateSheetTitle updates the document in Firestore', () async {
      final notifier = container.read(sheetListProvider.notifier);

      await notifier.updateSheetTitle('sheet-1', 'Updated Firestore Title');

      // Verify in Firestore
      final doc = await fakeFirestore.collection('sheets').doc('sheet-1').get();
      expect(doc.data()?['title'], 'Updated Firestore Title');
      expect(doc.data()?['updatedAt'], isNotNull);
    });
  });
}
