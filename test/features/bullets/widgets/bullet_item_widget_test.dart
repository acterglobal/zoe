import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/models/user_chip_type.dart';
import 'package:zoe/common/models/user_display_type.dart';
import 'package:zoe/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_chip_widget.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/bullets/widgets/bullet_added_by_header_widget.dart';
import 'package:zoe/features/bullets/widgets/bullet_item_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../utils/bullets_utils.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    container = ProviderContainer.test();
  });

  group('Bullet Item Widget', () {
    late BulletModel testBulletModel;

    setUp(() {
      // Create the final container with overrides
      container = ProviderContainer.test(
        overrides: [
          bulletListProvider.overrideWith(() => EmptyBulletList()),
          bulletFocusProvider.overrideWith(() => BulletFocus()),
          getUserByIdProvider(testUserId).overrideWithValue(testUserModel),
        ],
      );

      // Add the test bullet to the container
      testBulletModel = addBulletAndGetModel(
        container,
        title: testBulletTitle,
        parentId: testParentId,
        sheetId: testSheetId,
        createdBy: testUserId,
      );
    });

    group('Basic Rendering with Test Bullet', () {
      testWidgets('displays bullet item when bullet exists', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
        );

        // Verify main components are present
        expect(find.byType(BulletItemWidget), findsOneWidget);
        expect(find.text(testBulletTitle), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);
        expect(find.byIcon(Icons.circle), findsOneWidget);
      });

      testWidgets('returns empty widget when bullet does not exist', (
        tester,
      ) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: nonExistentBulletId,
        );

        // Should return SizedBox.shrink() when bullet is null
        expect(find.byType(BulletItemWidget), findsOneWidget);
        expect(find.text(testBulletTitle), findsNothing);
        expect(find.byType(ZoeInlineTextEditWidget), findsNothing);
      });
    });

    group('Text Editing', () {
      testWidgets('displays title in read-only mode when not editing', (
        tester,
      ) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          isEditing: false,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.isEditing, isFalse);
        expect(textEditWidget.text, equals(testBulletTitle));
      });

      testWidgets('displays title in edit mode when editing', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          isEditing: true,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.isEditing, isTrue);
        expect(textEditWidget.text, equals(testBulletTitle));
      });

      testWidgets('has correct text input action', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.textInputAction, equals(TextInputAction.next));
      });

      testWidgets('focuses when bullet is focused', (tester) async {
        // Set focus to the test bullet
        container = ProviderContainer.test(
          overrides: [
            bulletProvider(
              testBulletModel.id,
            ).overrideWithValue(testBulletModel),
            bulletFocusProvider.overrideWithValue(testBulletModel.id),
          ],
        );

        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.autoFocus, isTrue);
      });

      testWidgets('does not focus when bullet is not focused', (tester) async {
        // Set focus to a different bullet
        container = ProviderContainer.test(
          overrides: [
            bulletProvider(
              testBulletModel.id,
            ).overrideWithValue(testBulletModel),
            bulletFocusProvider.overrideWithValue(nonExistentBulletId),
          ],
        );

        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.autoFocus, isFalse);
      });
    });

    group('Text Editing Callbacks', () {
      testWidgets('calls updateBulletTitle on text change', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          isEditing: true,
        );

        // Find the TextField widget (which is shown when isEditing is true)
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Simulate text change by entering text into the TextField
        const newTitle = 'Updated Title';
        await tester.enterText(textField, newTitle);
        // wait for provider to process the update
        await tester.pumpAndSettle();

        // Verify the bullet title is updated in the provider
        final updatedBullet = container.read(
          bulletProvider(testBulletModel.id),
        );
        expect(updatedBullet?.title, equals(newTitle));
      });

      testWidgets('adds new bullet on enter press', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          isEditing: true,
        );

        // Find the TextField widget
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Get initial bullet count
        final initialBullets = container.read(bulletListProvider);
        final initialCount = initialBullets.length;

        // Trigger the onEnterPressed callback directly
        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        textEditWidget.onEnterPressed?.call();
        await tester.pump();

        // Verify new bullet is added
        final updatedBullets = container.read(bulletListProvider);
        expect(updatedBullets.length, equals(initialCount + 1));

        // Verify new bullet has correct properties
        final newBullet = updatedBullets.last;
        expect(newBullet.parentId, equals(testParentId));
        expect(newBullet.sheetId, equals(testSheetId));
        expect(newBullet.orderIndex, equals(1));
      });

      testWidgets('deletes bullet on backspace with empty text', (
        tester,
      ) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          isEditing: true,
        );

        // Find the TextField widget
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Clear the text field first to make it empty
        await tester.enterText(textField, '');
        await tester.pump();

        // The onBackspaceEmptyText is triggered when text becomes empty
        // This simulates the behavior in the onChanged callback

        // Verify bullet is deleted
        final updatedBullet = container.read(
          bulletProvider(testBulletModel.id),
        );
        expect(updatedBullet, isNull);
      });
    });

    group('Navigation', () {
      testWidgets('navigates to bullet detail on text tap', (tester) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.push(any())).thenAnswer((_) {
          return Future.value(true);
        });

        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          router: mockRouter,
        );

        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );

        // Simulate text tap
        textEditWidget.onTapText?.call();
        await tester.pumpAndSettle();

        // Verify that the router.push method was called with the correct path
        verify(
          () => mockRouter.push('/bullet/${testBulletModel.id}'),
        ).called(1);
      });
    });

    group('Edit Mode Actions', () {
      testWidgets('shows action buttons when in edit mode', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          isEditing: true,
        );

        // Verify edit and delete buttons are shown
        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byType(ZoeCloseButtonWidget), findsOneWidget);
      });

      testWidgets('hides action buttons when not in edit mode', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          isEditing: false,
        );

        // Verify edit and delete buttons are hidden
        expect(find.byIcon(Icons.edit), findsNothing);
        expect(find.byType(ZoeCloseButtonWidget), findsNothing);
      });

      testWidgets('navigates to bullet detail on edit button tap', (
        tester,
      ) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.push(any())).thenAnswer((_) async {
          return Future.value(true);
        });

        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          isEditing: true,
          router: mockRouter,
        );

        // Tap the edit button
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        // Verify that the router.push method was called with the correct path
        verify(
          () => mockRouter.push('/bullet/${testBulletModel.id}'),
        ).called(1);
      });

      testWidgets('deletes bullet on close button tap', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          isEditing: true,
        );

        // Tap the close button
        await tester.tap(find.byType(ZoeCloseButtonWidget));
        await tester.pumpAndSettle();

        // Verify bullet is deleted
        final updatedBullet = container.read(
          bulletProvider(testBulletModel.id),
        );
        expect(updatedBullet, isNull);
      });
    });

    group('User Display - Avatar Only', () {
      testWidgets('displays user avatar when userDisplayType is avatarOnly', (
        tester,
      ) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          userDisplayType: ZoeUserDisplayType.avatarOnly,
        );

        // Verify user avatar is shown in row
        expect(find.byType(ZoeUserAvatarWidget), findsOneWidget);
        expect(find.byType(ZoeUserChipWidget), findsNothing);
        expect(find.byType(BulletAddedByHeaderWidget), findsNothing);
      });

      testWidgets('hides user display when user is null', (tester) async {
        // Override with null user
        container = ProviderContainer.test(
          overrides: [
            bulletProvider(
              testBulletModel.id,
            ).overrideWithValue(testBulletModel),
            getUserByIdProvider(testUserId).overrideWithValue(null),
          ],
        );

        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          userDisplayType: ZoeUserDisplayType.avatarOnly,
        );

        // Verify user display is hidden
        expect(find.byType(ZoeUserAvatarWidget), findsNothing);
      });
    });

    group('User Display - Name Chip Below', () {
      testWidgets(
        'displays user chip below when userDisplayType is nameChipBelow',
        (tester) async {
          await pumpBulletItemWidget(
            tester: tester,
            container: container,
            bulletId: testBulletModel.id,
            userDisplayType: ZoeUserDisplayType.nameChipBelow,
          );

          // Verify user chip and header are shown below
          expect(find.byType(ZoeUserChipWidget), findsOneWidget);
          expect(find.byType(BulletAddedByHeaderWidget), findsOneWidget);
          expect(find.byType(ZoeUserAvatarWidget), findsNothing);
        },
      );

      testWidgets('user chip has correct type', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          userDisplayType: ZoeUserDisplayType.nameChipBelow,
        );

        final userChip = tester.widget<ZoeUserChipWidget>(
          find.byType(ZoeUserChipWidget),
        );
        expect(userChip.type, equals(ZoeUserChipType.userNameChip));
        expect(userChip.user, equals(testUserModel));
      });

      testWidgets('bullet added by header has correct properties', (
        tester,
      ) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          userDisplayType: ZoeUserDisplayType.nameChipBelow,
        );

        final header = tester.widget<BulletAddedByHeaderWidget>(
          find.byType(BulletAddedByHeaderWidget),
        );
        expect(header.iconSize, equals(16));
        expect(header.textSize, equals(12));
      });
    });

    group('User Display - Unsupported Types', () {
      testWidgets('returns empty widget for stackedAvatars type', (
        tester,
      ) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          userDisplayType: ZoeUserDisplayType.stackedAvatars,
        );

        // Should show empty widget for unsupported type
        expect(find.byType(ZoeUserAvatarWidget), findsNothing);
        expect(find.byType(ZoeUserChipWidget), findsNothing);
        expect(find.byType(BulletAddedByHeaderWidget), findsNothing);
      });

      testWidgets('returns empty widget for nameChipsWrap type', (
        tester,
      ) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          userDisplayType: ZoeUserDisplayType.nameChipsWrap,
        );

        // Should show empty widget for unsupported type
        expect(find.byType(ZoeUserAvatarWidget), findsNothing);
        expect(find.byType(ZoeUserChipWidget), findsNothing);
        expect(find.byType(BulletAddedByHeaderWidget), findsNothing);
      });
    });

    group('Layout Structure', () {
      testWidgets('has correct main layout structure', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
        );

        // Verify main column structure
        expect(find.byType(Column), findsOneWidget);
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));

        // Verify main row structure
        expect(find.byType(Row), findsAtLeastNWidgets(1));
      });

      testWidgets(
        'displays user below when userDisplayType.showBelow is true',
        (tester) async {
          await pumpBulletItemWidget(
            tester: tester,
            container: container,
            bulletId: testBulletModel.id,
            userDisplayType: ZoeUserDisplayType.nameChipBelow,
          );

          // Verify user display is shown below the main row
          final column = tester.widget<Column>(find.byType(Column));
          expect(column.children.length, greaterThan(1));
        },
      );

      testWidgets(
        'does not display user below when userDisplayType.showBelow is false',
        (tester) async {
          await pumpBulletItemWidget(
            tester: tester,
            container: container,
            bulletId: testBulletModel.id,
            userDisplayType: ZoeUserDisplayType.avatarOnly,
          );

          // Verify only main row is present
          final column = tester.widget<Column>(find.byType(Column));
          expect(column.children.length, equals(1));
        },
      );

      testWidgets('has correct spacing between elements', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          isEditing: true,
        );

        // Verify SizedBox widgets for spacing
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty bullet title', (tester) async {
        final emptyTitleBullet = BulletModel(
          id: testBulletId,
          title: '', // Empty title
          parentId: testParentId,
          sheetId: testSheetId,
          createdBy: testUserId,
          orderIndex: 0,
        );

        container = ProviderContainer.test(
          overrides: [
            bulletListProvider.overrideWith(() => EmptyBulletList()),
            bulletProvider(
              emptyTitleBullet.id,
            ).overrideWithValue(emptyTitleBullet),
            bulletFocusProvider.overrideWithValue(null),
            getUserByIdProvider(testUserId).overrideWithValue(testUserModel),
          ],
        );

        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: emptyTitleBullet.id,
        );

        // Should still display the widget without errors
        expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);
        final textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.text, equals(''));
      });

      testWidgets('handles different bullet IDs correctly', (tester) async {
        const differentBulletId = 'different-bullet-id';
        const differentTitle = 'Different Title';

        final differentBullet = BulletModel(
          id: differentBulletId,
          title: differentTitle,
          parentId: testParentId,
          sheetId: testSheetId,
          createdBy: testUserId,
          orderIndex: 1,
        );

        container = ProviderContainer.test(
          overrides: [
            bulletListProvider.overrideWith(() => EmptyBulletList()),
            bulletProvider(
              differentBulletId,
            ).overrideWithValue(differentBullet),
            bulletFocusProvider.overrideWithValue(null),
            getUserByIdProvider(testUserId).overrideWithValue(testUserModel),
          ],
        );

        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: differentBulletId,
        );

        // Verify correct bullet data is displayed
        expect(find.text(differentTitle), findsOneWidget);
      });

      testWidgets('handles missing user gracefully', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            bulletListProvider.overrideWith(() => EmptyBulletList()),
            bulletProvider(
              testBulletModel.id,
            ).overrideWithValue(testBulletModel),
            bulletFocusProvider.overrideWithValue(null),
            getUserByIdProvider(
              testBulletModel.createdBy,
            ).overrideWith((ref) => null),
          ],
        );

        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
          userDisplayType: ZoeUserDisplayType.avatarOnly,
        );

        // Should not crash and should hide user display
        expect(find.byType(ZoeUserAvatarWidget), findsNothing);
        expect(find.text(testBulletTitle), findsOneWidget);
      });
    });

    group('Provider Integration', () {
      testWidgets('watches bullet provider correctly', (tester) async {
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
        );

        // Verify bullet data is displayed
        expect(find.text(testBulletTitle), findsOneWidget);

        // Update bullet title through provider
        container
            .read(bulletListProvider.notifier)
            .updateBulletTitle(testBulletModel.id, 'Updated Title');
        await tester.pump();

        // Verify updated title is displayed
        expect(find.text('Updated Title'), findsOneWidget);
        expect(find.text(testBulletTitle), findsNothing);
      });

      testWidgets('watches focus provider correctly', (tester) async {
        // Test when bullet is not focused
        container.read(bulletFocusProvider.notifier).state = 'different-bullet-id';
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
        );

        var textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.autoFocus, isFalse);

        // Test when bullet is focused - use the actual bullet ID
        container.read(bulletFocusProvider.notifier).state = testBulletModel.id;
        await pumpBulletItemWidget(
          tester: tester,
          container: container,
          bulletId: testBulletModel.id,
        );

        textEditWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(textEditWidget.autoFocus, isTrue);
      });
    });
  });
}
