import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart' as sheet_model;
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

import '../utils/sheet_utils.dart';

void main() {
  group('Sheet Data Updates', () {
    late ProviderContainer container;
    late SheetModel testSheet;

    setUp(() {
      container = ProviderContainer.test();
      testSheet = getSheetByIndex(container);
    });

    // Helper function to test update functions by directly calling provider methods
    void testUpdateTitle(String sheetId, String title) {
      container
          .read(sheetListProvider.notifier)
          .updateSheetTitle(sheetId, title);
    }

    void testUpdateDescription(
      String sheetId,
      sheet_model.Description description,
    ) {
      container.read(sheetListProvider.notifier).updateSheetDescription(
        sheetId,
        (
          plainText: description.plainText ?? '',
          htmlText: description.htmlText ?? '',
        ),
      );
    }

    void testUpdateSheetAvatar({
      required String sheetId,
      required AvatarType type,
      required String data,
      Color? color,
    }) {
      container
          .read(sheetListProvider.notifier)
          .updateSheetAvatar(
            sheetId: sheetId,
            type: type,
            data: data,
            color: color,
          );
    }

    void testUpdateSheetTheme({
      required String sheetId,
      required Color primary,
      required Color secondary,
    }) {
      container
          .read(sheetListProvider.notifier)
          .updateSheetTheme(
            sheetId: sheetId,
            primary: primary,
            secondary: secondary,
          );
    }

    group('updateSheetTitle', () {
      test('updates sheet title successfully', () {
        // Update the title
        testUpdateTitle(testSheet.id, 'Updated Title');

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

      test('handles empty title', () {
        // Update with empty title
        testUpdateTitle(testSheet.id, '');

        // Verify the title was updated to empty
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        expect(updatedSheet.title, equals(''));
      });

      test('handles special characters in title', () {
        // Update with special characters
        const specialTitle = r'Title with @#$%^&*()_+-=[]{}|;:,.<>?';
        testUpdateTitle(testSheet.id, specialTitle);

        // Verify the title was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        expect(updatedSheet.title, equals(specialTitle));
      });

      test('handles very long title', () {
        // Update with very long title
        final longTitle = 'A' * 1000;
        testUpdateTitle(testSheet.id, longTitle);

        // Verify the title was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        expect(updatedSheet.title, equals(longTitle));
        expect(updatedSheet.title.length, equals(1000));
      });

      test('does not affect other sheets', () {
        // Get a second test sheet
        final sheet2 = getSheetByIndex(container, index: 1);

        // Update only first sheet
        testUpdateTitle(testSheet.id, 'Updated Sheet 1');

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
    });

    group('updateSheetDescription', () {
      test('updates sheet description successfully', () {
        // Update the description
        const newDescription = (
          plainText: 'New plain text description',
          htmlText: '<p>New <strong>HTML</strong> description</p>',
        );
        testUpdateDescription(testSheet.id, newDescription);

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

      test('handles null plainText', () {
        // Update with null plainText
        const newDescription = (
          plainText: null,
          htmlText: '<p>HTML only description</p>',
        );
        testUpdateDescription(testSheet.id, newDescription);

        // Verify the description was updated with empty plainText
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        expect(updatedSheet.description?.plainText, equals(''));
        expect(
          updatedSheet.description?.htmlText,
          equals('<p>HTML only description</p>'),
        );
      });

      test('handles null htmlText', () {
        // Update with null htmlText
        const newDescription = (
          plainText: 'Plain text only description',
          htmlText: null,
        );
        testUpdateDescription(testSheet.id, newDescription);

        // Verify the description was updated with empty htmlText
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        expect(
          updatedSheet.description?.plainText,
          equals('Plain text only description'),
        );
        expect(updatedSheet.description?.htmlText, equals(''));
      });

      test('handles both null values', () {
        // Update with both null values
        const newDescription = (plainText: null, htmlText: null);
        testUpdateDescription(testSheet.id, newDescription);

        // Verify the description was updated with empty values
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        expect(updatedSheet.description?.plainText, equals(''));
        expect(updatedSheet.description?.htmlText, equals(''));
      });

      test('handles special characters in description', () {
        // Update with special characters
        const specialDescription = (
          plainText: r'Plain text with @#$%^&*()_+-=[]{}|;:,.<>?',
          htmlText:
              r'<p>HTML with <strong>@#$%^&*()_+-=[]{}|;:,.<>?</strong></p>',
        );
        testUpdateDescription(testSheet.id, specialDescription);

        // Verify the description was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        expect(
          updatedSheet.description?.plainText,
          equals(r'Plain text with @#$%^&*()_+-=[]{}|;:,.<>?'),
        );
        expect(
          updatedSheet.description?.htmlText,
          equals(
            r'<p>HTML with <strong>@#$%^&*()_+-=[]{}|;:,.<>?</strong></p>',
          ),
        );
      });

      test('does not affect other sheets', () {
        // Get a second test sheet
        final sheet2 = getSheetByIndex(container, index: 1);

        // Update only first sheet description
        const newDescription = (
          plainText: 'Updated description for sheet 1',
          htmlText: '<p>Updated description for sheet 1</p>',
        );
        testUpdateDescription(testSheet.id, newDescription);

        // Verify only testSheet was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet1 = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        final unchangedSheet2 = updatedList.firstWhere(
          (s) => s.id == sheet2.id,
        );

        expect(
          updatedSheet1.description?.plainText,
          equals('Updated description for sheet 1'),
        );
        expect(unchangedSheet2.description, equals(sheet2.description));
      });

      test('handles non-existent sheet ID gracefully', () {
        final initialLength = container.read(sheetListProvider).length;

        // Try to update non-existent sheet
        const newDescription = (
          plainText: 'New description',
          htmlText: '<p>New description</p>',
        );
        testUpdateDescription('non-existent-id', newDescription);

        // List should remain unchanged
        expect(container.read(sheetListProvider).length, equals(initialLength));
      });
    });

    group('updateSheetEmoji', () {
      test('updates sheet emoji successfully', () {
        // Update the emoji
        testUpdateSheetAvatar(
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

      test('handles empty emoji', () {
        // Update with empty emoji
        testUpdateSheetAvatar(
          sheetId: testSheet.id,
          type: AvatarType.emoji,
          data: '',
        );

        // Verify the emoji was updated to empty
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        expect(updatedSheet.sheetAvatar.data, equals(''));
      });

      test('handles special characters in emoji', () {
        // Update with special characters
        const specialEmoji = r'@#$%^&*()_+-=[]{}|;:,.<>?';
        testUpdateSheetAvatar(
          sheetId: testSheet.id,
          type: AvatarType.emoji,
          data: specialEmoji,
        );

        // Verify the emoji was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        expect(updatedSheet.sheetAvatar.data, equals(specialEmoji));
      });

      test('does not affect other sheets', () {
        // Get a second test sheet
        final sheet2 = getSheetByIndex(container, index: 1);

        // Update only first sheet emoji
        testUpdateSheetAvatar(
          sheetId: testSheet.id,
          type: AvatarType.emoji,
          data: '🎉',
        );

        // Verify only testSheet was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet1 = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        final unchangedSheet2 = updatedList.firstWhere(
          (s) => s.id == sheet2.id,
        );

        expect(updatedSheet1.sheetAvatar.data, equals('🎉'));
        expect(
          unchangedSheet2.sheetAvatar.data,
          equals(sheet2.sheetAvatar.data),
        );
      });
    });

    group('updateSheetTheme', () {
      test('updates sheet theme successfully', () {
        // Update the theme
        const primaryColor = Color(0xFF6200EE);
        const secondaryColor = Color(0xFF03DAC6);
        testUpdateSheetTheme(
          sheetId: testSheet.id,
          primary: primaryColor,
          secondary: secondaryColor,
        );

        // Verify the theme was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        expect(updatedSheet.theme?.primary, equals(primaryColor));
        expect(updatedSheet.theme?.secondary, equals(secondaryColor));
      });

      test('does not affect other sheets', () {
        // Get a second test sheet
        final sheet2 = getSheetByIndex(container, index: 1);

        // Capture initial theme for sheet2
        final initialThemeSheet2 = sheet2.theme;

        // Update only first sheet theme
        const primaryColor = Color(0xFFBB86FC);
        const secondaryColor = Color(0xFF03DAC6);
        testUpdateSheetTheme(
          sheetId: testSheet.id,
          primary: primaryColor,
          secondary: secondaryColor,
        );

        // Verify only testSheet was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet1 = updatedList.firstWhere(
          (s) => s.id == testSheet.id,
        );
        final unchangedSheet2 = updatedList.firstWhere(
          (s) => s.id == sheet2.id,
        );

        expect(updatedSheet1.theme?.primary, equals(primaryColor));
        expect(updatedSheet1.theme?.secondary, equals(secondaryColor));
        expect(unchangedSheet2.theme, equals(initialThemeSheet2));
      });

      test('handles non-existent sheet ID gracefully', () {
        final initialLength = container.read(sheetListProvider).length;

        // Try to update non-existent sheet
        const primaryColor = Color(0xFF000000);
        const secondaryColor = Color(0xFFFFFFFF);
        testUpdateSheetTheme(
          sheetId: 'non-existent-id',
          primary: primaryColor,
          secondary: secondaryColor,
        );

        // List should remain unchanged
        expect(container.read(sheetListProvider).length, equals(initialLength));
      });
    });
  });
}
