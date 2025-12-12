/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/bullets/widgets/bullet_item_widget.dart';
import 'package:zoe/features/bullets/widgets/bullet_list_widget.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/bullets_utils.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    container = ProviderContainer.test();
  });

  group('Bullet List Widget', () {
    const testSheetId = 'sheet-1';
    const testParentId = 'list-bulleted-1';
    const nonExistentParentId = 'non-existent-parent-id';

    group('Basic Rendering', () {
      testWidgets('displays bullet list when bullets exist', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Verify ListView is displayed
        expect(find.byType(ListView), findsOneWidget);

        final testBullets = container.read(
          bulletListByParentProvider(testParentId),
        );

        // Verify bullet items are displayed
        expect(
          find.byType(BulletItemWidget),
          findsNWidgets(testBullets.length),
        );

        // Verify bullet titles are displayed
        for (final bullet in testBullets) {
          expect(find.text(bullet.title), findsOneWidget);
        }
      });

      testWidgets('returns empty widget when no bullets exist', (tester) async {
        // Use a different parent ID that has no bullets
        const emptyParentId = 'empty-parent-id';

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: emptyParentId, isEditing: false),
        );

        // Should return SizedBox.shrink() when no bullets
        expect(find.byType(ListView), findsNothing);
        expect(find.byType(BulletItemWidget), findsNothing);
      });

      testWidgets('displays bullets in correct order', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Get all bullet item widgets
        final bulletItems = tester
            .widgetList<BulletItemWidget>(find.byType(BulletItemWidget))
            .toList();

        final testBullets = container.read(
          bulletListByParentProvider(testParentId),
        );

        // Verify bullets are in correct order (by orderIndex)
        for (int i = 0; i < testBullets.length; i++) {
          expect(bulletItems[i].bulletId, equals(testBullets[i].id));
        }
      });
    });

    group('Editing Mode', () {
      testWidgets('passes isEditing true to bullet items when editing', (
        tester,
      ) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: true),
        );

        // Verify all bullet items receive isEditing: true
        final bulletItems = tester
            .widgetList<BulletItemWidget>(find.byType(BulletItemWidget))
            .toList();

        for (final bulletItem in bulletItems) {
          expect(bulletItem.isEditing, isTrue);
        }
      });

      testWidgets('passes isEditing false to bullet items when not editing', (
        tester,
      ) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Verify all bullet items receive isEditing: false
        final bulletItems = tester
            .widgetList<BulletItemWidget>(find.byType(BulletItemWidget))
            .toList();

        for (final bulletItem in bulletItems) {
          expect(bulletItem.isEditing, isFalse);
        }
      });
    });

    group('ListView Configuration', () {
      testWidgets('has correct ListView properties', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        final listView = tester.widget<ListView>(find.byType(ListView));

        // Verify ListView properties
        expect(listView.shrinkWrap, isTrue);
        expect(listView.padding, equals(EdgeInsets.zero));
        expect(listView.physics, isA<NeverScrollableScrollPhysics>());
      });
    });

    group('Item Builder', () {
      testWidgets('creates correct number of items', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Get the test bullets
        final testBullets = container.read(
          bulletListByParentProvider(testParentId),
        );

        // Verify correct number of bullet items
        expect(
          find.byType(BulletItemWidget),
          findsNWidgets(testBullets.length),
        );
      });

      testWidgets('uses correct keys for bullet items', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Get the test bullets
        final testBullets = container.read(
          bulletListByParentProvider(testParentId),
        );

        // Verify each bullet item has the correct ValueKey
        for (int i = 0; i < testBullets.length; i++) {
          final expectedKey = ValueKey(testBullets[i].id);
          expect(find.byKey(expectedKey), findsOneWidget);
        }
      });
    });

    group('Provider Integration', () {
      testWidgets('watches bulletListByParentProvider correctly', (
        tester,
      ) async {
        final newBulletTitle = 'New Bullet';

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Get the initial test bullets
        final initialBullets = container.read(
          bulletListByParentProvider(testParentId),
        );

        // Verify initial bullets are displayed
        expect(
          find.byType(BulletItemWidget),
          findsNWidgets(initialBullets.length),
        );

        // Add a new bullet
        container
            .read(bulletListProvider.notifier)
            .addBullet(
              title: newBulletTitle,
              parentId: testParentId,
              sheetId: testParentId,
            );
        await tester.pump();

        // Get the updated bullets
        final updatedBullets = container.read(
          bulletListByParentProvider(testParentId),
        );

        // Verify new bullet is displayed
        expect(
          find.byType(BulletItemWidget),
          findsNWidgets(updatedBullets.length),
        );
        expect(find.text(newBulletTitle), findsOneWidget);
      });

      testWidgets('updates when bullets are modified', (tester) async {
        // Get the first bullet
        final testFirstBullet = getBulletByIndex(container);
        final bulletId = testFirstBullet.id;
        final originalTitle = testFirstBullet.title;
        final updatedTitle = 'Updated Title';

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(
            parentId: testFirstBullet.parentId,
            isEditing: false,
          ),
        );

        // Get the test bullets
        final testBullets = container.read(
          bulletListByParentProvider(testFirstBullet.parentId),
        );

        // Verify the test bullets are not empty
        expect(testBullets.isNotEmpty, isTrue);

        // Update a bullet title
        container
            .read(bulletListProvider.notifier)
            .updateBulletTitle(bulletId, updatedTitle);
        await tester.pumpAndSettle();

        // Verify updated title is displayed
        expect(find.text(updatedTitle), findsOneWidget);
        expect(find.text(originalTitle), findsNothing);
      });

      testWidgets('updates when bullets are deleted', (tester) async {
        // Get the first bullet
        final testFirstBullet = getBulletByIndex(container);
        final bulletId = testFirstBullet.id;
        final bulletToDelete = testFirstBullet.title;

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(
            parentId: testFirstBullet.parentId,
            isEditing: false,
          ),
        );

        // Get the initial test bullets
        final initialBullets = container.read(
          bulletListByParentProvider(testParentId),
        );

        // Verify the test bullets are not empty
        expect(initialBullets.isNotEmpty, isTrue);

        // Delete a bullet
        container.read(bulletListProvider.notifier).deleteBullet(bulletId);
        await tester.pump();

        // Get the updated bullets
        final updatedBullets = container.read(
          bulletListByParentProvider(testParentId),
        );

        // Verify bullet is removed
        expect(
          find.byType(BulletItemWidget),
          findsNWidgets(updatedBullets.length),
        );
        expect(find.text(bulletToDelete), findsNothing);
      });
    });

    group('Different Parent IDs', () {
      testWidgets('displays bullets for specific parent ID only', (
        tester,
      ) async {
        // Define constants for different parent ID and bullet title
        const differentParentId = 'different-parent-id-1';
        final differentParentBulletTitle = 'Different Parent Bullet 1';

        // Add a bullet for a different parent
        container
            .read(bulletListProvider.notifier)
            .addBullet(
              title: differentParentBulletTitle,
              parentId: differentParentId,
              sheetId: testSheetId,
            );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Get the test bullets
        final testBullets = container.read(
          bulletListByParentProvider(testParentId),
        );

        // Should only show bullets for testParentId
        expect(
          find.byType(BulletItemWidget),
          findsNWidgets(testBullets.length),
        );
        expect(find.text(differentParentBulletTitle), findsNothing);
        expect(find.text(testBullets.last.title), findsOneWidget);
      });

      testWidgets(
        'displays bullets for different parent when parentId changes',
        (tester) async {
          // Define constants for different parent ID and bullet title
          const differentParentId = 'different-parent-id-2';
          final differentParentBulletTitle = 'Different Parent Bullet 2';

          // Add a bullet for a different parent
          container
              .read(bulletListProvider.notifier)
              .addBullet(
                title: differentParentBulletTitle,
                parentId: differentParentId,
                sheetId: testSheetId,
              );

          await tester.pumpMaterialWidgetWithProviderScope(
            container: container,
            child: BulletListWidget(
              parentId: differentParentId,
              isEditing: false,
            ),
          );

          // Get the original test bullets (for testParentId)
          final testBullets = container.read(
            bulletListByParentProvider(testParentId),
          );
          expect(testBullets.isNotEmpty, isTrue);

          // Should show bullets for differentParentId
          expect(find.byType(BulletItemWidget), findsNWidgets(1));
          expect(find.text(differentParentBulletTitle), findsOneWidget);
          // Should not show bullets from the original parent
          expect(find.text(testBullets.last.title), findsNothing);
        },
      );
    });

    group('Edge Cases', () {
      testWidgets('handles empty bullet list gracefully', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: nonExistentParentId, isEditing: false),
        );

        // Should return empty widget
        expect(find.byType(ListView), findsNothing);
        expect(find.byType(BulletItemWidget), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('handles single bullet correctly', (tester) async {
        const singleBulletTitle = 'Single Bullet';
        
        container = ProviderContainer.test(
          overrides: [
            bulletListProvider.overrideWithValue([
              BulletModel(
                id: '1',
                title: singleBulletTitle,
                parentId: testParentId,
                sheetId: testSheetId,
                createdBy: 'test-user',
              ),
            ]),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Should display single bullet
        expect(find.byType(BulletItemWidget), findsOneWidget);
        expect(find.text(singleBulletTitle), findsOneWidget);
      });

      testWidgets('handles large number of bullets efficiently', (
        tester,
      ) async {
        // Add a Many bullets
        container
            .read(bulletListProvider.notifier)
            .addBullet(
              title: 'Test Bullet',
              parentId: testParentId,
              sheetId: testSheetId,
            );

        container
            .read(bulletListProvider.notifier)
            .addBullet(
              title: 'Test Bullet 2',
              parentId: testParentId,
              sheetId: testSheetId,
            );

        container
            .read(bulletListProvider.notifier)
            .addBullet(
              title: 'Test Bullet 3',
              parentId: testParentId,
              sheetId: testSheetId,
            );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Get the test bullets
        final testBullets = container.read(
          bulletListByParentProvider(testParentId),
        );

        // Should display all bullets
        expect(
          find.byType(BulletItemWidget),
          findsAtLeastNWidgets(testBullets.length),
        );
      });
    });

    group('Widget Properties', () {
      testWidgets('has correct key when provided', (tester) async {
        const key = Key('test-list-key');

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(
            key: key,
            parentId: testParentId,
            isEditing: false,
          ),
        );

        expect(find.byKey(key), findsOneWidget);
      });

      testWidgets('has correct key when not provided', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Should still find the widget
        expect(find.byType(BulletListWidget), findsOneWidget);
      });
    });
  });
}
*/
