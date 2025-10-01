import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/shimmer_overlay_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';

import '../../../helpers/test_utils.dart';

/// Test utilities for ZoePrimaryButton widget tests
class ZoePrimaryButtonTestUtils {
  /// Creates a test wrapper for the ZoePrimaryButton widget
  static ZoePrimaryButton createTestWidget({
    String text = 'Test Button',
    VoidCallback? onPressed,
    IconData? icon,
    Color? primaryColor,
    Color? secondaryColor,
    EdgeInsetsGeometry? contentPadding,
    BorderRadius? borderRadius,
    bool showShimmer = true,
    bool showHighlight = true,
    Duration? shimmerDuration,
    double height = 56,
    double? width,
  }) {
    return ZoePrimaryButton(
      text: text,
      onPressed: onPressed ?? () {},
      icon: icon,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      contentPadding: contentPadding,
      borderRadius: borderRadius,
      showShimmer: showShimmer,
      showHighlight: showHighlight,
      shimmerDuration: shimmerDuration ?? const Duration(seconds: 3),
      height: height,
      width: width,
    );
  }
}

void main() {
  group('ZoePrimaryButton Widget Tests -', () {
    testWidgets('renders with default properties correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoePrimaryButtonTestUtils.createTestWidget(),
      );

      // Verify button is rendered
      expect(find.byType(Container), findsWidgets);
      expect(find.text('Test Button'), findsOneWidget);
      
      // Verify default dimensions through the widget
      final button = tester.widget<ZoePrimaryButton>(find.byType(ZoePrimaryButton));
      expect(button.height, 56);
      expect(button.width, isNull);
    });

    testWidgets('applies custom text correctly', (tester) async {
      const customText = 'Custom Button';
      await tester.pumpMaterialWidget(
        child: ZoePrimaryButtonTestUtils.createTestWidget(
          text: customText,
        ),
      );

      expect(find.text(customText), findsOneWidget);
    });

    testWidgets('handles tap correctly', (tester) async {
      bool wasTapped = false;
      await tester.pumpMaterialWidget(
        child: ZoePrimaryButtonTestUtils.createTestWidget(
          onPressed: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(wasTapped, isTrue);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoePrimaryButtonTestUtils.createTestWidget(
          icon: Icons.add,
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.add);
      expect(icon.size, 20);
      expect(icon.color, Colors.white);
    });

    testWidgets('applies custom padding correctly', (tester) async {
      const customPadding = EdgeInsets.all(20);
      
      await tester.pumpMaterialWidget(
        child: ZoePrimaryButtonTestUtils.createTestWidget(
          contentPadding: customPadding,
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(InkWell),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.padding, customPadding);
    });

    testWidgets('applies custom border radius correctly', (tester) async {
      final customRadius = BorderRadius.circular(24);
      
      await tester.pumpMaterialWidget(
        child: ZoePrimaryButtonTestUtils.createTestWidget(
          borderRadius: customRadius,
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, customRadius);
    });

    testWidgets('applies custom colors correctly', (tester) async {
      final customPrimaryColor = Colors.red;
      final customSecondaryColor = Colors.blue;
      
      await tester.pumpMaterialWidget(
        child: ZoePrimaryButtonTestUtils.createTestWidget(
          primaryColor: customPrimaryColor,
          secondaryColor: customSecondaryColor,
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      
      expect(gradient.colors[0], customPrimaryColor);
      expect(gradient.colors[2], customSecondaryColor.withValues(alpha: 0.9));
    });

    testWidgets('shows shimmer overlay when enabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoePrimaryButtonTestUtils.createTestWidget(
          showShimmer: true,
        ),
      );

      expect(find.byType(ShimmerOverlay), findsOneWidget);
    });

    testWidgets('hides shimmer overlay when disabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoePrimaryButtonTestUtils.createTestWidget(
          showShimmer: false,
        ),
      );

      expect(find.byType(ShimmerOverlay), findsNothing);
    });
  });
}