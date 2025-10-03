import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';

import '../../../test-utils/test_utils.dart';

/// Test utilities for ZoeSearchBar widget tests
class ZoeSearchBarTestUtils {
  /// Creates a test wrapper for the ZoeSearchBar widget
  static ZoeSearchBarWidget createTestWidget({
    TextEditingController? controller,
    Function(String)? onChanged,
    String? hintText,
    EdgeInsetsGeometry? margin,
  }) {
    return ZoeSearchBarWidget(
      controller: controller ?? TextEditingController(),
      onChanged: onChanged ?? (_) {},
      hintText: hintText,
      margin: margin,
    );
  }
}             

void main() {
  group('ZoeSearchBar Widget Tests -', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('renders with default properties correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeSearchBarTestUtils.createTestWidget(
          controller: controller,
        ),
      );

      // Verify search icon is rendered
      final icon = tester.widget<Icon>(
        find.byIcon(Icons.search),
      );
      expect(icon.size, 20);

      // Verify text field is rendered
      expect(find.byType(TextField), findsOneWidget);

      // Verify clear button is not shown initially
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('applies custom hint text correctly', (tester) async {
      const customHint = 'Custom Hint';
      await tester.pumpMaterialWidget(
        child: ZoeSearchBarTestUtils.createTestWidget(
          controller: controller,
          hintText: customHint,
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, customHint);
    });

    testWidgets('applies custom margin correctly', (tester) async {
      const customMargin = EdgeInsets.all(16);
      await tester.pumpMaterialWidget(
        child: ZoeSearchBarTestUtils.createTestWidget(
          controller: controller,
          margin: customMargin,
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.margin, customMargin);
    });

    testWidgets('shows clear button when text is entered', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeSearchBarTestUtils.createTestWidget(
          controller: controller,
        ),
      );

      // Initially no clear button
      expect(find.byIcon(Icons.clear), findsNothing);

      // Enter text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Clear button should be visible
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('hides clear button when text is cleared', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeSearchBarTestUtils.createTestWidget(
          controller: controller,
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Clear button should be visible
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Clear text
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      // Clear button should be hidden
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('clears text when clear button is tapped', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeSearchBarTestUtils.createTestWidget(
          controller: controller,
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Text should be cleared
      expect(controller.text, isEmpty);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('calls onChanged when text changes', (tester) async {
      String? changedText;
      await tester.pumpMaterialWidget(
        child: ZoeSearchBarTestUtils.createTestWidget(
          controller: controller,
          onChanged: (value) => changedText = value,
        ),
      );

      // Enter text
      const testText = 'test';
      await tester.enterText(find.byType(TextField), testText);
      await tester.pump();

      expect(changedText, equals(testText));
    });
  });
}
