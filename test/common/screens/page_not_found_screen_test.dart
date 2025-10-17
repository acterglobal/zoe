import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/screens/page_not_found_screen.dart';
import 'package:zoe/core/routing/app_routes.dart';
import '../../test-utils/test_utils.dart';
import '../../test-utils/mock_gorouter.dart';

void main() {
  group('PageNotFoundScreen', () {
    late MockGoRouter mockGoRouter;

    setUp(() {
      mockGoRouter = MockGoRouter();

      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenReturn(null);
    });

    Future<void> pumpPageNotFoundScreen(WidgetTester tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer.test(),
        child: const PageNotFoundScreen(),
        router: mockGoRouter,
      );
    }

    group('Rendering', () {
      testWidgets('renders all main components', (tester) async {
        await pumpPageNotFoundScreen(tester);

        // Check for main components - use atLeast to account for test framework widgets
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(Center), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(
          find.byType(Text),
          findsAtLeastNWidgets(2),
        ); // Title and description
      });

      testWidgets('displays correct app bar', (tester) async {
        await pumpPageNotFoundScreen(tester);

        // Check app bar title - using a more generic approach
        expect(find.byType(AppBar), findsOneWidget);

        // Check back button
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      });

      testWidgets('displays error icon', (tester) async {
        await pumpPageNotFoundScreen(tester);

        final iconFinder = find.byIcon(Icons.error_outline);
        expect(iconFinder, findsOneWidget);

        // Check icon size
        final iconWidget = tester.widget<Icon>(iconFinder);
        expect(iconWidget.size, equals(64));
      });

      testWidgets('displays page not found title', (tester) async {
        await pumpPageNotFoundScreen(tester);

        // Find text with bold styling (title)
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        final titleWidget = textWidgets.firstWhere(
          (text) => text.style?.fontWeight == FontWeight.bold,
        );

        expect(titleWidget, isNotNull);
        expect(titleWidget.style?.fontSize, equals(24));
        expect(titleWidget.style?.fontWeight, equals(FontWeight.bold));
      });

      testWidgets('displays page not found description', (tester) async {
        await pumpPageNotFoundScreen(tester);

        // Find text with normal styling (description)
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        final descriptionWidget = textWidgets.firstWhere(
          (text) =>
              text.style?.fontWeight != FontWeight.bold &&
              text.style?.fontSize == 16,
        );

        expect(descriptionWidget, isNotNull);
        expect(descriptionWidget.style?.fontSize, equals(16));
      });

      testWidgets('has proper spacing between elements', (tester) async {
        await pumpPageNotFoundScreen(tester);

        // Check for SizedBox widgets (spacing) - there might be more due to test framework
        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));

        // Verify spacing values
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.height == 16), isTrue);
        expect(sizedBoxes.any((box) => box.height == 8), isTrue);
      });
    });

    group('Navigation', () {
      testWidgets('back button is present and tappable', (tester) async {
        await pumpPageNotFoundScreen(tester);

        final backButton = find.byIcon(Icons.arrow_back_rounded);
        expect(backButton, findsOneWidget);

        // Verify it's tappable
        expect(
          tester
              .widget<IconButton>(
                find.ancestor(
                  of: backButton,
                  matching: find.byType(IconButton),
                ),
              )
              .onPressed,
          isNotNull,
        );
      });
      testWidgets('back button navigates to home route', (tester) async {
        await pumpPageNotFoundScreen(tester);

        // Tap the back button
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        // Verify navigation was called
        verify(() => mockGoRouter.go(AppRoutes.home.route)).called(1);
      });
    });

    group('Layout', () {
      testWidgets('elements are arranged in correct order', (tester) async {
        await pumpPageNotFoundScreen(tester);

        // Get all children of the Column
        final columnWidget = tester.widget<Column>(find.byType(Column));
        final children = columnWidget.children;

        expect(
          children.length,
          equals(5),
        ); // Icon, SizedBox, Text, SizedBox, Text

        // Check order: Icon, SizedBox, Text (title), SizedBox, Text (description)
        expect(children[0], isA<Icon>());
        expect(children[1], isA<SizedBox>());
        expect(children[2], isA<Text>());
        expect(children[3], isA<SizedBox>());
        expect(children[4], isA<Text>());
      });
    });

    group('Edge Cases', () {
      testWidgets('handles different screen sizes', (tester) async {
        // Test with different screen sizes
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await pumpPageNotFoundScreen(tester);

        expect(find.byType(PageNotFoundScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));

        // Reset screen size
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('maintains layout on small screens', (tester) async {
        await tester.binding.setSurfaceSize(const Size(300, 600));
        await pumpPageNotFoundScreen(tester);

        // All elements should still be visible
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.byType(Text), findsAtLeastNWidgets(2));

        // Reset screen size
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
