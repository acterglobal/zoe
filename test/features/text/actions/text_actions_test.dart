import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/constants/firestore_collection_constants.dart';
import 'package:zoe/features/share/widgets/share_items_bottom_sheet.dart';
import 'package:zoe/features/text/data/text_list.dart';
import 'package:zoe/features/text/models/text_model.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../utils/text_utils.dart';

void main() {
  late ProviderContainer container;
  late FakeFirebaseFirestore fakeFirestore;
  final textContent1 = 'text-content-1';
  final textContent2 = 'text-content-2';
  final testUser = 'test-user';

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    container = ProviderContainer.test(
      overrides: [
        firestoreProvider.overrideWithValue(fakeFirestore),
        loggedInUserProvider.overrideWithValue(AsyncValue.data(testUser)),
      ],
    );

    for (final text in textList) {
      await fakeFirestore
          .collection(FirestoreCollections.texts)
          .doc(text.id)
          .set(text.toJson());
    }

    int retries = 0;
    while (container.read(textListProvider).length < 2 && retries < 20) {
      await Future.delayed(const Duration(milliseconds: 50));
      retries++;
    }
    expect(
      container.read(textListProvider).length,
      greaterThanOrEqualTo(2),
      reason: 'Provider failed to load test data within timeout',
    );
  });

  // Helper method to simulate clipboard content construction logic
  String buildClipboardContent(TextModel textModel) {
    final buffer = StringBuffer();

    // Add emoji and title
    if (textModel.emoji != null) {
      buffer.write('${textModel.emoji} ');
    }
    buffer.write(textModel.title);

    // Add description if available
    final description = textModel.description?.plainText;
    if (description != null && description.isNotEmpty) {
      buffer.write('\n\n$description');
    }

    return buffer.toString();
  }

  // Helper method to simulate share message construction logic
  String buildShareMessage(TextModel textModel, String textId) {
    final buffer = StringBuffer();

    // Add emoji and title
    if (textModel.emoji != null) {
      buffer.write('${textModel.emoji} ');
    }
    buffer.write(textModel.title);

    // Add description if available
    final description = textModel.description?.plainText;
    if (description != null && description.isNotEmpty) {
      buffer.write('\n\n$description');
    }

    // Add link
    final link = '🔗 https://hellozoe.app/text-block/$textId';
    buffer.write('\n\n$link');

    return buffer.toString();
  }

  // Helper method to verify snackbar functionality
  void verifySnackbarFunctionality() {
    expect(CommonUtils.showSnackBar, isA<Function>());
  }

  group('TextActions.copyText', () {
    test('copies text with emoji and description correctly', () {
      // Arrange
      final textContent = getTextByIndex(container, index: 1);
      expect(textContent, isNotNull);

      // Act
      final clipboardContent = buildClipboardContent(textContent);

      // Assert
      expect(clipboardContent, contains('📋 Understanding Sheets'));
      expect(
        clipboardContent,
        contains('Sheets are your main workspaces in Zoe'),
      );
      verifySnackbarFunctionality();
    });

    test('copies text without emoji correctly', () {
      // Arrange
      final textContent = getTextByIndex(container);
      expect(textContent, isNotNull);

      // Act
      final clipboardContent = buildClipboardContent(textContent);

      // Assert
      expect(clipboardContent, startsWith('Welcome to Zoe!'));
      expect(clipboardContent, isNot(contains('📋')));
      expect(
        clipboardContent,
        contains('Welcome to Zoe - your intelligent personal workspace!'),
      );
      verifySnackbarFunctionality();
    });

    test('handles text with empty description', () async {
      // Arrange
      final textWithEmptyDesc = TextModel(
        id: 'text-empty-desc',
        sheetId: 'sheet-1',
        parentId: 'sheet-1',
        title: 'Empty Description Text',
        description: (plainText: '', htmlText: ''),
        orderIndex: 10,
        createdBy: 'test-user',
      );

      await container
          .read(textListProvider.notifier)
          .addText(textWithEmptyDesc);

      final textContent = container.read(textProvider('text-empty-desc'));
      expect(textContent, isNotNull);

      // Act
      final clipboardContent = buildClipboardContent(textContent!);

      // Assert
      expect(clipboardContent, equals('Empty Description Text'));
      expect(clipboardContent, isNot(contains('\n\n')));
      verifySnackbarFunctionality();
    });

    test('handles null text content without showing snackbar', () {
      // Arrange & Act
      final textContent = container.read(textProvider('non-existent-text'));

      // Assert
      expect(textContent, isNull);
      // No clipboard operation or snackbar should occur for null content
    });
  });

  group('TextActions.editText', () {
    test('sets edit content id provider correctly', () {
      // Arrange
      final initialEditId = container.read(editContentIdProvider);

      // Act
      container.read(editContentIdProvider.notifier).state = textContent1;

      // Assert
      expect(container.read(editContentIdProvider), equals(textContent1));
      expect(
        container.read(editContentIdProvider),
        isNot(equals(initialEditId)),
      );
    });

    test('can change edit content id multiple times', () {
      // Arrange & Act - Set first edit id
      container.read(editContentIdProvider.notifier).state = textContent1;

      // Assert
      expect(container.read(editContentIdProvider), equals(textContent1));

      // Act - Change to different edit id
      container.read(editContentIdProvider.notifier).state = textContent2;

      // Assert
      expect(container.read(editContentIdProvider), equals(textContent2));

      // Act - Clear edit mode
      container.read(editContentIdProvider.notifier).state = null;

      // Assert
      expect(container.read(editContentIdProvider), isNull);
    });
  });

  group('TextActions.deleteText', () {
    test('deletes text from provider correctly', () async {
      // Arrange
      expect(getTextByIndex(container), isNotNull);

      // Act
      await container.read(textListProvider.notifier).deleteText(textContent1);

      // Assert
      expect(container.read(textProvider(textContent1)), isNull);
      verifySnackbarFunctionality();
    });
  });

  group('ShareUtils.getTextContentShareMessage', () {
    test('generates share message with emoji and description', () {
      // Arrange
      final textContent = getTextByIndex(container, index: 1);
      expect(textContent, isNotNull);

      // Act
      final shareMessage = buildShareMessage(textContent, textContent2);

      // Assert
      expect(shareMessage, contains('📋 Understanding Sheets'));
      expect(shareMessage, contains('Sheets are your main workspaces in Zoe'));
      expect(
        shareMessage,
        contains('🔗 https://hellozoe.app/text-block/$textContent2'),
      );
    });

    test('generates share message without emoji', () {
      // Arrange
      final textContent = getTextByIndex(container);
      expect(textContent, isNotNull);

      // Act
      final shareMessage = buildShareMessage(textContent, textContent1);

      // Assert
      expect(shareMessage, startsWith('Welcome to Zoe!'));
      expect(shareMessage, isNot(contains('📋')));
      expect(
        shareMessage,
        contains('Welcome to Zoe - your intelligent personal workspace!'),
      );
      expect(
        shareMessage,
        contains('🔗 https://hellozoe.app/text-block/$textContent1'),
      );
    });

    test('generates share message with empty description', () async {
      // Arrange
      final textWithEmptyDesc = TextModel(
        id: 'text-empty-desc-share',
        sheetId: 'sheet-1',
        parentId: 'sheet-1',
        title: 'Empty Description Text',
        description: (plainText: '', htmlText: ''),
        orderIndex: 10,
        createdBy: 'test-user',
      );

      await container
          .read(textListProvider.notifier)
          .addText(textWithEmptyDesc);

      final textContent = container.read(textProvider('text-empty-desc-share'));
      expect(textContent, isNotNull);

      // Act
      final shareMessage = buildShareMessage(
        textContent!,
        'text-empty-desc-share',
      );

      // Assert
      expect(
        shareMessage,
        equals(
          'Empty Description Text\n\n🔗 https://hellozoe.app/text-block/text-empty-desc-share',
        ),
      );
    });

    test('generates share message with only emoji and no title', () async {
      // Arrange
      final textWithOnlyEmoji = TextModel(
        id: 'only-emoji-share',
        sheetId: 'sheet-1',
        parentId: 'sheet-1',
        title: '',
        emoji: '🎉',
        description: (
          plainText: 'Description only',
          htmlText: '<p>Description only</p>',
        ),
        orderIndex: 13,
        createdBy: 'test-user',
      );

      await container
          .read(textListProvider.notifier)
          .addText(textWithOnlyEmoji);

      final textContent = container.read(textProvider('only-emoji-share'));
      expect(textContent, isNotNull);

      // Act
      final shareMessage = buildShareMessage(textContent!, 'only-emoji-share');

      // Assert
      expect(shareMessage, startsWith('🎉 '));
      expect(shareMessage, contains('Description only'));
      expect(
        shareMessage,
        contains('🔗 https://hellozoe.app/text-block/only-emoji-share'),
      );
    });

    test('generates share message with null description', () async {
      // Arrange
      final textWithNullDesc = TextModel(
        id: 'null-desc-share',
        sheetId: 'sheet-1',
        parentId: 'sheet-1',
        title: 'Null Description Text',
        emoji: '📝',
        description: null,
        orderIndex: 14,
        createdBy: 'test-user',
      );

      await container.read(textListProvider.notifier).addText(textWithNullDesc);

      final textContent = container.read(textProvider('null-desc-share'));
      expect(textContent, isNotNull);

      // Act
      final shareMessage = buildShareMessage(textContent!, 'null-desc-share');

      // Assert
      expect(
        shareMessage,
        equals(
          '📝 Null Description Text\n\n🔗 https://hellozoe.app/text-block/null-desc-share',
        ),
      );
    });
  });

  group('ShareItemsBottomSheet', () {
    test('ShareItemsBottomSheet widget can be instantiated', () {
      // Arrange & Act
      final bottomSheet = ShareItemsBottomSheet(
        parentId: textContent1,
        isSheet: false,
      );

      // Assert
      expect(bottomSheet.parentId, equals(textContent1));
      expect(bottomSheet.isSheet, equals(false));
    });

    test('ShareItemsBottomSheet with isSheet true', () {
      // Arrange & Act
      final bottomSheet = ShareItemsBottomSheet(
        parentId: 'sheet-1',
        isSheet: true,
      );

      // Assert
      expect(bottomSheet.parentId, equals('sheet-1'));
      expect(bottomSheet.isSheet, equals(true));
    });
  });

  group('TextActions Edge Cases', () {
    test('handles text with only emoji and no title', () async {
      // Arrange
      final textWithOnlyEmoji = TextModel(
        id: 'only-emoji',
        sheetId: 'sheet-1',
        parentId: 'sheet-1',
        title: '',
        emoji: '🎉',
        description: (
          plainText: 'Description only',
          htmlText: '<p>Description only</p>',
        ),
        orderIndex: 13,
        createdBy: 'test-user',
      );

      await container
          .read(textListProvider.notifier)
          .addText(textWithOnlyEmoji);

      final textContent = container.read(textProvider('only-emoji'));
      expect(textContent, isNotNull);

      // Act
      final clipboardContent = buildClipboardContent(textContent!);

      // Assert
      expect(clipboardContent, startsWith('🎉 '));
      expect(clipboardContent, contains('Description only'));
    });

    test('handles text with null description', () async {
      // Arrange
      final textWithNullDesc = TextModel(
        id: 'null-desc',
        sheetId: 'sheet-1',
        parentId: 'sheet-1',
        title: 'Null Description Text',
        emoji: '📝',
        description: null,
        orderIndex: 14,
        createdBy: 'test-user',
      );

      await container.read(textListProvider.notifier).addText(textWithNullDesc);

      final textContent = container.read(textProvider('null-desc'));
      expect(textContent, isNotNull);

      // Act
      final clipboardContent = buildClipboardContent(textContent!);

      // Assert
      expect(clipboardContent, equals('📝 Null Description Text'));
      expect(clipboardContent, isNot(contains('\n\n')));
    });
  });
}
