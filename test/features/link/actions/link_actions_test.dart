import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/link/actions/link_actions.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/link_utils.dart';

// Helper function to get l10n strings in tests
L10n getL10n(WidgetTester tester) {
  return WidgetTesterExtension.getL10n(tester, byType: Consumer);
}

// Helper function to pump link actions widget
Future<void> pumpLinkActionsWidget({
  required WidgetTester tester,
  required ProviderContainer container,
  required String buttonText,
  required Function(BuildContext, WidgetRef) onPressed,
}) async {
  await tester.pumpActionsWidget(
    buttonText: buttonText,
    onPressed: onPressed,
    container: container,
  );
}

void main() {
  late ProviderContainer container;
  late LinkModel testFirstLink;
  late LinkModel testSecondLink;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Create the container
    container = ProviderContainer.test();
    testFirstLink = getLinkByIndex(container, index: 0);
    testSecondLink = getLinkByIndex(container, index: 1);
  });

  group('LinkActions', () {
    group('Copy Link Action', () {
      final buttonText = 'Copy';

      test('copies link content to clipboard correctly', () {
        expect(testFirstLink, isNotNull);

        // Act & Assert - Verify the clipboard content structure
        final buffer = StringBuffer();

        // Add emoji and title
        if (testFirstLink.emoji != null) {
          buffer.write('${testFirstLink.emoji} ');
        }
        buffer.write(testFirstLink.title);
        // Add url
        if (testFirstLink.url.isNotEmpty) {
          buffer.write('\n\n${testFirstLink.url}');
        }

        final clipboardContent = buffer.toString();

        // Assert
        expect(clipboardContent, contains('📚'));
        expect(clipboardContent, contains('Zoe Official Documentation'));
        expect(clipboardContent, contains('https://docs.hellozoe.app'));
      });

      testWidgets('copies link content to clipboard shows snackbar', (
        tester,
      ) async {
        // Pump the widget with the link content
        await pumpLinkActionsWidget(
          tester: tester,
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              LinkActions.copyLink(context, ref, testFirstLink.id),
        );

        // Tap the copy button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify snackbar is shown with correct message
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(getL10n(tester).copiedToClipboard), findsOneWidget);
      });

      test('copies link without emoji correctly', () {
        // Arrange - Add a link without emoji
        final linkWithoutEmoji = LinkModel(
          id: 'link-no-emoji',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          title: 'Test Link',
          url: 'https://test.com',
          orderIndex: 100,
          createdBy: 'test-user',
        );

        container.read(linkListProvider.notifier).addLink(linkWithoutEmoji);
        final linkContent = container.read(linkProvider('link-no-emoji'));
        expect(linkContent, isNotNull);

        // Act
        final buffer = StringBuffer();
        buffer.write(linkContent!.title);
        if (linkContent.url.isNotEmpty) {
          buffer.write('\n\n${linkContent.url}');
        }

        final clipboardContent = buffer.toString();

        // Assert
        expect(clipboardContent, contains('Test Link'));
        expect(clipboardContent, contains('https://test.com'));
        expect(clipboardContent, isNot(contains('📚')));
      });

      test('handles null link content correctly', () {
        // Arrange & Act - Test with out of bounds index
        // Assert - Should fail when trying to get link with invalid index
        expect(() => getLinkByIndex(container, index: 999), throwsA(isA<TestFailure>()));
      });
    });

    group('Edit Link Action', () {
      final buttonText = 'Edit';

      setUp(() {
        container = ProviderContainer.test(
          overrides: [editContentIdProvider.overrideWith((ref) => null)],
        );
        testFirstLink = getLinkByIndex(container, index: 0);
        testSecondLink = getLinkByIndex(container, index: 1);
      });

      testWidgets('sets edit content id when edit action is triggered', (
        tester,
      ) async {
        // Verify initial state - no link is being edited
        expect(container.read(editContentIdProvider), isNull);

        // Pump the widget with the link content
        await pumpLinkActionsWidget(
          tester: tester,
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              LinkActions.editLink(ref, testFirstLink.id),
        );

        // Tap the edit button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify that the edit content id is set to the link id
        expect(container.read(editContentIdProvider), equals(testFirstLink.id));
      });

      testWidgets('edit action sets correct link id for editing', (
        tester,
      ) async {
        // Add multiple links
        final linkId1 = testFirstLink.id;
        final linkId2 = testSecondLink.id;

        // Verify initial state
        expect(container.read(editContentIdProvider), isNull);

        // Edit first link
        await pumpLinkActionsWidget(
          tester: tester,
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) => LinkActions.editLink(ref, linkId1),
        );

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify first link is being edited
        expect(container.read(editContentIdProvider), equals(linkId1));

        // Now edit second link
        await tester.pumpWidget(Container()); // Clear previous widget
        await pumpLinkActionsWidget(
          tester: tester,
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) => LinkActions.editLink(ref, linkId2),
        );

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify second link is now being edited
        expect(container.read(editContentIdProvider), equals(linkId2));
      });

      testWidgets('edit action can clear edit state by setting null', (
        tester,
      ) async {
        final linkId = testFirstLink.id;
        // Set initial edit state
        container.read(editContentIdProvider.notifier).state = linkId;
        expect(container.read(editContentIdProvider), equals(linkId));

        // Clear edit state manually (simulating cancel edit)
        container.read(editContentIdProvider.notifier).state = null;
        expect(container.read(editContentIdProvider), isNull);

        // Now trigger edit action again
        await pumpLinkActionsWidget(
          tester: tester,
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) => LinkActions.editLink(ref, linkId),
        );

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify edit state is set again
        expect(container.read(editContentIdProvider), equals(linkId));
      });

      testWidgets(
        'edit action preserves link data integrity and update the link',
        (tester) async {
          final updatedTitle = 'Updated Link Title';
          final updatedUrl = 'https://updated.com';
          final linkId = testFirstLink.id;
          final originalTitle = testFirstLink.title;
          final originalUrl = testFirstLink.url;

          // Pump the widget
          await pumpLinkActionsWidget(
            tester: tester,
            container: container,
            buttonText: buttonText,
            onPressed: (context, ref) => LinkActions.editLink(ref, linkId),
          );

          // Trigger edit action
          await tester.tap(find.text(buttonText));
          await tester.pumpAndSettle();

          // Verify edit state is set
          expect(container.read(editContentIdProvider), equals(linkId));

          // Verify link data is unchanged
          final linkBeforeEdit = getLinkByIndex(container, index: 0);
          expect(linkBeforeEdit.title, equals(originalTitle));
          expect(linkBeforeEdit.url, equals(originalUrl));
          expect(linkBeforeEdit.id, equals(linkId));

          // Update the link title
          final linkNotifier = container.read(linkListProvider.notifier);
          linkNotifier.updateLinkTitle(linkId, updatedTitle);
          linkNotifier.updateLinkUrl(linkId, updatedUrl);

          // Verify link data is updated
          final linkAfterEdit = getLinkByIndex(container, index: 0);
          expect(linkAfterEdit.title, equals(updatedTitle));
          expect(linkAfterEdit.url, equals(updatedUrl));
          expect(linkAfterEdit.id, equals(linkId));
        },
      );
    });

    group('Delete Link Action', () {
      final buttonText = 'Delete';

      Future<void> pumpDeleteActionsWidget(
        WidgetTester tester, {
        required String linkId,
      }) async {
        await pumpLinkActionsWidget(
          tester: tester,
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              LinkActions.deleteLink(context, ref, linkId),
        );
      }

      testWidgets('deletes link from list when delete action is triggered', (
        tester,
      ) async {
        final linkId = testFirstLink.id;

        // Verify link exists
        final linkBeforeDelete = getLinkByIndex(container, index: 0);
        expect(linkBeforeDelete.id, equals(linkId));

        // Pump the widget with the link content
        await pumpDeleteActionsWidget(tester, linkId: linkId);

        // Tap the delete button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify link is deleted - should now be at index 0 (was index 1)
        final linkAfterDelete = getLinkByIndex(container, index: 0);
        expect(linkAfterDelete.id, isNot(equals(linkId)));

        // Verify snackbar is shown with correct message (indicating delete completed)
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(getL10n(tester).linkDeleted), findsOneWidget);
      });

      testWidgets('deletes correct link when multiple links exist', (
        tester,
      ) async {
        // Get multiple links using helper function
        final firstLink = getLinkByIndex(container, index: 0);
        final secondLink = getLinkByIndex(container, index: 1);
        final linkId1 = firstLink.id;
        final linkId2 = secondLink.id;

        // Verify both links exist
        final linkBeforeDelete1 = getLinkByIndex(container, index: 0);
        expect(linkBeforeDelete1.id, equals(linkId1));
        final linkBeforeDelete2 = getLinkByIndex(container, index: 1);
        expect(linkBeforeDelete2.id, equals(linkId2));

        // Delete first link
        await pumpDeleteActionsWidget(tester, linkId: linkId1);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify only first link is deleted - second link should now be at index 0
        final linkAfterDelete = getLinkByIndex(container, index: 0);
        expect(linkAfterDelete.id, equals(linkId2));
      });
    });

    group('Link Actions Edge Cases', () {
      test('handles link with empty url', () {
        // Arrange
        final linkWithEmptyUrl = LinkModel(
          id: 'link-empty-url',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          title: 'Link Without URL',
          url: '',
          emoji: '🔗',
          orderIndex: 100,
          createdBy: 'test-user',
        );

        container.read(linkListProvider.notifier).addLink(linkWithEmptyUrl);
        // Find the newly added link by searching through the list
        final linkList = container.read(linkListProvider);
        final linkContent = linkList.firstWhere((link) => link.id == 'link-empty-url');
        expect(linkContent.id, equals('link-empty-url'));

        // Act
        final buffer = StringBuffer();
        if (linkContent.emoji != null) {
          buffer.write('${linkContent.emoji} ');
        }
        buffer.write(linkContent.title);
        // Add url
        if (linkContent.url.isNotEmpty) {
          buffer.write('\n\n${linkContent.url}');
        }

        final clipboardContent = buffer.toString();

        // Assert
        expect(clipboardContent, contains('🔗 Link Without URL'));
        expect(clipboardContent, isNot(contains('\n\n')));
      });

      test('handles link with only emoji and no title', () {
        // Arrange
        final linkWithOnlyEmoji = LinkModel(
          id: 'link-emoji-only',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          title: '',
          emoji: '🔗',
          url: 'https://example.com',
          orderIndex: 101,
          createdBy: 'test-user',
        );

        container.read(linkListProvider.notifier).addLink(linkWithOnlyEmoji);
        // Find the newly added link by searching through the list
        final linkList = container.read(linkListProvider);
        final linkContent = linkList.firstWhere((link) => link.id == 'link-emoji-only');
        expect(linkContent.id, equals('link-emoji-only'));

        // Act
        final buffer = StringBuffer();
        if (linkContent.emoji != null) {
          buffer.write('${linkContent.emoji} ');
        }
        buffer.write(linkContent.title);
        if (linkContent.url.isNotEmpty) {
          buffer.write('\n\n${linkContent.url}');
        }

        final clipboardContent = buffer.toString();

        // Assert
        expect(clipboardContent, startsWith('🔗 '));
        expect(clipboardContent, contains('https://example.com'));
      });
    });
  });
}
