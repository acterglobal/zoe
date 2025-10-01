import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_button_widget.dart';

import '../../../helpers/test_utils.dart';

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

    testWidgets('navigates back by default when no onBackPressed is provided', (
      tester,
    ) async {
      // Setup a navigation stack
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Scaffold(body: ZoeAppBar()),
                    ),
                  );
                },
                child: Text('Push Route'),
              ),
            ),
          ),
        ),
      );

      // Push new route
      await tester.tap(find.text('Push Route'));
      await tester.pumpAndSettle();

      // Verify we're on the new route
      expect(find.byType(ZoeAppBar), findsOneWidget);

      // Tap back button
      await tester.tap(find.byType(ZoeIconButtonWidget));
      await tester.pumpAndSettle();

      // Verify we navigated back
      expect(find.byType(ZoeAppBar), findsNothing);
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
