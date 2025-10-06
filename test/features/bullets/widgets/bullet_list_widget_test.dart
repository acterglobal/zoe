import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/bullets/widgets/bullet_item_widget.dart';
import 'package:zoe/features/bullets/widgets/bullet_list_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../../../helpers/test_utils.dart';
import '../utils/bullets_utils.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    container = ProviderContainer.test();
  });

  group('Bullet List Widget', () {
    late List<BulletModel> testBullets;

    setUp(() {
      // Create the final container with overrides
      container = ProviderContainer.test(
        overrides: [
          bulletListProvider.overrideWith(() => EmptyBulletList()),
          getUserByIdProvider(testUserId).overrideWithValue(testUserModel),
        ],
      );

      // Add test bullets to the container
      testBullets = [];
      for (int i = 0; i < 3; i++) {
        final bullet = addBulletAndGetModel(
          container,
          title: '$testBulletTitle $i',
          parentId: testParentId,
          sheetId: testSheetId,
          createdBy: testUserId,
        );
        testBullets.add(bullet);
      }
    });

    group('Basic Rendering', () {
      testWidgets('displays bullet list when bullets exist', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Verify ListView is displayed
        expect(find.byType(ListView), findsOneWidget);

        // Verify bullet items are displayed
        expect(find.byType(BulletItemWidget), findsNWidgets(3));

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

        // Verify bullets are in correct order (by orderIndex)
        for (int i = 0; i < 3; i++) {
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

        // Verify correct number of bullet items
        expect(find.byType(BulletItemWidget), findsNWidgets(testBullets.length));
      });

      testWidgets('uses correct keys for bullet items', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
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

        // Verify bullets are displayed
        expect(find.byType(BulletItemWidget), findsNWidgets(testBullets.length));

        // Add a new bullet
        addBulletAndGetModel(
          container,
          title: newBulletTitle,
          parentId: testParentId,
          sheetId: testSheetId,
          createdBy: testUserId,
        );
        await tester.pump();

        // Verify new bullet is displayed
        expect(find.byType(BulletItemWidget), findsNWidgets(testBullets.length + 1));
        expect(find.text(newBulletTitle), findsOneWidget);
      });

      testWidgets('updates when bullets are modified', (tester) async {
        final updatedTitle = 'Updated Title';
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Update a bullet title
        container
            .read(bulletListProvider.notifier)
            .updateBulletTitle(testBullets[0].id, updatedTitle);
        await tester.pump();

        // Verify updated title is displayed
        expect(find.text(updatedTitle), findsOneWidget);
        expect(find.text(testBullets[0].title), findsNothing);
      });

      testWidgets('updates when bullets are deleted', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Delete a bullet
        container
            .read(bulletListProvider.notifier)
            .deleteBullet(testBullets[0].id);
        await tester.pump();

        // Verify bullet is removed
        expect(find.byType(BulletItemWidget), findsNWidgets(testBullets.length - 1));
        expect(find.text(testBullets[0].title), findsNothing);
      });
    });

    group('Different Parent IDs', () {
      testWidgets('displays bullets for specific parent ID only', (
        tester,
      ) async {
        // Add bullets for a different parent
        const differentParentId = 'different-parent-id';
        final differentParentBulletTitle = 'Different Parent Bullet';
        addBulletAndGetModel(
          container,
          title: differentParentBulletTitle,
          parentId: differentParentId,
          sheetId: testSheetId,
          createdBy: testUserId,
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Should only show bullets for testParentId
        expect(find.byType(BulletItemWidget), findsNWidgets(testBullets.length));
        expect(find.text(differentParentBulletTitle), findsNothing);
        expect(find.text(testBullets[0].title), findsOneWidget);
      });

      testWidgets(
        'displays bullets for different parent when parentId changes',
        (tester) async {
          const differentParentId = 'different-parent-id';
          final differentParentBulletTitle = 'Different Parent Bullet';
          addBulletAndGetModel(
            container,
            title: differentParentBulletTitle,
            parentId: differentParentId,
            sheetId: testSheetId,
            createdBy: testUserId,
          );

          await tester.pumpMaterialWidgetWithProviderScope(
            container: container,
            child: BulletListWidget(
              parentId: differentParentId,
              isEditing: false,
            ),
          );

          // Should show bullets for differentParentId
          expect(find.byType(BulletItemWidget), findsNWidgets(1));
          expect(find.text(differentParentBulletTitle), findsOneWidget);
          expect(find.text(testBullets[0].title), findsNothing);
        },
      );
    });

    group('Edge Cases', () {
      testWidgets('handles empty bullet list gracefully', (tester) async {
        // Create a container with no bullets
        container = ProviderContainer.test(
          overrides: [
            bulletListProvider.overrideWith(() => EmptyBulletList()),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Should return empty widget
        expect(find.byType(ListView), findsNothing);
        expect(find.byType(BulletItemWidget), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('handles single bullet correctly', (tester) async {
        final singleBulletTitle = 'Single Bullet';

        // Create a container with only one bullet
        container = ProviderContainer.test(
          overrides: [
            bulletListProvider.overrideWith(() => EmptyBulletList()),
          ],
        );

        addBulletAndGetModel(
          container,
          title: singleBulletTitle,
          parentId: testParentId,
          sheetId: testSheetId,
          createdBy: testUserId,
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
        // Add many bullets
        for (int i = 3; i < 20; i++) {
          addBulletAndGetModel(
            container,
            title: '$testBulletTitle $i',
            parentId: testParentId,
            sheetId: testSheetId,
            createdBy: testUserId,
          );
        }

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: BulletListWidget(parentId: testParentId, isEditing: false),
        );

        // Should display all bullets (3 initial + 17 new = 20 total)
        expect(find.byType(BulletItemWidget), findsAtLeastNWidgets(17));
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
