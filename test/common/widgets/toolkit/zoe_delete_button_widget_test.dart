import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_delete_button_widget.dart';

import '../../../test-utils/test_utils.dart';

/// Test utilities for ZoeDeleteButton widget tests
class ZoeDeleteButtonTestUtils {
  /// Creates a test wrapper for the ZoeDeleteButton widget
  static Widget createTestWidget({
    double? size,
    Color? color,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return ZoeDeleteButtonWidget(
      size: size,
      color: color,
      onTap: onTap ?? () {},
      padding: padding,
    );
  }
}

void main() {
  group('ZoeDeleteButton Widget Tests -', () {
    testWidgets('applies custom size correctly', (tester) async {
      const customSize = 24.0;
      await tester.pumpMaterialWidget(
        child: ZoeDeleteButtonTestUtils.createTestWidget(size: customSize),
      );

      // Verify custom size is applied
      final icon = tester.widget<Icon>(find.byIcon(Icons.delete_outlined));
      expect(icon.size, customSize);
    });

    testWidgets('applies custom color correctly', (tester) async {
      const customColor = Colors.red;
      await tester.pumpMaterialWidget(
        child: ZoeDeleteButtonTestUtils.createTestWidget(color: customColor),
      );

      // Verify custom color is applied
      final icon = tester.widget<Icon>(find.byIcon(Icons.delete_outlined));
      expect(icon.color, customColor);
    });

    testWidgets('uses theme error color when no color provided', (
      tester,
    ) async {
      const testTheme = ColorScheme.light();
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: testTheme),
          home: Builder(
            builder: (context) {
              return ZoeDeleteButtonTestUtils.createTestWidget();
            },
          ),
        ),
      );

      // Verify theme error color is applied with opacity
      final icon = tester.widget<Icon>(find.byIcon(Icons.delete_outlined));
      expect(
        icon.color?.toARGB32(),
        equals(testTheme.error.withValues(alpha: 0.7).toARGB32()),
      );
    });

    testWidgets('applies custom padding correctly', (tester) async {
      const customPadding = EdgeInsets.all(8.0);
      await tester.pumpMaterialWidget(
        child: ZoeDeleteButtonTestUtils.createTestWidget(
          padding: customPadding,
        ),
      );

      // Find the Container widget that applies padding
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, equals(customPadding));
    });

    testWidgets('has no padding by default', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeDeleteButtonTestUtils.createTestWidget(),
      );

      // Find the Container widget and verify no padding
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, isNull);
    });

    testWidgets('calls onTap when button is tapped', (tester) async {
      bool wasTapped = false;
      await tester.pumpMaterialWidget(
        child: ZoeDeleteButtonTestUtils.createTestWidget(
          onTap: () => wasTapped = true,
        ),
      );

      // Tap the button
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify callback was called
      expect(wasTapped, true);
    });

    testWidgets('handles multiple taps correctly', (tester) async {
      int tapCount = 0;
      await tester.pumpMaterialWidget(
        child: ZoeDeleteButtonTestUtils.createTestWidget(
          onTap: () => tapCount++,
        ),
      );

      // Tap multiple times
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify callback was called correct number of times
      expect(tapCount, 3);
    });

    testWidgets('has correct widget hierarchy', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeDeleteButtonTestUtils.createTestWidget(),
      );

      // Verify widget hierarchy
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);

      // Verify nesting order
      expect(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(Container),
          matching: find.byType(Icon),
        ),
        findsOneWidget,
      );
    });
  });
}
