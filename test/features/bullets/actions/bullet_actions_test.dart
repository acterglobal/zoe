import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import '../utils/bullets_utils.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('BulletActions', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test(
        overrides: [bulletListProvider.overrideWith(() => BulletList())],
      );
    });

    group('Copy Bullet Action', () {
      testWidgets('copies bullet content to clipboard', (tester) async {
        final bulletModel = addBulletAndGetModel(container);
        final bulletId = bulletModel.id;

        // Pump the widget with the bullet content
        await pumpBulletCopyActionsWidget(
          tester: tester,
          container: container,
          bulletId: bulletId,
        );

        // Tap the copy button
        await tester.tap(find.text('Copy'));
        await tester.pumpAndSettle();

        // Verify snackbar is shown (this indicates the action completed)
        expect(find.byType(SnackBar), findsOneWidget);
      });
    });

    group('Share Bullet Action', () {
      testWidgets('shows share bottom sheet when share action is triggered', (
        tester,
      ) async {
        final bulletModel = addBulletAndGetModel(container);
        final bulletId = bulletModel.id;

        // Pump the widget with the bullet content
        await pumpBulletShareActionsWidget(
          tester: tester,
          container: container,
          bulletId: bulletId,
        );

        // Tap the share button
        await tester.tap(find.text('Share'));
        await tester.pump();
        // Wait for animation
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);
      });

      testWidgets('displays correct bullet content in share preview', (
        tester,
      ) async {
        final bulletModel = addBulletAndGetModel(container);
        final bulletId = bulletModel.id;

        // Pump the widget with the bullet content
        await pumpBulletShareActionsWidget(
          tester: tester,
          container: container,
          bulletId: bulletId,
        );

        // Get the context of the share button
        await tester.tap(find.text('Share'));
        await tester.pump();
        // Wait for animation
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);

        // Verify bullet title is displayed in the bottom sheet
        expect(find.textContaining(bulletModel.title), findsOneWidget);
      });

      testWidgets('share bottom sheet can be dismissed', (tester) async {
        final bulletModel = addBulletAndGetModel(container);
        final bulletId = bulletModel.id;

        // Pump the widget with the bullet content
        await pumpBulletShareActionsWidget(
          tester: tester,
          container: container,
          bulletId: bulletId,
        );

        // Tap the share button
        await tester.tap(find.text('Share'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);

        // Dismiss the bottom sheet by tapping outside or using back gesture
        // Tap outside the bottom sheet
        await tester.tapAt(const Offset(10, 10));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is dismissed
        expect(find.byType(BottomSheet), findsNothing);
      });

      testWidgets(
        'tapping share button in bottom sheet triggers platform share',
        (tester) async {
          bool isShareCalled = false;
          final shareChannel = MethodChannel('dev.fluttercommunity.plus/share');
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(shareChannel, (call) async {
                if (call.method == 'share') isShareCalled = true;
                return null;
              });

          final bulletModel = addBulletAndGetModel(container);
          final bulletId = bulletModel.id;

          // Pump the widget with the bullet content
          await pumpBulletShareActionsWidget(
            tester: tester,
            container: container,
            bulletId: bulletId,
          );

          // Tap the share button to open bottom sheet
          await tester.tap(find.text('Share'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));

          // Verify bottom sheet is shown
          expect(find.byType(BottomSheet), findsOneWidget);

          // Find and tap the share button inside the bottom sheet
          // Look for the share text within the bottom sheet and tap on it
          final shareButtonInSheet = find.descendant(
            of: find.byType(BottomSheet),
            matching: find.text('Share'),
          );

          expect(shareButtonInSheet, findsOneWidget);
          await tester.tap(shareButtonInSheet);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));

          // Verify that the platform share method was called
          expect(isShareCalled, isTrue);
        },
      );
    });

    group('Edit Bullet Action', () {
      testWidgets('sets edit content id when edit action is triggered', (
        tester,
      ) async {
        final bulletModel = addBulletAndGetModel(container);
        final bulletId = bulletModel.id;

        // Verify initial state - no bullet is being edited
        expect(container.read(editContentIdProvider), isNull);

        // Pump the widget with the bullet content
        await pumpBulletEditActionsWidget(
          tester: tester,
          container: container,
          bulletId: bulletId,
        );

        // Tap the edit button
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Verify that the edit content id is set to the bullet id
        expect(container.read(editContentIdProvider), equals(bulletId));
      });

      testWidgets('edit action sets correct bullet id for editing', (
        tester,
      ) async {
        // Add multiple bullets
        final bulletModel1 = addBulletAndGetModel(container);
        final bulletModel2 = addBulletAndGetModel(container);
        final bulletId1 = bulletModel1.id;
        final bulletId2 = bulletModel2.id;

        // Verify initial state
        expect(container.read(editContentIdProvider), isNull);

        // Edit first bullet
        await pumpBulletEditActionsWidget(
          tester: tester,
          container: container,
          bulletId: bulletId1,
        );

        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Verify first bullet is being edited
        expect(container.read(editContentIdProvider), equals(bulletId1));

        // Now edit second bullet
        await tester.pumpWidget(Container()); // Clear previous widget
        await pumpBulletEditActionsWidget(
          tester: tester,
          container: container,
          bulletId: bulletId2,
        );

        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Verify second bullet is now being edited
        expect(container.read(editContentIdProvider), equals(bulletId2));
      });

      testWidgets('edit action can clear edit state by setting null', (
        tester,
      ) async {
        final bulletModel = addBulletAndGetModel(container);
        final bulletId = bulletModel.id;

        // Set initial edit state
        container.read(editContentIdProvider.notifier).state = bulletId;
        expect(container.read(editContentIdProvider), equals(bulletId));

        // Clear edit state manually (simulating cancel edit)
        container.read(editContentIdProvider.notifier).state = null;
        expect(container.read(editContentIdProvider), isNull);

        // Now trigger edit action again
        await pumpBulletEditActionsWidget(
          tester: tester,
          container: container,
          bulletId: bulletId,
        );

        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        // Verify edit state is set again
        expect(container.read(editContentIdProvider), equals(bulletId));
      });

      testWidgets(
        'edit action preserves bullet data integrity and update the bullet',
        (tester) async {
          final bulletModel = addBulletAndGetModel(container);
          final bulletId = bulletModel.id;
          final originalTitle = bulletModel.title;

          // Pump the widget
          await pumpBulletEditActionsWidget(
            tester: tester,
            container: container,
            bulletId: bulletId,
          );

          // Trigger edit action
          await tester.tap(find.text('Edit'));
          await tester.pumpAndSettle();

          // Verify edit state is set
          expect(container.read(editContentIdProvider), equals(bulletId));

          // Verify bullet data is unchanged
          final bulletBeforeEdit = container.read(bulletProvider(bulletId));
          expect(bulletBeforeEdit, isNotNull);
          expect(bulletBeforeEdit?.title, equals(originalTitle));
          expect(bulletBeforeEdit?.id, equals(bulletId));

          final updatedTitle = 'Updated Title';

          // Update the bullet title
          final bulletNotifier = container.read(bulletListProvider.notifier);
          bulletNotifier.updateBulletTitle(bulletId, updatedTitle);

          // Verify bullet data is updated
          final bulletAfterEdit = container.read(bulletProvider(bulletId));
          expect(bulletAfterEdit, isNotNull);
          expect(bulletAfterEdit?.title, equals(updatedTitle));
          expect(bulletAfterEdit?.id, equals(bulletId));
        },
      );
    });

    group('Delete Bullet Action', () {
      testWidgets('deletes bullet from list when delete action is triggered', (
        tester,
      ) async {
        final bulletModel = addBulletAndGetModel(container);
        final bulletId = bulletModel.id;

        // Verify bullet exists
        final bulletBeforeDelete = container.read(bulletProvider(bulletId));
        expect(bulletBeforeDelete, isNotNull);

        // Pump the widget with the bullet content
        await pumpBulletDeleteActionsWidget(
          tester: tester,
          container: container,
          bulletId: bulletId,
        );

        // Tap the delete button
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify bullet is deleted
        final bulletAfterDelete = container.read(bulletProvider(bulletId));
        expect(bulletAfterDelete, isNull);

        // Verify snackbar is shown (indicating delete completed)
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('deletes correct bullet when multiple bullets exist', (
        tester,
      ) async {
        // Add multiple bullets
        final bulletModel1 = addBulletAndGetModel(container);
        final bulletModel2 = addBulletAndGetModel(container);
        final bulletId1 = bulletModel1.id;
        final bulletId2 = bulletModel2.id;

        // Verify both bullets exist
        final bulletBeforeDelete1 = container.read(bulletProvider(bulletId1));
        expect(bulletBeforeDelete1, isNotNull);
        final bulletBeforeDelete2 = container.read(bulletProvider(bulletId2));
        expect(bulletBeforeDelete2, isNotNull);

        // Delete first bullet
        await pumpBulletDeleteActionsWidget(
          tester: tester,
          container: container,
          bulletId: bulletId1,
        );

        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify only first bullet is deleted
        final bulletAfterDelete1 = container.read(bulletProvider(bulletId1));
        expect(bulletAfterDelete1, isNull);
        final bulletAfterDelete2 = container.read(bulletProvider(bulletId2));
        expect(bulletAfterDelete2, isNotNull);
      });

      testWidgets('delete action updates bullet focus correctly', (
        tester,
      ) async {
        // Add multiple bullets with same parent and sheet
        const firstBulletTitle = 'First Bullet';
        const secondBulletTitle = 'Second Bullet';

        // Add multiple bullets
        final bulletModel1 = addBulletAndGetModel(
          container,
          title: firstBulletTitle,
          orderIndex: 1,
        );
        final bulletModel2 = addBulletAndGetModel(
          container,
          title: secondBulletTitle,
          orderIndex: 2,
        );
        final firstBulletId = bulletModel1.id;
        final secondBulletId = bulletModel2.id;

        // Set focus to first bullet
        container.read(bulletFocusProvider.notifier).state = firstBulletId;
        expect(container.read(bulletFocusProvider), equals(firstBulletId));

        // Delete first bullet
        await pumpBulletDeleteActionsWidget(
          tester: tester,
          container: container,
          bulletId: firstBulletId,
        );

        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify focus is updated to second bullet
        expect(container.read(bulletFocusProvider), equals(secondBulletId));
      });
    });
  });
}
