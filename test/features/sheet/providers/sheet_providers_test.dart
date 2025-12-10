import 'package:cloud_firestore/cloud_firestore.dart';
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

void main() {
  group('SheetList Provider with Firebase', () {
    late ProviderContainer container;
    late FakeFirebaseFirestore fakeFirestore;
    late String testUserId;
    late SheetModel testSheet1;
    late SheetModel testSheet2;
    late SheetList notifier;

    setUp(() async {
      fakeFirestore = FakeFirebaseFirestore();
      testUserId = 'test-user';

      // Add initial data to FakeFirestore
      final sheet1Data = {
        'id': 'sheet-1',
        'title': 'User Sheet 1',
        'users': [testUserId],
        'sheetAvatar': {'type': 'emoji', 'data': '🚀'},
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'sharedBy': null,
        'message': null,
      };
      final sheet2Data = {
        'id': 'sheet-2',
        'title': 'User Sheet 2',
        'users': [testUserId, 'other-user'],
        'sheetAvatar': {'type': 'emoji', 'data': '🌟'},
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'sharedBy': null,
        'message': null,
      };
      await fakeFirestore.collection('sheets').doc('sheet-1').set(sheet1Data);
      await fakeFirestore.collection('sheets').doc('sheet-2').set(sheet2Data);
      await fakeFirestore.collection('sheets').doc('sheet-3').set({
        'id': 'sheet-3',
        'title': 'Another User\'s Sheet',
        'users': ['another-user'],
        'sheetAvatar': {'type': 'emoji', 'data': '🤔'},
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      container = ProviderContainer(
        overrides: [
          firestoreProvider.overrideWithValue(fakeFirestore),
          loggedInUserProvider.overrideWithValue(AsyncValue.data(testUserId)),
        ],
      );

      // Wait for the provider to initialize and fetch data.
      int retries = 0;
      while (container.read(sheetListProvider).length < 2 && retries < 20) {
        await Future.delayed(const Duration(milliseconds: 50));
        retries++;
      }

      final userSheets = container.read(sheetListProvider);
      testSheet1 = userSheets.firstWhere((s) => s.id == 'sheet-1');
      testSheet2 = userSheets.firstWhere((s) => s.id == 'sheet-2');
      notifier = container.read(sheetListProvider.notifier);
    });

    test('filters sheets to the logged-in user', () {
      final userSheets = container.read(sheetListProvider);
      expect(userSheets.length, 2);
      expect(userSheets.every((s) => s.users.contains(testUserId)), isTrue);
    });

    test('addSheet adds new sheet to list', () async {
      final initialLength = container.read(sheetListProvider).length;

      final newSheet = SheetModel(
        id: 'new-test-sheet',
        title: 'New Test Sheet',
        sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🧪'),
      );

      await notifier.addSheet(newSheet);

      final updatedList = container.read(sheetListProvider);
      expect(updatedList.length, equals(initialLength + 1));
      expect(updatedList.any((s) => s.id == 'new-test-sheet'), isTrue);
    });

    test('deleteSheet removes sheet from list', () async {
      final initialLength = container.read(sheetListProvider).length;

      await notifier.deleteSheet(testSheet1.id);

      final updatedList = container.read(sheetListProvider);
      expect(updatedList.length, equals(initialLength - 1));
      expect(updatedList.any((s) => s.id == testSheet1.id), isFalse);
    });

    test('updateSheetTitle updates sheet title', () async {
      await notifier.updateSheetTitle(testSheet1.id, 'Updated Title');

      final updatedSheet = container.read(sheetProvider(testSheet1.id));
      expect(updatedSheet?.title, equals('Updated Title'));
    });

    test('updateSheetTitle does not affect other sheets', () async {
      await notifier.updateSheetTitle(testSheet1.id, 'Updated Sheet 1');

      final updatedSheet1 = container.read(sheetProvider(testSheet1.id));
      final unchangedSheet2 = container.read(sheetProvider(testSheet2.id));

      expect(updatedSheet1?.title, equals('Updated Sheet 1'));
      expect(unchangedSheet2?.title, equals(testSheet2.title));
    });

    test('updateSheetIconAndColor updates sheet icon and color', () async {
      final newIcon = ZoeIcon.car;
      final newColor = Colors.blue;

      await notifier.updateSheetAvatar(
        sheetId: testSheet1.id,
        type: AvatarType.icon,
        data: newIcon.name,
        color: newColor,
      );

      final updatedSheet = container.read(sheetProvider(testSheet1.id));
      expect(updatedSheet?.sheetAvatar.data, equals(newIcon.name));
      expect(updatedSheet?.sheetAvatar.color?.value, equals(newColor.value));
    });

    test('updateSheetTheme updates sheet theme', () async {
      const newPrimary = Colors.purple;
      const newSecondary = Colors.orange;

      await notifier.updateSheetTheme(
        sheetId: testSheet1.id,
        primary: newPrimary,
        secondary: newSecondary,
      );

      final updatedSheet = container.read(sheetProvider(testSheet1.id));
      expect(updatedSheet?.theme?.primary.value, equals(newPrimary.value));
      expect(updatedSheet?.theme?.secondary.value, equals(newSecondary.value));
    });

    test('filters sheets by title when search has value', () {
      container.read(searchValueProvider.notifier).update('User Sheet 1');

      final searchResults = container.read(sheetListSearchProvider);

      expect(searchResults.length, 1);
      expect(searchResults.first.id, testSheet1.id);
    });

    test('updateSheetCoverImage updates sheet cover image', () async {
      const newCoverUrl = 'http://example.com/cover.jpg';
      await notifier.updateSheetCoverImage(testSheet1.id, newCoverUrl);

      final updatedSheet = container.read(sheetProvider(testSheet1.id));
      expect(updatedSheet?.coverImageUrl, equals(newCoverUrl));
    });

    test('updateSheetCoverImage can remove sheet cover image', () async {
      // First set a cover image
      const newCoverUrl = 'http://example.com/cover.jpg';
      await notifier.updateSheetCoverImage(testSheet1.id, newCoverUrl);

      var updatedSheet = container.read(sheetProvider(testSheet1.id));
      expect(updatedSheet?.coverImageUrl, equals(newCoverUrl));

      // Now remove it
      await notifier.updateSheetCoverImage(testSheet1.id, null);
      updatedSheet = container.read(sheetProvider(testSheet1.id));
      expect(updatedSheet?.coverImageUrl, isNull);
    });

    test('updateSheetDescription updates sheet description', () async {
      final newDescription = (
        plainText: 'New description',
        htmlText: '<p>New description</p>',
      );
      await notifier.updateSheetDescription(testSheet1.id, newDescription);

      final updatedSheet = container.read(sheetProvider(testSheet1.id));
      expect(
        updatedSheet?.description?.plainText,
        equals(newDescription.plainText),
      );
      expect(
        updatedSheet?.description?.htmlText,
        equals(newDescription.htmlText),
      );
    });

    test('addUserToSheet adds a user to the sheet', () async {
      const newUser = 'new-user-id';
      await notifier.addUserToSheet(testSheet1.id, newUser);

      final updatedSheet = container.read(sheetProvider(testSheet1.id));
      expect(updatedSheet?.users, contains(newUser));
      expect(updatedSheet?.users.length, 2);
    });

    test('updateSheetShareInfo updates sharing information', () async {
      const sharedBy = 'sharer-id';
      const message = 'Check this out!';
      await notifier.updateSheetShareInfo(
        sheetId: testSheet1.id,
        sharedBy: sharedBy,
        message: message,
      );

      final updatedSheet = container.read(sheetProvider(testSheet1.id));
      expect(updatedSheet?.sharedBy, equals(sharedBy));
      expect(updatedSheet?.message, equals(message));
    });

    test('sheetProvider returns the correct sheet', () {
      final sheet = container.read(sheetProvider(testSheet1.id));
      expect(sheet, isNotNull);
      expect(sheet?.id, testSheet1.id);
    });

    test('sheetProvider returns null for non-existent sheet', () {
      final sheet = container.read(sheetProvider('non-existent-id'));
      expect(sheet, isNull);
    });

    test('listOfUsersBySheetId returns users for a sheet', () {
      final users = container.read(listOfUsersBySheetIdProvider(testSheet2.id));
      expect(users, containsAll([testUserId, 'other-user']));
      expect(users.length, 2);
    });

    test('listOfUsersBySheetId returns empty list for non-existent sheet', () {
      final users = container.read(
        listOfUsersBySheetIdProvider('non-existent-id'),
      );
      expect(users, isEmpty);
    });

    test('sheetExists returns true for an existing sheet', () {
      final exists = container.read(sheetExistsProvider(testSheet1.id));
      expect(exists, isTrue);
    });

    test('sheetExists returns false for a non-existent sheet', () {
      final exists = container.read(sheetExistsProvider('non-existent-id'));
      expect(exists, isFalse);
    });

    test('sortedSheets returns sheets sorted by title', () async {
      // Add a sheet to ensure sorting is needed
      final newSheet = SheetModel(
        id: 'aaa-sheet',
        title: 'AAA Sheet',
        sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🥇'),
        users: [testUserId],
      );
      await notifier.addSheet(newSheet);

      // Need to wait for the provider to update
      await Future.delayed(const Duration(milliseconds: 50));

      final sorted = container.read(sortedSheetsProvider);

      expect(sorted.length, 3);
      expect(sorted[0].title, 'AAA Sheet');
      expect(sorted[1].title, 'User Sheet 1');
      expect(sorted[2].title, 'User Sheet 2');
    });
  });
}
