import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';

import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';

/// Test utilities for ZoeAppBar widget tests
class ZoeAppBarTestUtils {
  /// Creates a test wrapper for the ZoeAppBar widget
  static Widget createTestWidget({
    String? title,
    VoidCallback? onBackPressed,
    bool showBackButton = true,
    List<Widget>? actions,
    TextStyle? titleStyle,
  }) {
    return ZoeAppBar(
      title: title,
      onBackPressed: onBackPressed,
      showBackButton: showBackButton,
      actions: actions,
      titleStyle: titleStyle,
    );
  }

  /// Creates test actions for the app bar
  static List<Widget> createTestActions({int count = 1}) {
    return List.generate(
      count,
      (index) =>
          TextButton(onPressed: () {}, child: Text('Action ${index + 1}')),
    );
  }
}

void main() {
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockGoRouter = MockGoRouter();
  });

  group('ZoeAppBar Widget Tests -', () {
    testWidgets('renders with default properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeAppBarTestUtils.createTestWidget(),
      );

      // Verify back button is shown by default
      expect(find.byType(ZoeIconButtonWidget), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // Verify Spacer is used when no title
      expect(find.byType(Spacer), findsOneWidget);
    });

    testWidgets('renders title correctly', (tester) async {
      const testTitle = 'Test Title';
      await tester.pumpMaterialWidget(
        child: ZoeAppBarTestUtils.createTestWidget(title: testTitle),
      );

      // Verify title is shown
      expect(find.text(testTitle), findsOneWidget);
      expect(find.byType(Spacer), findsNothing);
    });

    testWidgets('renders without back button when showBackButton is false', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: ZoeAppBarTestUtils.createTestWidget(showBackButton: false),
      );

      // Verify back button is not shown
      expect(find.byType(ZoeIconButtonWidget), findsNothing);
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
    });

    testWidgets('calls onBackPressed when back button is tapped', (
      tester,
    ) async {
      bool backPressed = false;
      await tester.pumpMaterialWidget(
        child: ZoeAppBarTestUtils.createTestWidget(
          onBackPressed: () => backPressed = true,
        ),
      );

      // Tap back button
      await tester.tap(find.byType(ZoeIconButtonWidget));
      await tester.pump();
      expect(backPressed, true);
    });

    testWidgets('navigates back (pops) when canPop is true', (tester) async {
      // ARRANGE: Stub the router to allow popping
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenReturn(null);

      // Wrap ZoeAppBar in a router to provide context
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockGoRouter.navigator(
              router: mockGoRouter,
              child: ZoeAppBarTestUtils.createTestWidget(),
            ),
          ),
        ),
      );

      // ACT: Tap the back button
      await tester.tap(find.byType(ZoeIconButtonWidget));
      await tester.pumpAndSettle();

      // ASSERT: Verify that pop() was called
      verify(() => mockGoRouter.pop()).called(1);
    });

    testWidgets('navigates to home when canPop is false', (tester) async {
      // ARRANGE: Stub the router to disallow popping and mock the `go` method
      when(() => mockGoRouter.canPop()).thenReturn(false);
      when(() => mockGoRouter.go(AppRoutes.home.route)).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockGoRouter.navigator(
              router: mockGoRouter,
              child: ZoeAppBarTestUtils.createTestWidget(),
            ),
          ),
        ),
      );

      // ACT: Tap the back button
      await tester.tap(find.byType(ZoeIconButtonWidget));
      await tester.pumpAndSettle();

      // ASSERT: Verify that go('/home') was called
      verify(() => mockGoRouter.go(AppRoutes.home.route)).called(1);
      // Verify that pop() was NOT called
      verifyNever(() => mockGoRouter.pop());
    });

    testWidgets('renders actions correctly', (tester) async {
      final testActions = ZoeAppBarTestUtils.createTestActions(count: 2);
      await tester.pumpMaterialWidget(
        child: ZoeAppBarTestUtils.createTestWidget(actions: testActions),
      );

      // Verify actions are shown
      expect(find.byType(TextButton), findsNWidgets(2));
      expect(find.text('Action 1'), findsOneWidget);
      expect(find.text('Action 2'), findsOneWidget);
    });

    testWidgets('applies custom title style correctly', (tester) async {
      const testTitle = 'Test Title';
      const customStyle = TextStyle(
        fontSize: 24,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpMaterialWidget(
        child: ZoeAppBarTestUtils.createTestWidget(
          title: testTitle,
          titleStyle: customStyle,
        ),
      );

      // Verify custom style is applied
      final titleWidget = tester.widget<Text>(find.text(testTitle));
      expect(titleWidget.style, customStyle);
    });

    testWidgets('handles long titles gracefully', (tester) async {
      const longTitle =
          'This is a very long title that should be handled gracefully by the app bar';
      await tester.pumpMaterialWidget(
        child: ZoeAppBarTestUtils.createTestWidget(title: longTitle),
      );

      // Verify title is rendered without overflow
      expect(find.text(longTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
