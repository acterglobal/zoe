import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart' as sheet_model;
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

void main() {
  group('Sheet Data Updates', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
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
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'title-test-sheet',
          title: 'Original Title',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📝'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update the title
        testUpdateTitle('title-test-sheet', 'Updated Title');

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

      test('handles empty title', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'empty-title-test',
          title: 'Original Title',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📝'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update with empty title
        testUpdateTitle('empty-title-test', '');

        // Verify the title was updated to empty
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'empty-title-test',
        );
        expect(updatedSheet.title, equals(''));
      });

      test('handles special characters in title', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'special-title-test',
          title: 'Original Title',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📝'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update with special characters
        const specialTitle = r'Title with @#$%^&*()_+-=[]{}|;:,.<>?';
        testUpdateTitle('special-title-test', specialTitle);

        // Verify the title was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'special-title-test',
        );
        expect(updatedSheet.title, equals(specialTitle));
      });

      test('handles very long title', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'long-title-test',
          title: 'Original Title',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📝'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update with very long title
        final longTitle = 'A' * 1000;
        testUpdateTitle('long-title-test', longTitle);

        // Verify the title was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'long-title-test',
        );
        expect(updatedSheet.title, equals(longTitle));
        expect(updatedSheet.title.length, equals(1000));
      });

      test('does not affect other sheets', () {
        // Add two test sheets
        final sheet1 = sheet_model.SheetModel(
          id: 'sheet1',
          title: 'Sheet 1',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        final sheet2 = sheet_model.SheetModel(
          id: 'sheet2',
          title: 'Sheet 2',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(sheet1);
        container.read(sheetListProvider.notifier).addSheet(sheet2);

        // Update only sheet1
        testUpdateTitle('sheet1', 'Updated Sheet 1');

        // Verify only sheet1 was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet1 = updatedList.firstWhere((s) => s.id == 'sheet1');
        final unchangedSheet2 = updatedList.firstWhere((s) => s.id == 'sheet2');

        expect(updatedSheet1.title, equals('Updated Sheet 1'));
        expect(unchangedSheet2.title, equals('Sheet 2'));
      });
    });

    group('updateSheetDescription', () {
      test('updates sheet description successfully', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'desc-test-sheet',
          title: 'Description Test',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update the description
        const newDescription = (
          plainText: 'New plain text description',
          htmlText: '<p>New <strong>HTML</strong> description</p>',
        );
        testUpdateDescription('desc-test-sheet', newDescription);

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

      test('handles null plainText', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'null-plain-test',
          title: 'Null Plain Test',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update with null plainText
        const newDescription = (
          plainText: null,
          htmlText: '<p>HTML only description</p>',
        );
        testUpdateDescription('null-plain-test', newDescription);

        // Verify the description was updated with empty plainText
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'null-plain-test',
        );
        expect(updatedSheet.description?.plainText, equals(''));
        expect(
          updatedSheet.description?.htmlText,
          equals('<p>HTML only description</p>'),
        );
      });

      test('handles null htmlText', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'null-html-test',
          title: 'Null HTML Test',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update with null htmlText
        const newDescription = (
          plainText: 'Plain text only description',
          htmlText: null,
        );
        testUpdateDescription('null-html-test', newDescription);

        // Verify the description was updated with empty htmlText
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'null-html-test',
        );
        expect(
          updatedSheet.description?.plainText,
          equals('Plain text only description'),
        );
        expect(updatedSheet.description?.htmlText, equals(''));
      });

      test('handles both null values', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'both-null-test',
          title: 'Both Null Test',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update with both null values
        const newDescription = (plainText: null, htmlText: null);
        testUpdateDescription('both-null-test', newDescription);

        // Verify the description was updated with empty values
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'both-null-test',
        );
        expect(updatedSheet.description?.plainText, equals(''));
        expect(updatedSheet.description?.htmlText, equals(''));
      });

      test('handles special characters in description', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'special-desc-test',
          title: 'Special Desc Test',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update with special characters
        const specialDescription = (
          plainText: r'Plain text with @#$%^&*()_+-=[]{}|;:,.<>?',
          htmlText:
              r'<p>HTML with <strong>@#$%^&*()_+-=[]{}|;:,.<>?</strong></p>',
        );
        testUpdateDescription('special-desc-test', specialDescription);

        // Verify the description was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'special-desc-test',
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
        // Add two test sheets
        final sheet1 = sheet_model.SheetModel(
          id: 'desc-sheet1',
          title: 'Desc Sheet 1',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        final sheet2 = sheet_model.SheetModel(
          id: 'desc-sheet2',
          title: 'Desc Sheet 2',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(sheet1);
        container.read(sheetListProvider.notifier).addSheet(sheet2);

        // Update only sheet1 description
        const newDescription = (
          plainText: 'Updated description for sheet 1',
          htmlText: '<p>Updated description for sheet 1</p>',
        );
        testUpdateDescription('desc-sheet1', newDescription);

        // Verify only sheet1 was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet1 = updatedList.firstWhere(
          (s) => s.id == 'desc-sheet1',
        );
        final unchangedSheet2 = updatedList.firstWhere(
          (s) => s.id == 'desc-sheet2',
        );

        expect(
          updatedSheet1.description?.plainText,
          equals('Updated description for sheet 1'),
        );
        expect(unchangedSheet2.description, isNull);
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
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'emoji-test-sheet',
          title: 'Emoji Test',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update the emoji
        testUpdateSheetAvatar(
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

      test('handles empty emoji', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'empty-emoji-test',
          title: 'Empty Emoji Test',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update with empty emoji
        testUpdateSheetAvatar(
          sheetId: 'empty-emoji-test',
          type: AvatarType.emoji,
          data: '',
        );

        // Verify the emoji was updated to empty
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'empty-emoji-test',
        );
        expect(updatedSheet.sheetAvatar.data, equals(''));
      });

      test('handles special characters in emoji', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'special-emoji-test',
          title: 'Special Emoji Test',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update with special characters
        const specialEmoji = r'@#$%^&*()_+-=[]{}|;:,.<>?';
        testUpdateSheetAvatar(
          sheetId: 'special-emoji-test',
          type: AvatarType.emoji,
          data: specialEmoji,
        );

        // Verify the emoji was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'special-emoji-test',
        );
        expect(updatedSheet.sheetAvatar.data, equals(specialEmoji));
      });

      test('does not affect other sheets', () {
        // Add two test sheets
        final sheet1 = sheet_model.SheetModel(
          id: 'emoji-sheet1',
          title: 'Emoji Sheet 1',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        final sheet2 = sheet_model.SheetModel(
          id: 'emoji-sheet2',
          title: 'Emoji Sheet 2',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📄'),
        );
        container.read(sheetListProvider.notifier).addSheet(sheet1);
        container.read(sheetListProvider.notifier).addSheet(sheet2);

        // Update only sheet1 emoji
        testUpdateSheetAvatar(
          sheetId: 'emoji-sheet1',
          type: AvatarType.emoji,
          data: '🎉',
        );

        // Verify only sheet1 was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet1 = updatedList.firstWhere(
          (s) => s.id == 'emoji-sheet1',
        );
        final unchangedSheet2 = updatedList.firstWhere(
          (s) => s.id == 'emoji-sheet2',
        );

        expect(updatedSheet1.sheetAvatar.data, equals('🎉'));
        expect(unchangedSheet2.sheetAvatar.data, equals('📄'));
      });
    });

    group('updateSheetTheme', () {
      test('updates sheet theme successfully', () {
        // Add a test sheet first
        final testSheet = sheet_model.SheetModel(
          id: 'theme-test-sheet',
          title: 'Theme Test',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🎨'),
        );
        container.read(sheetListProvider.notifier).addSheet(testSheet);

        // Update the theme
        const primaryColor = Color(0xFF6200EE);
        const secondaryColor = Color(0xFF03DAC6);
        testUpdateSheetTheme(
          sheetId: 'theme-test-sheet',
          primary: primaryColor,
          secondary: secondaryColor,
        );

        // Verify the theme was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet = updatedList.firstWhere(
          (s) => s.id == 'theme-test-sheet',
        );
        expect(updatedSheet.theme?.primary, equals(primaryColor));
        expect(updatedSheet.theme?.secondary, equals(secondaryColor));
        expect(
          updatedSheet.title,
          equals('Theme Test'),
        ); // Other properties unchanged
      });

      test('does not affect other sheets', () {
        // Add two test sheets
        final sheet1 = sheet_model.SheetModel(
          id: 'theme-sheet1',
          title: 'Theme Sheet 1',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🎨'),
        );
        final sheet2 = sheet_model.SheetModel(
          id: 'theme-sheet2',
          title: 'Theme Sheet 2',
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🎨'),
        );
        container.read(sheetListProvider.notifier).addSheet(sheet1);
        container.read(sheetListProvider.notifier).addSheet(sheet2);

        // Update only sheet1 theme
        const primaryColor = Color(0xFFBB86FC);
        const secondaryColor = Color(0xFF03DAC6);
        testUpdateSheetTheme(
          sheetId: 'theme-sheet1',
          primary: primaryColor,
          secondary: secondaryColor,
        );

        // Verify only sheet1 was updated
        final updatedList = container.read(sheetListProvider);
        final updatedSheet1 = updatedList.firstWhere(
          (s) => s.id == 'theme-sheet1',
        );
        final unchangedSheet2 = updatedList.firstWhere(
          (s) => s.id == 'theme-sheet2',
        );

        expect(updatedSheet1.theme?.primary, equals(primaryColor));
        expect(updatedSheet1.theme?.secondary, equals(secondaryColor));
        expect(unchangedSheet2.theme, isNull);
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
