import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/shimmer_overlay_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';

import '../../../helpers/test_utils.dart';

/// Test utilities for ZoeFloatingActionButton widget tests
class ZoeFloatingActionButtonTestUtils {
  /// Creates a test wrapper for the ZoeFloatingActionButton widget
  static Widget createTestWidget({
    VoidCallback? onPressed,
    Widget? child,
    IconData icon = Icons.add,
    double? size,
    Color? primaryColor,
    Color? secondaryColor,
    BorderRadius? borderRadius,
    bool? showShimmer,
    bool? showHighlight,
    double? iconSize,
  }) {
    return ZoeFloatingActionButton(
      onPressed: onPressed ?? () {},
      icon: icon,
      size: size ?? 56,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      borderRadius: borderRadius,
      showShimmer: showShimmer ?? true,
      showHighlight: showHighlight ?? false,
      iconSize: iconSize ?? 32,
      child: child,
    );
  }
}

void main() {
  group('ZoeFloatingActionButton Widget Tests -', () {
    testWidgets('renders with icon correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          icon: Icons.add,
        ),
      );

      // Verify icon is shown
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Verify default icon size
      final icon = tester.widget<Icon>(find.byIcon(Icons.add));
      expect(icon.size, 32);
      expect(icon.color, Colors.white);
    });

    testWidgets('applies custom size correctly', (tester) async {
      const customSize = 72.0;
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          size: customSize,
          showShimmer: false,
        ),
      );

      // Find the main container by looking for the one with border
      final container = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).border != null,
        ),
      );

      expect(container.constraints?.maxWidth, customSize);
      expect(container.constraints?.maxHeight, customSize);
    });

    testWidgets('applies custom colors correctly', (tester) async {
      const primaryColor = Colors.red;
      const secondaryColor = Colors.blue;
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          primaryColor: primaryColor, 
          secondaryColor: secondaryColor,
          showShimmer: false,
        ),
      );

      // Find the main container by looking for the one with border
      final container = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).border != null,
        ),
      );
      final gradient =
          (container.decoration as BoxDecoration).gradient as LinearGradient;

      expect(gradient.colors[0], primaryColor);
      expect(gradient.colors[2], secondaryColor.withValues(alpha: 0.9));
    });

    testWidgets('applies custom border radius correctly', (tester) async {
      final customRadius = BorderRadius.circular(16);
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          borderRadius: customRadius,
          showShimmer: false,
        ),
      );

      // Find the main container by looking for the one with border
      final container = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).border != null,
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, customRadius);
    });

    testWidgets('shows shimmer effect when enabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          showShimmer: true,
        ),
      );

      expect(find.byType(ShimmerOverlay), findsOneWidget);
    });

    testWidgets('hides shimmer effect when disabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          showShimmer: false,
        ),
      );

      expect(find.byType(ShimmerOverlay), findsNothing);
    });

    testWidgets('shows highlight when enabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          showHighlight: true,
          showShimmer: false,
        ),
      );

      // Find highlight container by its specific gradient properties
      final highlightContainer = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).gradient is LinearGradient &&
            ((widget.decoration as BoxDecoration).gradient as LinearGradient)
                    .colors
                    .length ==
                2,
      );

      expect(highlightContainer, findsOneWidget);
    });

    testWidgets('hides highlight when disabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          showHighlight: false,
          showShimmer: false,
        ),
      );

      // Find highlight container by its specific gradient properties
      final highlightContainer = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).gradient is LinearGradient &&
            ((widget.decoration as BoxDecoration).gradient as LinearGradient)
                    .colors
                    .length ==
                2,
      );

      expect(highlightContainer, findsNothing);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool wasTapped = false;
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          onPressed: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(wasTapped, true);
    });

    testWidgets('applies custom icon size correctly', (tester) async {
      const customIconSize = 48.0;
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          iconSize: customIconSize,
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, customIconSize);
    });

    testWidgets('has correct widget hierarchy', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeFloatingActionButtonTestUtils.createTestWidget(
          showShimmer: false,
        ),
      );

      // Find the main container
      final mainContainer = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).border != null,
      );

      // Verify main container exists
      expect(mainContainer, findsOneWidget);

      // Verify it contains Material and InkWell
      expect(
        find.descendant(of: mainContainer, matching: find.byType(Material)),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(Material),
          matching: find.byType(InkWell),
        ),
        findsOneWidget,
      );
    });
  });
}
