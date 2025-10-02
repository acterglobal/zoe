import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/bullets/actions/bullet_actions.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import '../../../helpers/test_utils.dart';

Future<void> pumpBulletShareActionsWidget({
  required WidgetTester tester,
  required ProviderContainer container,
  required String bulletId,
}) async {
  await tester.pumpMaterialWidgetWithProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, child) => ElevatedButton(
        onPressed: () => BulletActions.shareBullet(context, bulletId),
        child: const Text('Share'),
      ),
    ),
  );
}

Future<void> pumpBulletCopyActionsWidget({
  required WidgetTester tester,
  required ProviderContainer container,
  required String bulletId,
}) async {
  await tester.pumpMaterialWidgetWithProviderScope(
    container: container,
    child: Consumer(
      builder: (context, ref, child) => ElevatedButton(
        onPressed: () => BulletActions.copyBullet(context, ref, bulletId),
        child: const Text('Copy'),
      ),
    ),
  );
}

/// Helper function to add a bullet to the container and return the bullet model
BulletModel addBulletAndGetModel(ProviderContainer container) {
  final notifier = container.read(bulletListProvider.notifier);
  notifier.addBullet(
    title: 'Test Bullet',
    parentId: 'parent-1',
    sheetId: 'sheet-1',
  );

  // Bullet ID is the last bullet in the list
  final bulletList = container.read(bulletListProvider);
  if (bulletList.isEmpty) fail('Bullet list is empty');
  return bulletList.last;
}

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
  });
}
