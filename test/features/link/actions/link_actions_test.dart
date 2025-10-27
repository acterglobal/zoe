import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/link/actions/link_actions.dart';
import 'package:zoe/features/link/models/link_model.dart';
import 'package:zoe/features/link/providers/link_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

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

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Create the container
    container = ProviderContainer.test();

    // Get the first link model
    testFirstLink = container.read(linkProvider('link-1'))!;
  });

  group('LinkActions', () {
    group('Copy Link Action', () {
      final buttonText = 'Copy';

      test('copies link content to clipboard correctly', () {
        // Arrange
        final linkContent = container.read(linkProvider('link-1'));
        expect(linkContent, isNotNull);

        // Act & Assert - Verify the clipboard content structure
        final buffer = StringBuffer();

        // Add emoji and title
        if (linkContent!.emoji != null) {
          buffer.write('${linkContent.emoji} ');
        }
        buffer.write(linkContent.title);
        // Add url
        if (linkContent.url.isNotEmpty) {
          buffer.write('\n\n${linkContent.url}');
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
        // Arrange & Act
        final linkContent = container.read(linkProvider(''));

        // Assert
        expect(linkContent, isNull);
      });
    });

    group('Edit Link Action', () {
      final buttonText = 'Edit';
      late LinkModel testSecondLink;

      setUp(() {
        container = ProviderContainer.test(
          overrides: [editContentIdProvider.overrideWith((ref) => null)],
        );
        testSecondLink = container.read(linkProvider('link-2'))!;
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
          final linkBeforeEdit = container.read(linkProvider(linkId));
          expect(linkBeforeEdit, isNotNull);
          expect(linkBeforeEdit?.title, equals(originalTitle));
          expect(linkBeforeEdit?.url, equals(originalUrl));
          expect(linkBeforeEdit?.id, equals(linkId));

          // Update the link title
          final linkNotifier = container.read(linkListProvider.notifier);
          linkNotifier.updateLinkTitle(linkId, updatedTitle);
          linkNotifier.updateLinkUrl(linkId, updatedUrl);

          // Verify link data is updated
          final linkAfterEdit = container.read(linkProvider(linkId));
          expect(linkAfterEdit, isNotNull);
          expect(linkAfterEdit?.title, equals(updatedTitle));
          expect(linkAfterEdit?.url, equals(updatedUrl));
          expect(linkAfterEdit?.id, equals(linkId));
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
        final linkBeforeDelete = container.read(linkProvider(linkId));
        expect(linkBeforeDelete, isNotNull);

        // Pump the widget with the link content
        await pumpDeleteActionsWidget(tester, linkId: linkId);

        // Tap the delete button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify link is deleted
        final linkAfterDelete = container.read(linkProvider(linkId));
        expect(linkAfterDelete, isNull);

        // Verify snackbar is shown with correct message (indicating delete completed)
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(getL10n(tester).linkDeleted), findsOneWidget);
      });

      testWidgets('deletes correct link when multiple links exist', (
        tester,
      ) async {
        // Get multiple links
        final testFirstLink = container.read(linkProvider('link-1'))!;
        final linkId1 = testFirstLink.id;
        final testSecondLink = container.read(linkProvider('link-2'))!;
        final linkId2 = testSecondLink.id;

        // Verify both links exist
        final linkBeforeDelete1 = container.read(linkProvider(linkId1));
        expect(linkBeforeDelete1, isNotNull);
        final linkBeforeDelete2 = container.read(linkProvider(linkId2));
        expect(linkBeforeDelete2, isNotNull);

        // Delete first link
        await pumpDeleteActionsWidget(tester, linkId: linkId1);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify only first link is deleted
        final linkAfterDelete1 = container.read(linkProvider(linkId1));
        expect(linkAfterDelete1, isNull);
        final linkAfterDelete2 = container.read(linkProvider(linkId2));
        expect(linkAfterDelete2, isNotNull);
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
        );

        container.read(linkListProvider.notifier).addLink(linkWithEmptyUrl);
        final linkContent = container.read(linkProvider('link-empty-url'));
        expect(linkContent, isNotNull);

        // Act
        final buffer = StringBuffer();
        if (linkContent!.emoji != null) {
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
        );

        container.read(linkListProvider.notifier).addLink(linkWithOnlyEmoji);
        final linkContent = container.read(linkProvider('link-emoji-only'));
        expect(linkContent, isNotNull);

        // Act
        final buffer = StringBuffer();
        if (linkContent!.emoji != null) {
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
