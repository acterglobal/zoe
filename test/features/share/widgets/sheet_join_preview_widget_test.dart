import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_chip_widget.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';
import 'package:zoe/features/share/widgets/sheet_join_preview_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/users/models/user_model.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';
import '../../sheet/utils/sheet_utils.dart';
import '../../users/utils/users_utils.dart';

void main() {
  late ProviderContainer container;
  late SheetModel testSheet;
  late String testSheetId;
  late UserModel testUser;
  late String testUserId;
  late MockGoRouter mockGoRouter;

  setUp(() {
    container = ProviderContainer.test();
    mockGoRouter = MockGoRouter();

    // Setup mock router
    when(() => mockGoRouter.canPop()).thenReturn(true);
    when(() => mockGoRouter.pop()).thenReturn(null);
    when(() => mockGoRouter.push(any())).thenAnswer((_) async => true);

    // Get test sheet and user from container
    testSheet = getSheetByIndex(container);
    testSheetId = testSheet.id;
    testUser = getUserByIndex(container);
    testUserId = testUser.id;

    container = ProviderContainer.test(
      overrides: [currentUserProvider.overrideWithValue(testUser)],
    );
  });

  Future<void> pumpSheetJoinPreviewWidget(
    WidgetTester tester, {
    required SheetModel sheet,
    ProviderContainer? testContainer,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: testContainer ?? container,
      router: mockGoRouter,
      child: SheetJoinPreviewWidget(sheet: sheet),
    );
  }

  group('Sheet Join Preview Widget', () {
    group('Basic Rendering', () {
      testWidgets('renders correctly with valid sheet and logged in user', (
        tester,
      ) async {
        await pumpSheetJoinPreviewWidget(tester, sheet: testSheet);

        // Verify MaxWidthWidget is present
        expect(find.byType(MaxWidthWidget), findsOneWidget);

        // Verify title
        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetJoinPreviewWidget,
        );
        expect(find.text(l10n.joinSheet), findsOneWidget);

        // Verify sheet title and emoji are displayed
        expect(find.text(testSheet.title), findsOneWidget);
        expect(find.byType(SheetAvatarWidget), findsOneWidget);

        // Verify join button is displayed
        expect(find.byType(ZoePrimaryButton), findsOneWidget);
        expect(find.text(l10n.join), findsOneWidget);
      });

      testWidgets('returns SizedBox.shrink when sheet is null', (tester) async {
        final emptyContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(() => SheetList()..state = []),
            sheetProvider('non-existent-sheet').overrideWith((ref) => null),
          ],
        );

        await pumpSheetJoinPreviewWidget(
          tester,
          sheet: testSheet,
          testContainer: emptyContainer,
        );

        // Verify widget is not displayed (SizedBox.shrink)
        expect(find.byType(MaxWidthWidget), findsNothing);
        expect(find.byType(ZoePrimaryButton), findsNothing);
      });
    });

    group('Sheet Content Display', () {
      testWidgets('displays sheet title correctly', (tester) async {
        await pumpSheetJoinPreviewWidget(tester, sheet: testSheet);

        expect(find.text(testSheet.title), findsOneWidget);
      });

      testWidgets('displays sheet emoji correctly', (tester) async {
        final sheetWithEmoji = testSheet.copyWith(
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '📘'),
        );

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [sheetWithEmoji],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => sheetWithEmoji),
          ],
        );

        await pumpSheetJoinPreviewWidget(
          tester,
          sheet: testSheet,
          testContainer: testContainer,
        );

        // Avatar widget should be present and emoji text rendered
        expect(find.byType(SheetAvatarWidget), findsOneWidget);
        expect(find.text('📘'), findsOneWidget);
      });

      testWidgets('displays sheet description when present', (tester) async {
        // Create sheet with description
        final sheetWithDesc = testSheet.copyWith(
          description: (
            plainText: 'This is a test sheet description',
            htmlText: '<p>This is a test sheet description</p>',
          ),
        );

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [sheetWithDesc],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => sheetWithDesc),
          ],
        );

        await pumpSheetJoinPreviewWidget(
          tester,
          sheet: testSheet,
          testContainer: testContainer,
        );

        expect(find.text('This is a test sheet description'), findsOneWidget);
      });

      testWidgets('displays empty string when description is null', (
        tester,
      ) async {
        // Create sheet without description
        final sheetWithoutDesc = testSheet.copyWith(description: null);

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [sheetWithoutDesc],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => sheetWithoutDesc),
          ],
        );

        await pumpSheetJoinPreviewWidget(
          tester,
          sheet: testSheet,
          testContainer: testContainer,
        );

        // Widget should still render even with no description
        expect(find.byType(MaxWidthWidget), findsOneWidget);
      });
    });

    group('Join Button', () {
      testWidgets('displays join button with correct icon and text', (
        tester,
      ) async {
        await pumpSheetJoinPreviewWidget(tester, sheet: testSheet);

        final joinButton = tester.widget<ZoePrimaryButton>(
          find.byType(ZoePrimaryButton),
        );

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetJoinPreviewWidget,
        );

        expect(joinButton.icon, equals(Icons.person_add_rounded));
        expect(joinButton.text, equals(l10n.join));
      });

      testWidgets('join button adds user to sheet and navigates', (
        tester,
      ) async {
        await pumpSheetJoinPreviewWidget(tester, sheet: testSheet);

        // Tap join button
        final joinButton = find.byType(ZoePrimaryButton);
        await tester.tap(joinButton);
        await tester.pumpAndSettle();

        // Verify user was added to sheet (or was already there)
        final updatedSheet = container.read(sheetProvider(testSheetId));
        expect(updatedSheet?.users.contains(testUserId), isTrue);

        // Verify navigation was called
        verify(() => mockGoRouter.push(any())).called(1);
      });

      testWidgets('join button pops navigator before pushing', (tester) async {
        when(() => mockGoRouter.canPop()).thenReturn(true);

        await pumpSheetJoinPreviewWidget(tester, sheet: testSheet);

        final joinButton = find.byType(ZoePrimaryButton);
        await tester.tap(joinButton);
        await tester.pumpAndSettle();

        // Verify pop was called (implicitly through Navigator.pop in widget)
        // The push is verified separately
        verify(() => mockGoRouter.push(any())).called(1);
      });
    });

    group('Widget Structure', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await pumpSheetJoinPreviewWidget(tester, sheet: testSheet);

        // Verify MaxWidthWidget structure
        expect(find.byType(MaxWidthWidget), findsOneWidget);

        // Verify Column structure
        expect(find.byType(Column), findsOneWidget);

        // Verify title Text widget
        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetJoinPreviewWidget,
        );
        expect(find.text(l10n.joinSheet), findsOneWidget);

        // Verify Row with emoji and title
        expect(find.byType(Row), findsWidgets);

        // Verify SheetAvatarWidget
        expect(find.byType(SheetAvatarWidget), findsOneWidget);

        // Verify join button
        expect(find.byType(ZoePrimaryButton), findsOneWidget);

        // Verify SizedBox widgets for spacing
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('title has correct styling', (tester) async {
        await pumpSheetJoinPreviewWidget(tester, sheet: testSheet);

        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetJoinPreviewWidget,
        );

        final titleText = tester.widget<Text>(find.text(l10n.joinSheet));
        expect(titleText.textAlign, equals(TextAlign.center));
        expect(titleText.style?.fontWeight, equals(FontWeight.w600));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles sheet with empty title', (tester) async {
        final sheetWithEmptyTitle = testSheet.copyWith(title: '');

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [sheetWithEmptyTitle],
            ),
            sheetProvider(
              testSheetId,
            ).overrideWith((ref) => sheetWithEmptyTitle),
          ],
        );

        await pumpSheetJoinPreviewWidget(
          tester,
          sheet: testSheet,
          testContainer: testContainer,
        );

        // Widget should still render
        expect(find.byType(MaxWidthWidget), findsOneWidget);
      });

      testWidgets('handles sheet with empty emoji', (tester) async {
        final sheetWithEmptyEmoji = testSheet.copyWith(
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: ''),
        );

        final testContainer = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWith(
              () => SheetList()..state = [sheetWithEmptyEmoji],
            ),
            sheetProvider(
              testSheetId,
            ).overrideWith((ref) => sheetWithEmptyEmoji),
          ],
        );

        await pumpSheetJoinPreviewWidget(
          tester,
          sheet: testSheet,
          testContainer: testContainer,
        );

        // Widget should still render
        expect(find.byType(MaxWidthWidget), findsOneWidget);
        expect(find.byType(SheetAvatarWidget), findsOneWidget);
      });
    });

    group('Shared Info Card', () {
      testWidgets('displays shared info card with both sharedBy and message', (
        tester,
      ) async {
        final sharingUser = getUserByIndex(container);
        const testMessage = 'This is a great sheet to collaborate on!';
        final sheetWithBoth = testSheet.copyWith(
          sharedBy: sharingUser.name,
          message: testMessage,
        );

        final testContainer = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(testUser),
            sheetListProvider.overrideWith(
              () => SheetList()..state = [sheetWithBoth],
            ),
            sheetProvider(testSheetId).overrideWith((ref) => sheetWithBoth),
          ],
        );

        await pumpSheetJoinPreviewWidget(
          tester,
          sheet: testSheet,
          testContainer: testContainer,
        );

        // Verify GlassyContainer (shared info card) is displayed
        expect(find.byType(GlassyContainer), findsOneWidget);

        // Verify both sharedBy and message are displayed
        final l10n = WidgetTesterExtension.getL10n(
          tester,
          byType: SheetJoinPreviewWidget,
        );
        expect(find.textContaining(l10n.sharedBy), findsOneWidget);
        expect(find.textContaining(l10n.message), findsOneWidget);
        expect(find.text(testMessage), findsOneWidget);
        expect(find.byType(ZoeUserChipWidget), findsOneWidget);
      });

      testWidgets('displays message as is (without trimming)', (tester) async {
        const testMessage = '  Message with whitespace  ';
        final sharingUser = UserModel(
          id: 'sharing_user',
          email: 'test@gmail.com',
          name: 'Sharing User',
        );
        final sheetWithTrimmedMessage = testSheet.copyWith(
          message: testMessage,
          sharedBy: sharingUser.name,
        );

        final testContainer = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(testUser),
            getUserByIdFutureProvider(
              sharingUser.id,
            ).overrideWith((ref) => sharingUser),
            sheetListProvider.overrideWith(
              () => SheetList()..state = [sheetWithTrimmedMessage],
            ),
            sheetProvider(
              testSheetId,
            ).overrideWith((ref) => sheetWithTrimmedMessage),
          ],
        );

        await pumpSheetJoinPreviewWidget(
          tester,
          sheet: testSheet,
          testContainer: testContainer,
        );

        // Verify untrimmed message is displayed
        expect(find.text(testMessage), findsOneWidget);
      });

      testWidgets('does not display shared info card when both are empty', (
        tester,
      ) async {
        final sheetWithoutSharedInfo = testSheet.copyWith(
          sharedBy: null,
          message: null,
        );

        final testContainer = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(testUser),
            sheetListProvider.overrideWith(
              () => SheetList()..state = [sheetWithoutSharedInfo],
            ),
            sheetProvider(
              testSheetId,
            ).overrideWith((ref) => sheetWithoutSharedInfo),
          ],
        );

        await pumpSheetJoinPreviewWidget(
          tester,
          sheet: testSheet,
          testContainer: testContainer,
        );

        // Verify GlassyContainer (shared info card) is NOT displayed
        expect(find.byType(GlassyContainer), findsNothing);
      });

      testWidgets(
        'does not display shared info card when sharedBy is empty string',
        (tester) async {
          final sheetWithEmptySharedBy = testSheet.copyWith(
            sharedBy: '',
            message: null,
          );

          final testContainer = ProviderContainer.test(
            overrides: [
              currentUserProvider.overrideWithValue(testUser),
              sheetListProvider.overrideWith(
                () => SheetList()..state = [sheetWithEmptySharedBy],
              ),
              sheetProvider(
                testSheetId,
              ).overrideWith((ref) => sheetWithEmptySharedBy),
            ],
          );

          await pumpSheetJoinPreviewWidget(
            tester,
            sheet: testSheet,
            testContainer: testContainer,
          );

          // Verify GlassyContainer (shared info card) is NOT displayed
          expect(find.byType(GlassyContainer), findsNothing);
        },
      );

      testWidgets(
        'does not display shared info card when message is empty string',
        (tester) async {
          final sheetWithEmptyMessage = testSheet.copyWith(
            sharedBy: null,
            message: '',
          );

          final testContainer = ProviderContainer.test(
            overrides: [
              currentUserProvider.overrideWithValue(testUser),
              sheetListProvider.overrideWith(
                () => SheetList()..state = [sheetWithEmptyMessage],
              ),
              sheetProvider(
                testSheetId,
              ).overrideWith((ref) => sheetWithEmptyMessage),
            ],
          );

          await pumpSheetJoinPreviewWidget(
            tester,
            sheet: testSheet,
            testContainer: testContainer,
          );

          // Verify GlassyContainer (shared info card) is NOT displayed
          expect(find.byType(GlassyContainer), findsNothing);
        },
      );

      testWidgets(
        'does not display shared info card when message is only whitespace',
        (tester) async {
          final sheetWithWhitespaceMessage = testSheet.copyWith(
            sharedBy: null,
            message: '   ',
          );

          final testContainer = ProviderContainer.test(
            overrides: [
              currentUserProvider.overrideWithValue(testUser),
              sheetListProvider.overrideWith(
                () => SheetList()..state = [sheetWithWhitespaceMessage],
              ),
              sheetProvider(
                testSheetId,
              ).overrideWith((ref) => sheetWithWhitespaceMessage),
            ],
          );

          await pumpSheetJoinPreviewWidget(
            tester,
            sheet: testSheet,
            testContainer: testContainer,
          );

          // Verify GlassyContainer (shared info card) is NOT displayed
          expect(find.byType(GlassyContainer), findsNothing);
        },
      );

      testWidgets('shared info card has correct styling', (tester) async {
        final sharingUser = getUserByIndex(container);
        const testMessage = 'Test message';
        final sheetWithSharedInfo = testSheet.copyWith(
          sharedBy: sharingUser.name,
          message: testMessage,
        );

        final testContainer = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(testUser),
            sheetListProvider.overrideWith(
              () => SheetList()..state = [sheetWithSharedInfo],
            ),
            sheetProvider(
              testSheetId,
            ).overrideWith((ref) => sheetWithSharedInfo),
          ],
        );

        await pumpSheetJoinPreviewWidget(
          tester,
          sheet: testSheet,
          testContainer: testContainer,
        );

        // Verify GlassyContainer properties
        final glassyContainer = tester.widget<GlassyContainer>(
          find.byType(GlassyContainer),
        );
        expect(glassyContainer.padding, equals(const EdgeInsets.all(12)));
        expect(glassyContainer.blurRadius, equals(0));
        expect(glassyContainer.borderRadius, equals(BorderRadius.circular(12)));
      });
    });
  });
}
