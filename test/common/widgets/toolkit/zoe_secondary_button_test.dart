import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/shimmer_overlay_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_secondary_button.dart';

import '../../../test-utils/test_utils.dart';

/// Test utilities for ZoeSecondaryButton widget tests
class ZoeSecondaryButtonTestUtils {
  /// Creates a test wrapper for the ZoeSecondaryButton widget
  static ZoeSecondaryButton createTestWidget({
    String text = 'Test Button',
    VoidCallback? onPressed,
    IconData? icon,
    Color? primaryColor, 
    EdgeInsetsGeometry? contentPadding,
    BorderRadius? borderRadius,
    bool showShimmer = false,
    bool showHighlight = true,
    Duration? shimmerDuration,
    double height = 56,
    double? width,
    double borderWidth = 1.0,
  }) {
    return ZoeSecondaryButton(
      text: text,
      onPressed: onPressed ?? () {},
      icon: icon,
      primaryColor: primaryColor,
      contentPadding: contentPadding,
      borderRadius: borderRadius,
      showShimmer: showShimmer,
      showHighlight: showHighlight,
      shimmerDuration: shimmerDuration ?? const Duration(seconds: 3),
      height: height,
      width: width,
      borderWidth: borderWidth,
    );
  }
}

void main() {
  group('ZoeSecondaryButton Widget Tests -', () {
    testWidgets('renders with default properties correctly', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeSecondaryButtonTestUtils.createTestWidget(),
      );

      // Verify button is rendered
      expect(find.byType(Container), findsWidgets);
      expect(find.text('Test Button'), findsOneWidget);
      
      // Verify default dimensions
      final button = tester.widget<ZoeSecondaryButton>(
        find.byType(ZoeSecondaryButton),
      );
      expect(button.height, 56);
      expect(button.width, isNull);
      expect(button.borderWidth, 1.0);
    });

    testWidgets('applies custom text correctly', (tester) async {
      const customText = 'Custom Button';
      await tester.pumpMaterialWidget(
        child: ZoeSecondaryButtonTestUtils.createTestWidget(
          text: customText,
        ),
      );

      expect(find.text(customText), findsOneWidget);
    });

    testWidgets('handles tap correctly', (tester) async {
      bool wasTapped = false;
      await tester.pumpMaterialWidget(
        child: ZoeSecondaryButtonTestUtils.createTestWidget(
          onPressed: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(wasTapped, isTrue);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeSecondaryButtonTestUtils.createTestWidget(
          icon: Icons.add,
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.add);
      expect(icon.size, 20);
    });

    testWidgets('applies custom padding correctly', (tester) async {
      const customPadding = EdgeInsets.all(20);
      
      await tester.pumpMaterialWidget(
        child: ZoeSecondaryButtonTestUtils.createTestWidget(
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
        child: ZoeSecondaryButtonTestUtils.createTestWidget(
          borderRadius: customRadius,
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, customRadius);
    });

    testWidgets('applies custom primary color correctly', (tester) async {
      final customColor = Colors.red;
      
      await tester.pumpMaterialWidget(
        child: ZoeSecondaryButtonTestUtils.createTestWidget(
          primaryColor: customColor,
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.color, equals(customColor.withValues(alpha: 0.8)));

      final text = tester.widget<Text>(find.byType(Text));
      final textStyle = text.style!;
      expect(textStyle.color, equals(customColor));
    });

    testWidgets('shows shimmer overlay when enabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeSecondaryButtonTestUtils.createTestWidget(
          showShimmer: true,
        ),
      );

      expect(find.byType(ShimmerOverlay), findsOneWidget);
    });

    testWidgets('hides shimmer overlay when disabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeSecondaryButtonTestUtils.createTestWidget(
          showShimmer: false,
        ),
      );

      expect(find.byType(ShimmerOverlay), findsNothing);
    });

    testWidgets('applies custom shimmer duration correctly', (tester) async {
      const customDuration = Duration(seconds: 5);
      
      await tester.pumpMaterialWidget(
        child: ZoeSecondaryButtonTestUtils.createTestWidget(
          showShimmer: true,
          shimmerDuration: customDuration,
        ),
      );

      final shimmer = tester.widget<ShimmerOverlay>(find.byType(ShimmerOverlay));
      expect(shimmer.duration, customDuration);
    });

    testWidgets('applies correct text style', (tester) async {
      await tester.pumpMaterialWidget(
        child: ZoeSecondaryButtonTestUtils.createTestWidget(),
      );

      final text = tester.widget<Text>(find.byType(Text));
      final style = text.style!;
      expect(style.fontWeight, FontWeight.w600);
      expect(style.letterSpacing, 0.2);
    });
  });
}
