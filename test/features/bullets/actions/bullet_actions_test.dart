import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/bullets/actions/bullet_actions.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/bullets_utils.dart';

void main() {
  late ProviderContainer container;
  late BulletModel testFirstBullet;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Create the container
    container = ProviderContainer.test();

    // Get the first bullet model
    testFirstBullet = getBulletByIndex(container);
  });

  // Pump actions widget
  Future<void> pumpActionsWidget({
    required WidgetTester tester,
    required ProviderContainer container,
    required String buttonText,
    required Function(BuildContext, WidgetRef) onPressed,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      child: Consumer(
        builder: (context, ref, child) => ElevatedButton(
          onPressed: () => onPressed(context, ref),
          child: Text(buttonText),
        ),
      ),
    );
  }

  group('BulletActions', () {
    group('Copy Bullet Action', () {
      final buttonText = 'Copy';

      testWidgets('copies bullet content to clipboard', (tester) async {
        // Pump the widget with the bullet content
        await pumpActionsWidget(
          tester: tester,
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              BulletActions.copyBullet(context, ref, testFirstBullet.id),
        );

        // Tap the copy button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify snackbar is shown (this indicates the action completed)
        expect(find.byType(SnackBar), findsOneWidget);
      });
    });

    group('Share Bullet Action', () {
      final buttonText = 'Share';

      Future<void> pumpShareActionsWidget(WidgetTester tester) async {
        await pumpActionsWidget(
          tester: tester,
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              BulletActions.shareBullet(context, testFirstBullet.id),
        );
      }

      testWidgets('shows share bottom sheet when share action is triggered', (
        tester,
      ) async {
        await pumpShareActionsWidget(tester);

        // Tap the share button
        await tester.tap(find.text(buttonText));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);
      });

      testWidgets('displays correct bullet content in share preview', (
        tester,
      ) async {
        await pumpShareActionsWidget(tester);

        // Get the context of the share button
        await tester.tap(find.text(buttonText));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Verify bottom sheet is shown
        expect(find.byType(BottomSheet), findsOneWidget);

        // Verify bullet title is displayed in the bottom sheet
        expect(find.textContaining(testFirstBullet.title), findsOneWidget);
      });

      testWidgets('share bottom sheet can be dismissed', (tester) async {
        await pumpShareActionsWidget(tester);

        // Tap the share button
        await tester.tap(find.text(buttonText));
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

          // Pump the widget with the bullet content
          await pumpShareActionsWidget(tester);

          // Tap the share button to open bottom sheet
          await tester.tap(find.text(buttonText));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));

          // Verify bottom sheet is shown
          expect(find.byType(BottomSheet), findsOneWidget);

          // Find and tap the share button inside the bottom sheet
          // Look for the share text within the bottom sheet and tap on it
          final shareButtonInSheet = find.descendant(
            of: find.byType(BottomSheet),
            matching: find.text(buttonText),
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
      final buttonText = 'Edit';
      late BulletModel testSecondBullet;

      setUp(() {
        container = ProviderContainer.test(
          overrides: [editContentIdProvider.overrideWith((ref) => null)],
        );
        testSecondBullet = getBulletByIndex(container, index: 1);
      });

      Future<void> pumpEditActionsWidget(
        WidgetTester tester, {
        String? bulletId,
      }) async {
        await pumpActionsWidget(
          tester: tester,
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              BulletActions.editBullet(ref, bulletId ?? testFirstBullet.id),
        );
      }

      testWidgets('sets edit content id when edit action is triggered', (
        tester,
      ) async {
        // Verify initial state - no bullet is being edited
        expect(container.read(editContentIdProvider), isNull);

        // Pump the widget with the bullet content
        await pumpEditActionsWidget(tester);

        // Tap the edit button
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify that the edit content id is set to the bullet id
        expect(
          container.read(editContentIdProvider),
          equals(testFirstBullet.id),
        );
      });

      testWidgets('edit action sets correct bullet id for editing', (
        tester,
      ) async {
        // Add multiple bullets
        final bulletId1 = testFirstBullet.id;
        final bulletId2 = testSecondBullet.id;

        // Verify initial state
        expect(container.read(editContentIdProvider), isNull);

        // Edit first bullet
        await pumpEditActionsWidget(tester, bulletId: bulletId1);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify first bullet is being edited
        expect(container.read(editContentIdProvider), equals(bulletId1));

        // Now edit second bullet
        await tester.pumpWidget(Container()); // Clear previous widget
        await pumpEditActionsWidget(tester, bulletId: bulletId2);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify second bullet is now being edited
        expect(container.read(editContentIdProvider), equals(bulletId2));
      });

      testWidgets('edit action can clear edit state by setting null', (
        tester,
      ) async {
        final bulletId = testFirstBullet.id;
        // Set initial edit state
        container.read(editContentIdProvider.notifier).state = bulletId;
        expect(container.read(editContentIdProvider), equals(bulletId));

        // Clear edit state manually (simulating cancel edit)
        container.read(editContentIdProvider.notifier).state = null;
        expect(container.read(editContentIdProvider), isNull);

        // Now trigger edit action again
        await pumpEditActionsWidget(tester);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify edit state is set again
        expect(container.read(editContentIdProvider), equals(bulletId));
      });

      testWidgets(
        'edit action preserves bullet data integrity and update the bullet',
        (tester) async {
          final updatedTitle = 'Updated Title';
          final bulletId = testFirstBullet.id;
          final originalTitle = testFirstBullet.title;

          // Pump the widget
          await pumpEditActionsWidget(tester);

          // Trigger edit action
          await tester.tap(find.text(buttonText));
          await tester.pumpAndSettle();

          // Verify edit state is set
          expect(container.read(editContentIdProvider), equals(bulletId));

          // Verify bullet data is unchanged
          final bulletBeforeEdit = container.read(bulletProvider(bulletId));
          expect(bulletBeforeEdit, isNotNull);
          expect(bulletBeforeEdit?.title, equals(originalTitle));
          expect(bulletBeforeEdit?.id, equals(bulletId));

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
      final buttonText = 'Delete';

      Future<void> pumpDeleteActionsWidget(
        WidgetTester tester, {
        required String bulletId,
      }) async {
        await pumpActionsWidget(
          tester: tester,
          container: container,
          buttonText: buttonText,
          onPressed: (context, ref) =>
              BulletActions.deleteBullet(context, ref, bulletId),
        );
      }

      testWidgets('deletes bullet from list when delete action is triggered', (
        tester,
      ) async {
        final bulletId = testFirstBullet.id;

        // Verify bullet exists
        final bulletBeforeDelete = container.read(bulletProvider(bulletId));
        expect(bulletBeforeDelete, isNotNull);

        // Pump the widget with the bullet content
        await pumpDeleteActionsWidget(tester, bulletId: bulletId);

        // Tap the delete button
        await tester.tap(find.text(buttonText));
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
        final testFirstBullet = getBulletByIndex(container);
        final bulletId1 = testFirstBullet.id;
        final testSecondBullet = getBulletByIndex(container, index: 1);
        final bulletId2 = testSecondBullet.id;

        // Verify both bullets exist
        final bulletBeforeDelete1 = container.read(bulletProvider(bulletId1));
        expect(bulletBeforeDelete1, isNotNull);
        final bulletBeforeDelete2 = container.read(bulletProvider(bulletId2));
        expect(bulletBeforeDelete2, isNotNull);

        // Delete first bullet
        await pumpDeleteActionsWidget(tester, bulletId: bulletId1);

        await tester.tap(find.text(buttonText));
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
        final testFirstBullet = getBulletByIndex(container);
        final firstBulletId = testFirstBullet.id;
        final testSecondBullet = getBulletByIndex(container, index: 1);
        final secondBulletId = testSecondBullet.id;

        // Set focus to first bullet
        container.read(bulletFocusProvider.notifier).state = firstBulletId;
        expect(container.read(bulletFocusProvider), equals(firstBulletId));

        // Delete first bullet
        await pumpDeleteActionsWidget(tester, bulletId: firstBulletId);

        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();

        // Verify focus is updated to second bullet
        expect(container.read(bulletFocusProvider), equals(secondBulletId));
      });
    });
  });
}
