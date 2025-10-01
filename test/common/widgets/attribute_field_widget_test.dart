import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/attribute_field_widget.dart';

import '../../test-utils/test_utils.dart';

/// Test utilities for AttributeFieldWidget tests
class AttributeFieldWidgetTestUtils {
  /// Creates a test wrapper for the AttributeFieldWidget
  static AttributeFieldWidget createTestWidget({
    IconData icon = Icons.star,
    String title = 'Test Title',
    bool isEditing = false,
    VoidCallback? onTapValue,
    Widget? valueWidget,
  }) {
    return AttributeFieldWidget(
      icon: icon,
      title: title,
      isEditing: isEditing,
      onTapValue: onTapValue,
      valueWidget: valueWidget ?? const Text('Test Value'),
    );
  }
}

void main() {
  group('AttributeFieldWidget Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(AttributeFieldWidget), findsOneWidget);
      expect(find.byType(Row), findsAtLeastNWidgets(1));
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsAtLeastNWidgets(1));
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('displays icon correctly', (tester) async {
      const testIcon = Icons.person;

      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(icon: testIcon),
      );

      // Verify icon is displayed
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, testIcon);
      expect(icon.size, 18);
    });

    testWidgets('displays title correctly', (tester) async {
      const testTitle = 'Custom Title';

      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(title: testTitle),
      );

      // Verify title is displayed
      expect(find.text(testTitle), findsOneWidget);

      // Verify title text properties
      final titleText = tester.widget<Text>(find.text(testTitle));
      expect(titleText.maxLines, 1);
      expect(titleText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('renders valueWidget correctly', (tester) async {
      const testValueWidget = Text('Custom Value Widget');

      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(
          valueWidget: testValueWidget,
        ),
      );

      // Verify valueWidget is rendered
      expect(find.text('Custom Value Widget'), findsOneWidget);
    });

    testWidgets('handles isEditing false by default', (tester) async {
      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(),
      );

      // Verify GestureDetector is present but not enabled
      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetector.onTap, isNull);
    });

    testWidgets('enables onTap when isEditing is true', (tester) async {
      bool tapped = false;

      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(
          isEditing: true,
          onTapValue: () => tapped = true,
        ),
      );

      // Verify GestureDetector has onTap callback
      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetector.onTap, isNotNull);

      // Test tap functionality
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('disables onTap when isEditing is false', (tester) async {
      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(
          isEditing: false,
          onTapValue: () {},
        ),
      );

      // Verify GestureDetector has no onTap callback
      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetector.onTap, isNull);
    });

    testWidgets('handles null onTapValue callback', (tester) async {
      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(
          isEditing: true,
          onTapValue: null,
        ),
      );

      // Verify GestureDetector has no onTap callback even when isEditing is true
      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetector.onTap, isNull);
    });

    testWidgets('handles different icon types', (tester) async {
      final icons = [
        Icons.star,
        Icons.person,
        Icons.email,
        Icons.phone,
        Icons.location_on,
      ];

      for (final icon in icons) {
        await tester.pumpMaterialWidget(
          child: AttributeFieldWidgetTestUtils.createTestWidget(icon: icon),
        );

        // Verify icon is displayed
        final iconWidget = tester.widget<Icon>(find.byType(Icon));
        expect(iconWidget.icon, icon);
        expect(iconWidget.size, 18);
      }
    });

    testWidgets('handles different valueWidget types', (tester) async {
      final valueWidgets = [
        const Text('Text Value'),
        const Icon(Icons.check),
        const Chip(label: Text('Chip Value')),
        const SizedBox(width: 50, height: 20),
      ];

      for (final valueWidget in valueWidgets) {
        await tester.pumpMaterialWidget(
          child: AttributeFieldWidgetTestUtils.createTestWidget(
            valueWidget: valueWidget,
          ),
        );

        // Verify valueWidget is rendered
        expect(find.byWidget(valueWidget), findsOneWidget);
      }
    });

    testWidgets('handles tap when editing is enabled', (tester) async {
      int tapCount = 0;

      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(
          isEditing: true,
          onTapValue: () => tapCount++,
        ),
      );

      // Test multiple taps
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      expect(tapCount, 1);

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      expect(tapCount, 2);
    });

    testWidgets('does not respond to tap when editing is disabled', (
      tester,
    ) async {
      int tapCount = 0;

      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(
          isEditing: false,
          onTapValue: () => tapCount++,
        ),
      );

      // Test tap (should not trigger callback)
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      expect(tapCount, 0);
    });

    testWidgets('handles empty title', (tester) async {
      await tester.pumpMaterialWidget(
        child: AttributeFieldWidgetTestUtils.createTestWidget(title: ''),
      );

      // Verify empty title is handled
      expect(find.text(''), findsOneWidget);
    });
  });
}
