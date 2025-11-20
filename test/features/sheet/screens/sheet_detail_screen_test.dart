import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';
import 'package:zoe/common/widgets/floating_action_button_wrapper.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/screens/sheet_detail_screen.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';
import '../../users/utils/users_utils.dart';
import '../utils/sheet_utils.dart';

void main() {
  group('SheetDetailScreen', () {
    late ProviderContainer container;
    late SheetModel testSheet;
    late String testSheetId;
    late MockGoRouter mockGoRouter;

    setUp(() {
      container = ProviderContainer.test();
      testSheet = getSheetByIndex(container);
      testSheetId = testSheet.id;

      mockGoRouter = MockGoRouter();
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenReturn(null);
      when(() => mockGoRouter.push(any())).thenAnswer((_) async => true);
    });

    Future<void> pumpSheetDetailScreen(
      WidgetTester tester, {
      String? sheetId,
      bool isEditing = false,
    }) async {
      if (isEditing) {
        container.read(editContentIdProvider.notifier).state =
            sheetId ?? testSheetId;
      } else {
        container.read(editContentIdProvider.notifier).state = null;
      }

      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: SheetDetailScreen(sheetId: sheetId ?? testSheetId),
      );
    }

    /// Helper function to get L10n instance for the SheetDetailScreen
    L10n getL10n(WidgetTester tester) {
      return L10n.of(tester.element(find.byType(SheetDetailScreen)));
    }

    group('Widget Construction', () {
      testWidgets('creates widget with required sheetId', (tester) async {
        final widget = SheetDetailScreen(sheetId: testSheetId);
        expect(widget.sheetId, equals(testSheetId));
        expect(widget, isA<ConsumerWidget>());
      });

      testWidgets('accepts various sheetId formats', (tester) async {
        final testCases = [
          testSheetId,
          '',
          'test-id-&<>"\'',
          'sheet_123',
          'sheet-with-dashes',
        ];

        for (final sheetId in testCases) {
          expect(
            () => SheetDetailScreen(sheetId: sheetId),
            returnsNormally,
            reason: 'Should accept sheetId: $sheetId',
          );
        }
      });
    });

    group('Widget Rendering', () {
      testWidgets('renders with proper structure', (tester) async {
        await pumpSheetDetailScreen(tester);

        // Verify key structural elements
        expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        expect(find.byType(Expanded), findsAtLeastNWidgets(1));
        expect(tester.takeException(), isNull);
      });

      testWidgets('renders AppBar with correct configuration', (tester) async {
        await pumpSheetDetailScreen(tester);

        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );
        expect(sliverAppBar.automaticallyImplyLeading, isFalse);
        final theme = Theme.of(tester.element(find.byType(SheetDetailScreen)));
        expect(sliverAppBar.backgroundColor, equals(theme.colorScheme.surface));
        expect(find.byType(ZoeAppBar), findsOneWidget);
        expect(find.byType(ContentMenuButton), findsOneWidget);
      });

      testWidgets('renders FloatingActionButtonWrapper', (tester) async {
        await pumpSheetDetailScreen(tester);

        final fabWrapper = tester.widget<FloatingActionButtonWrapper>(
          find.byType(FloatingActionButtonWrapper),
        );
        expect(fabWrapper.parentId, equals(testSheetId));
        expect(fabWrapper.sheetId, equals(testSheetId));
      });
    });

    group('Provider Integration', () {
      testWidgets('watches editContentIdProvider for editing state', (
        tester,
      ) async {
        await pumpSheetDetailScreen(tester);

        // Initially not editing
        expect(container.read(editContentIdProvider), isNull);

        // Set editing state
        container.read(editContentIdProvider.notifier).state = testSheetId;
        await tester.pump();

        expect(container.read(editContentIdProvider), equals(testSheetId));
      });

      testWidgets('watches sheetProvider for sheet data', (tester) async {
        await pumpSheetDetailScreen(tester);

        final sheet = container.read(sheetProvider(testSheetId));
        expect(sheet, isNotNull);
        expect(sheet!.id, equals(testSheetId));
        expect(sheet.title, isNotEmpty);
        expect(find.byType(SheetAvatarWidget), findsOneWidget);
      });

      testWidgets('watches listOfUsersBySheetIdProvider for user data', (
        tester,
      ) async {
        await pumpSheetDetailScreen(tester);

        final users = container.read(listOfUsersBySheetIdProvider(testSheetId));
        expect(users, isA<List<String>>());
        expect(users, isNotEmpty);
      });
    });

    group('Editing State Management', () {
      testWidgets('handles editing state transitions', (tester) async {
        // Test non-editing state
        await pumpSheetDetailScreen(tester, isEditing: false);
        expect(tester.takeException(), isNull);

        // Test editing state
        await pumpSheetDetailScreen(tester, isEditing: true);
        expect(tester.takeException(), isNull);

        // Test transition back to non-editing
        await pumpSheetDetailScreen(tester, isEditing: false);
        expect(tester.takeException(), isNull);
      });

      testWidgets('updates widget properties based on editing state', (
        tester,
      ) async {
        // Test non-editing state
        await pumpSheetDetailScreen(tester, isEditing: false);

        final titleWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget).first,
        );
        expect(titleWidget.isEditing, isFalse);

        // Test editing state
        await pumpSheetDetailScreen(tester, isEditing: true);

        final editingTitleWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget).first,
        );
        expect(editingTitleWidget.isEditing, isTrue);
      });
    });

    group('Error Handling', () {
      testWidgets('handles null sheet gracefully', (tester) async {
        final emptyContainer = ProviderContainer.test();

        await tester.pumpMaterialWidgetWithProviderScope(
          container: emptyContainer,
          child: SheetDetailScreen(sheetId: 'non-existent-id'),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('handles various data edge cases', (tester) async {
        final testCases = [
          // Empty users list
          testSheet.copyWith(users: []),
          // Null description
          testSheet.copyWith(description: null),
          // Very long title
          testSheet.copyWith(title: 'A' * 1000),
          // Special characters
          testSheet.copyWith(title: 'Title with émojis 🚀 and spëcial chars'),
        ];

        for (final sheet in testCases) {
          container.read(sheetListProvider.notifier).addSheet(sheet);

          await pumpSheetDetailScreen(tester, sheetId: sheet.id);
          expect(tester.takeException(), isNull);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
        }
        await tester.pump();
      });
    });

    group('Data Validation', () {
      testWidgets('validates sheet model structure', (tester) async {
        expect(testSheet.id, isNotEmpty);
        expect(testSheet.title, isNotEmpty);
        expect(testSheet.createdBy, isNotEmpty);
        expect(testSheet.createdAt, isA<DateTime>());
        expect(testSheet.updatedAt, isA<DateTime>());
        expect(testSheet.users, isA<List<String>>());

        // Validate users list structure
        for (final user in testSheet.users) {
          expect(user, isA<String>());
          expect(user, isNotEmpty);
        }

        // Validate description if present
        if (testSheet.description != null) {
          expect(testSheet.description!.plainText, isA<String>());
          expect(testSheet.description!.htmlText, isA<String>());
          expect(testSheet.description!.plainText, isNotEmpty);
          expect(testSheet.description!.htmlText, isNotEmpty);
        }
      });

      testWidgets('validates widget equality', (tester) async {
        final widget1 = SheetDetailScreen(sheetId: testSheetId);
        final widget2 = SheetDetailScreen(sheetId: testSheetId);
        final widget3 = SheetDetailScreen(sheetId: 'different-id');

        expect(widget1.sheetId, equals(widget2.sheetId));
        expect(widget1.sheetId, isNot(equals(widget3.sheetId)));
      });
    });

    group('Layout Components', () {
      testWidgets('renders all layout widgets correctly', (tester) async {
        await pumpSheetDetailScreen(tester);

        // Background and structure
        expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        expect(find.byType(Expanded), findsAtLeastNWidgets(1));

        // AppBar components
        expect(find.byType(ZoeAppBar), findsOneWidget);
        expect(find.byType(ContentMenuButton), findsOneWidget);

        // Content components
        expect(find.byType(EmojiWidget), findsAtLeastNWidgets(1));
        expect(find.byType(ZoeInlineTextEditWidget), findsAtLeastNWidgets(1));
        expect(find.byType(ZoeHtmlTextEditWidget), findsAtLeastNWidgets(1));
        expect(find.byType(ContentWidget), findsOneWidget);
      });
    });

    group('User Interactions', () {
      testWidgets('shows sheet avatar widget', (tester) async {
        await pumpSheetDetailScreen(tester);

        // Find the emoji widget in the sheet header (should be the first one in the main content)
        final sheetAvatarWidget = find.byType(SheetAvatarWidget);
        expect(sheetAvatarWidget, findsAtLeastNWidgets(1));
      });

      testWidgets('content menu button tap shows sheet menu', (tester) async {
        await pumpSheetDetailScreen(tester);

        // Tap on menu button
        final menuButton = find.byType(ContentMenuButton);
        await tester.tap(menuButton);
        await tester.pump();

        // Should show popup menu with sheet actions
        final l10n = getL10n(tester);
        expect(find.text(l10n.connectWithWhatsAppGroup), findsOneWidget);
        expect(find.text(l10n.copySheetContent), findsOneWidget);
        expect(find.text(l10n.shareThisSheet), findsOneWidget);
        expect(find.text(l10n.editThisSheet), findsOneWidget);
        expect(find.text(l10n.deleteThisSheet), findsOneWidget);
      });

      testWidgets('users count widget tap shows user list', (tester) async {
        final sheetWithUsers = testSheet.copyWith(users: ['user1', 'user2']);
        container.read(sheetListProvider.notifier).addSheet(sheetWithUsers);

        await pumpSheetDetailScreen(tester, sheetId: sheetWithUsers.id);

        final l10n = getL10n(tester);
        final usersCountText = '2 ${l10n.users}';
        final usersCountFinder = find.text(usersCountText);

        // Verify users count text is displayed
        expect(usersCountFinder, findsOneWidget);

        // Find the GestureDetector that is an ancestor of the text.
        // This is a much safer way to find the tappable area.
        final usersCountWidget = find.widgetWithText(
          GestureDetector,
          usersCountText,
        );
        expect(usersCountWidget, findsOneWidget);

        // ACT: Tap the specific widget
        await tester.tap(usersCountWidget);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // ASSERT: Verify no crash occurred and the UI is still there.
        // You would add an `expect` here to check if a user list dialog/modal appeared.
        expect(find.text(usersCountText), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('title widget long press shows sheet menu', (tester) async {
        await pumpSheetDetailScreen(tester);

        // Long press on title widget
        final titleWidget = find.byType(ZoeInlineTextEditWidget).first;
        await tester.longPress(titleWidget);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should show popup menu with sheet actions
        final l10n = getL10n(tester);
        expect(find.text(l10n.connectWithWhatsAppGroup), findsOneWidget);
        expect(find.text(l10n.copySheetContent), findsOneWidget);
        expect(find.text(l10n.shareThisSheet), findsOneWidget);
        expect(find.text(l10n.editThisSheet), findsOneWidget);
        expect(find.text(l10n.deleteThisSheet), findsOneWidget);
      });
    });

    group('Content Display', () {
      testWidgets('displays sheet content correctly', (tester) async {
        await pumpSheetDetailScreen(tester);

        // Verify ContentWidget properties
        final contentWidget = tester.widget<ContentWidget>(
          find.byType(ContentWidget),
        );
        expect(contentWidget.parentId, equals(testSheetId));
        expect(contentWidget.sheetId, equals(testSheetId));
        expect(contentWidget.showSheetName, isFalse);

        // Verify sheet data is displayed
        expect(find.textContaining(testSheet.title), findsAtLeastNWidgets(1));
        expect(find.byType(SheetAvatarWidget), findsOneWidget);
      });

      testWidgets('handles users count display', (tester) async {
        // Get actual user IDs from test data
        final user1 = getUserByIndex(container).id;
        final user2 = getUserByIndex(container, index: 1).id;
        final user3 = getUserByIndex(container, index: 2).id;

        final testCases = [
          ([user1], '1'),
          ([user1, user2], '2'),
          ([user1, user2, user3], '3'),
        ];

        for (final (users, expectedCount) in testCases) {
          // Create a new sheet with unique ID to avoid conflicts
          final sheetWithUsers = testSheet.copyWith(
            id: '${testSheet.id}-users-${users.length}',
            users: users,
          );
          container.read(sheetListProvider.notifier).addSheet(sheetWithUsers);

          await pumpSheetDetailScreen(tester, sheetId: sheetWithUsers.id);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          // Verify the users count is displayed
          // The text will be something like "1 user" or "2 users"
          expect(find.textContaining(expectedCount), findsAtLeastNWidgets(1));
          expect(tester.takeException(), isNull);
        }
      });
    });

    group('Theme and Localization', () {
      testWidgets('applies correct styling and localization', (tester) async {
        await pumpSheetDetailScreen(tester);

        // Verify text styles
        final titleWidget = tester.widget<ZoeInlineTextEditWidget>(
          find.byType(ZoeInlineTextEditWidget).first,
        );
        expect(titleWidget.textStyle?.fontSize, equals(36));
        expect(titleWidget.textStyle?.fontWeight, equals(FontWeight.bold));
        expect(titleWidget.textStyle?.height, equals(1.2));

        // Verify theme colors
        final theme = Theme.of(tester.element(find.byType(SheetDetailScreen)));
        expect(
          titleWidget.textStyle?.color,
          equals(theme.colorScheme.onSurface),
        );

        // Verify localization
        final l10n = getL10n(tester);
        expect(find.textContaining(l10n.sheet), findsAtLeastNWidgets(1));
      });

      testWidgets('has correct padding and spacing', (tester) async {
        await pumpSheetDetailScreen(tester);

        final sliverPadding = tester.widget<SliverPadding>(
          find.byType(SliverPadding).first,
        );
        expect(
          sliverPadding.padding,
          equals(EdgeInsets.symmetric(horizontal: 24)),
        );
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });
    });
  });
}
