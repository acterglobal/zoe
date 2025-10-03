import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/models/user_chip_type.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/floating_action_button_wrapper.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_chip_widget.dart';
import 'package:zoe/features/bullets/model/bullet_model.dart';
import 'package:zoe/features/bullets/providers/bullet_providers.dart';
import 'package:zoe/features/bullets/widgets/bullet_added_by_header_widget.dart';
import 'package:zoe/features/content/widgets/add_content_bottom_sheet.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../helpers/bullet_helpers.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    container = ProviderContainer.test();
  });

  group('Bullet Detail Screen', () {
    group('Empty State', () {
      testWidgets('displays empty state when bullet does not exist', (
        tester,
      ) async {
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: nonExistentBulletId,
        );

        // Verify empty state is shown
        expect(find.byType(EmptyStateWidget), findsOneWidget);
        expect(
          find.byIcon(Icons.format_list_bulleted_outlined),
          findsOneWidget,
        );
        expect(find.text('Bullet not found'), findsOneWidget);
      });

      testWidgets('displays app bar in empty state', (tester) async {
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: nonExistentBulletId,
        );

        // Verify app bar is present
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(ZoeAppBar), findsOneWidget);
      });
    });

    group('Data State', () {
      late BulletModel testBullet;
      late BulletModel testBulletOverride;

      setUp(() {
        testBullet = addBulletAndGetModel(
          container,
          title: testBulletTitle,
          parentId: testParentId,
          sheetId: testSheetId,
        );

        testBulletOverride = BulletModel(
          id: testBullet.id,
          title: testBulletTitle,
          parentId: testParentId,
          sheetId: testSheetId,
          createdBy: testUserId,
          orderIndex: testBullet.orderIndex,
        );

        container = ProviderContainer.test(
          overrides: [
            bulletProvider(testBullet.id).overrideWithValue(testBulletOverride),
            getUserByIdProvider(testUserId).overrideWithValue(testUserModel),
          ],
        );
      });

      testWidgets('displays bullet data when bullet exists', (tester) async {
        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBullet.id,
        );

        // Verify main components are present
        expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(2));
        expect(find.byType(MaxWidthWidget), findsOneWidget);
        expect(find.byType(ContentMenuButton), findsOneWidget);
      });

      testWidgets('displays floating action button', (tester) async {
        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBullet.id,
        );

        // Verify floating action button wrapper
        expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);
      });

      testWidgets('displays bullet title in read-only mode', (tester) async {
        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBullet.id,
        );

        // Verify title is displayed
        expect(find.text(testBulletTitle), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);

        // Verify it's in read-only mode (not editing)
        final titleWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(titleWidget.isEditing, isFalse);
      });

      testWidgets('displays bullet title in edit mode when editing', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            bulletProvider(testBullet.id).overrideWithValue(testBulletOverride),
            editContentIdProvider.overrideWith((ref) => testBullet.id),
          ],
        );

        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBullet.id,
        );

        // Wait for the screen to settle
        await tester.pump(const Duration(milliseconds: 100));

        // Verify title is in edit mode
        final titleWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget),
        );
        expect(titleWidget.isEditing, isTrue);
      });

      testWidgets('displays bullet description editor', (tester) async {
        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBullet.id,
        );

        // Verify description editor is present
        expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
      });

      testWidgets('displays content widget with correct parameters', (
        tester,
      ) async {
        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBullet.id,
        );

        // Verify content widget
        expect(find.byType(ContentWidget), findsOneWidget);
        final contentWidget = tester.widget<ContentWidget>(
          find.byType(ContentWidget),
        );
        expect(contentWidget.parentId, equals(testBullet.id));
        expect(contentWidget.sheetId, equals(testSheetId));
      });

      testWidgets('displays user information section', (tester) async {
        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBullet.id,
        );

        // Verify user display components
        expect(find.byType(BulletAddedByHeaderWidget), findsOneWidget);
        expect(find.byType(ZoeUserChipWidget), findsOneWidget);
        expect(find.text(testUserName), findsOneWidget);
      });

      testWidgets('hides user section when user is null', (tester) async {
        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBulletId,
        );

        // Verify user section is hidden
        expect(find.byType(BulletAddedByHeaderWidget), findsNothing);
        expect(find.byType(ZoeUserChipWidget), findsNothing);
      });

      testWidgets('displays correct user chip type', (tester) async {
        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBullet.id,
        );

        // Wait for async providers and rebuilds
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        final userChipFinder = find.byType(ZoeUserChipWidget);
        expect(userChipFinder, findsOneWidget);

        final userChipWidget = tester.widget<ZoeUserChipWidget>(userChipFinder);
        expect(userChipWidget.user, equals(testUserModel));
        expect(
          userChipWidget.type,
          equals(ZoeUserChipType.userNameWithAvatarChip),
        );
      });
    });

    group('Interaction Tap Tests', () {
      late BulletModel testBullet;
      late BulletModel testBulletOverride;

      setUp(() {
        // Add a bullet to the container
        testBullet = addBulletAndGetModel(
          container,
          title: testBulletTitle,
          parentId: testParentId,
          sheetId: testSheetId,
        );

        // Create a bullet override
        testBulletOverride = BulletModel(
          id: testBullet.id,
          title: testBulletTitle,
          parentId: testParentId,
          sheetId: testSheetId,
          createdBy: testUserId,
          orderIndex: testBullet.orderIndex,
        );

        // Override the bullet provider
        container = ProviderContainer.test(
          overrides: [
            bulletProvider(testBullet.id).overrideWithValue(testBulletOverride),
            getUserByIdProvider(testUserId).overrideWithValue(testUserModel),
          ],
        );
      });

      testWidgets('menu button is tappable', (tester) async {
        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBullet.id,
        );

        // Verify menu button exists and can be tapped
        final menuButton = find.byType(ContentMenuButton);
        expect(menuButton, findsOneWidget);

        // Tap the menu button
        await tester.tap(menuButton);
        await tester.pump(const Duration(milliseconds: 100));

        // Verify popup menu is shown with menu items
        expect(find.byType(PopupMenuItem<ZoePopupMenuItem>), findsWidgets);
      });

      testWidgets('floating action button has correct parameters', (
        tester,
      ) async {
        // Pump the screen
        await pumpBulletDetailScreen(
          tester: tester,
          container: container,
          bulletId: testBullet.id,
        );

        // Verify floating action button wrapper
        final fab = tester.widget<FloatingActionButtonWrapper>(
          find.byType(FloatingActionButtonWrapper),
        );
        expect(fab.parentId, equals(testBullet.id));
        expect(fab.sheetId, equals(testSheetId));
      });

      testWidgets(
        'floating action button on tap shows add content bottom sheet',
        (tester) async {
          // Pump the screen
          await pumpBulletDetailScreen(
            tester: tester,
            container: container,
            bulletId: testBullet.id,
          );

          // Verify floating action button wrapper
          final fab = find.byType(FloatingActionButtonWrapper);
          expect(fab, findsOneWidget);

          // Tap the floating action button
          await tester.tap(fab);
          await tester.pump(const Duration(milliseconds: 100));

          // Verify add content bottom sheet is shown
          expect(find.byType(AddContentBottomSheet), findsOneWidget);
        },
      );

      testWidgets(
        'floating action button on tap shows add content bottom sheet and add text content',
        (tester) async {
          // Pump the screen
          await pumpBulletDetailScreen(
            tester: tester,
            container: container,
            bulletId: testBullet.id,
            isWrapMediaQuery: true,
          );

          // Verify floating action button wrapper
          final fab = find.byType(FloatingActionButtonWrapper);
          expect(fab, findsOneWidget);

          // Tap the floating action button
          await tester.ensureVisible(fab);
          await tester.tap(fab);
          await tester.pump(const Duration(milliseconds: 100));

          // Verify add content bottom sheet is shown
          expect(find.byType(AddContentBottomSheet), findsOneWidget);

          // Tap the add text content option
          final textContentIcon = find.byIcon(Icons.text_fields);
          await tester.ensureVisible(textContentIcon);
          await tester.tap(textContentIcon, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 100));

          // Verify text content is added
          expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);
          expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
        },
      );
    });
  });
}
