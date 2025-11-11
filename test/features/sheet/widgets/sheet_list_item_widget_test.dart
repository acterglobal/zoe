import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart' as sheet_model;
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_item_widget.dart';
import '../../../test-utils/test_utils.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../utils/sheet_utils.dart';

void main() {
  group('SheetListItemWidget Tests', () {
    late ProviderContainer container;
    late sheet_model.SheetModel testSheet;
    late MockGoRouter mockGoRouter;

    setUp(() {
      container = ProviderContainer.test();
      testSheet = getSheetByIndex(container);
      mockGoRouter = MockGoRouter();

      // Set up mock methods
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenReturn(null);
      when(() => mockGoRouter.push(any())).thenAnswer((_) async => true);
    });

    Future<void> pumpSheetListItemWidget(
      WidgetTester tester, {
      String? sheetId,
      bool isCompact = false,
    }) async {
      final effectiveSheetId = sheetId ?? testSheet.id;
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: SheetListItemWidget(
          sheetId: effectiveSheetId,
          isCompact: isCompact,
        ),
        router: mockGoRouter,
      );
    }

    group('Widget Rendering', () {
      testWidgets('renders compact design when isCompact is true', (
        tester,
      ) async {
        await pumpSheetListItemWidget(tester, isCompact: true);

        // Verify GlassyContainer is not used for compact design
        expect(find.byType(GlassyContainer), findsNothing);
      });

      testWidgets('renders SizedBox.shrink when sheet is null', (tester) async {
        await pumpSheetListItemWidget(tester, sheetId: 'non-existent-sheet');

        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(GlassyContainer), findsNothing);
        expect(find.byType(Container), findsNothing);
      });
    });

    group('UI Elements', () {
      testWidgets('displays all required UI elements in expanded design', (
        tester,
      ) async {
        await pumpSheetListItemWidget(tester);

        // Verify emoji container
        expect(find.byType(StyledContentContainer), findsOneWidget);
        expect(find.byType(SheetAvatarWidget), findsOneWidget);

        // Verify content section
        expect(find.text(testSheet.title), findsOneWidget);
        expect(
          find.text(testSheet.description?.plainText ?? ''),
          findsOneWidget,
        );

        // Verify chevron icon
        expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
      });
    });

    group('Styling and Layout', () {
      testWidgets('applies correct styling for expanded design', (
        tester,
      ) async {
        await pumpSheetListItemWidget(tester);

        // Verify GlassyContainer has correct margin
        final glassyContainer = tester.widget<GlassyContainer>(
          find.byType(GlassyContainer),
        );
        expect(
          glassyContainer.margin,
          equals(const EdgeInsets.only(bottom: 16)),
        );
        expect(glassyContainer.padding, equals(const EdgeInsets.all(12)));
      });

      testWidgets('applies correct styling for compact design', (tester) async {
        await pumpSheetListItemWidget(tester, isCompact: true);

        // Find the main container (the one with padding: EdgeInsets.all(8))
        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (container) => container.padding == const EdgeInsets.all(8),
        );
        expect(mainContainer.padding, equals(const EdgeInsets.all(8)));
        expect(mainContainer.decoration, isA<BoxDecoration>());
      });

      testWidgets('uses correct emoji container size based on isCompact', (
        tester,
      ) async {
        // Test expanded design
        await pumpSheetListItemWidget(tester);
        final expandedContainer = tester.widget<StyledContentContainer>(
          find.byType(StyledContentContainer),
        );
        expect(expandedContainer.size, equals(56));

        await tester.pumpWidget(Container()); // Clear

        // Test compact design
        await pumpSheetListItemWidget(tester, isCompact: true);
        final compactContainer = tester.widget<StyledContentContainer>(
          find.byType(StyledContentContainer),
        );
        expect(compactContainer.size, equals(34));
      });

      testWidgets('applies correct text styling', (tester) async {
        await pumpSheetListItemWidget(tester);

        // Find title text
        final titleText = tester.widget<Text>(find.text(testSheet.title));
        expect(titleText.maxLines, equals(1));
        expect(titleText.overflow, equals(TextOverflow.ellipsis));

        // Find description text
        final descriptionText = tester.widget<Text>(
          find.text(testSheet.description?.plainText ?? ''),
        );
        expect(descriptionText.maxLines, equals(2));
        expect(descriptionText.overflow, equals(TextOverflow.ellipsis));
      });
    });

    group('Navigation', () {
      testWidgets('navigates to sheet detail on tap', (tester) async {
        await pumpSheetListItemWidget(tester);

        // Tap the widget
        await tester.tap(find.byType(SheetListItemWidget));
        await tester.pumpAndSettle();

        // Verify navigation was called with correct route
        final expectedRoute = AppRoutes.sheet.route.replaceAll(
          ':sheetId',
          testSheet.id,
        );
        verify(() => mockGoRouter.push(expectedRoute)).called(1);
      });

      testWidgets('pops context before navigation if canPop returns true', (
        tester,
      ) async {
        when(() => mockGoRouter.canPop()).thenReturn(true);

        await pumpSheetListItemWidget(tester);

        // Tap the widget
        await tester.tap(find.byType(SheetListItemWidget));
        await tester.pumpAndSettle();

        // Verify pop was called before push
        verify(() => mockGoRouter.pop()).called(1);
        verify(() => mockGoRouter.push(any())).called(1);
      });

      testWidgets('does not pop context if canPop returns false', (
        tester,
      ) async {
        when(() => mockGoRouter.canPop()).thenReturn(false);

        await pumpSheetListItemWidget(tester);

        // Tap the widget
        await tester.tap(find.byType(SheetListItemWidget));
        await tester.pumpAndSettle();

        // Verify pop was not called
        verifyNever(() => mockGoRouter.pop());
        verify(() => mockGoRouter.push(any())).called(1);
      });

      testWidgets('navigation works for both compact and expanded designs', (
        tester,
      ) async {
        // Test expanded design
        await pumpSheetListItemWidget(tester);
        await tester.tap(find.byType(SheetListItemWidget));
        await tester.pumpAndSettle();

        verify(() => mockGoRouter.push(any())).called(1);

        // Clear and reset mock
        await tester.pumpWidget(Container());
        reset(mockGoRouter);
        when(() => mockGoRouter.canPop()).thenReturn(true);
        when(() => mockGoRouter.pop()).thenReturn(null);
        when(() => mockGoRouter.push(any())).thenAnswer((_) async => true);

        // Test compact design
        await pumpSheetListItemWidget(tester, isCompact: true);
        await tester.tap(find.byType(SheetListItemWidget));
        await tester.pumpAndSettle();

        verify(() => mockGoRouter.push(any())).called(1);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles special characters in title and description', (
        tester,
      ) async {
        final specialCharSheet = testSheet.copyWith(
          title: r'Title with special chars: @#$%^&*()_+-=[]{}|;:,.<>?',
          description: (
            plainText:
                r'Description with special chars: @#$%^&*()_+-=[]{}|;:,.<>?',
            htmlText:
                r'<p>Description with special chars: @#$%^&*()_+-=[]{}|;:,.<>?</p>',
          ),
        );
        container = ProviderContainer.test(
          overrides: [
            sheetProvider(testSheet.id).overrideWith((ref) => specialCharSheet),
          ],
        );

        await pumpSheetListItemWidget(tester);

        expect(find.text(specialCharSheet.title), findsOneWidget);
        expect(
          find.text(specialCharSheet.description!.plainText!),
          findsOneWidget,
        );
      });

      testWidgets('handles empty title gracefully', (tester) async {
        final emptyTitleSheet = testSheet.copyWith(title: '');
        container = ProviderContainer.test(
          overrides: [
            sheetProvider(testSheet.id).overrideWith((ref) => emptyTitleSheet),
          ],
        );

        await pumpSheetListItemWidget(tester);

        expect(find.text(''), findsOneWidget);
      });

      testWidgets('handles different emoji sizes', (tester) async {
        final emojiSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(type: AvatarType.emoji, data: '🔥'),
        );
        container = ProviderContainer.test(
          overrides: [
            sheetProvider(testSheet.id).overrideWith((ref) => emojiSheet),
          ],
        );

        await pumpSheetListItemWidget(tester);

        expect(find.byType(SheetAvatarWidget), findsOneWidget);
        expect(find.text('🔥'), findsOneWidget);
      });
    });
  });
}
