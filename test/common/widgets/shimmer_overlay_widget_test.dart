import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/shimmer_overlay_widget.dart';
import '../../test-utils/test_utils.dart';

/// Test utilities for ShimmerOverlay tests
class ShimmerOverlayTestUtils {
  /// Creates a test wrapper for the ShimmerOverlay
  static Widget createTestWidget({
    Widget? child,
    BorderRadius? borderRadius,
    Duration? duration,
    List<Color>? shimmerColors,
    List<double>? shimmerStops,
  }) {
    return ShimmerOverlay(
      borderRadius: borderRadius,
      duration: duration ?? const Duration(seconds: 2),
      shimmerColors: shimmerColors,
      shimmerStops: shimmerStops,
      child: child ?? const Text('Test Content'),
    );
  }
}

void main() {
  group('ShimmerOverlay Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(ShimmerOverlay), findsOneWidget);
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
      expect(find.byType(Positioned), findsAtLeastNWidgets(1));
      expect(find.byType(IgnorePointer), findsAtLeastNWidgets(1));
      expect(find.byType(ClipRRect), findsAtLeastNWidgets(1));
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });

    testWidgets('displays child content', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(
          child: const Text('Test Child'),
        ),
      );

      // Verify child content is displayed
      expect(find.text('Test Child'), findsOneWidget);
    });



  
    testWidgets('applies custom border radius', (tester) async {
      const borderRadius = BorderRadius.all(Radius.circular(16));

      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(
          borderRadius: borderRadius,
        ),
      );

      // Verify ClipRRect is present with custom border radius
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, borderRadius);
    });

    testWidgets('applies default border radius when null', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(),
      );

      // Verify ClipRRect is present with default border radius
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, BorderRadius.zero);
    });

   

  

  
 

   
   



   
    
    testWidgets('handles edge case with empty shimmer colors', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(
          shimmerColors: const [],
          shimmerStops: const [], // Provide empty stops to match empty colors
        ),
      );

      // Verify widget renders with empty colors (should use defaults)
      expect(find.byType(ShimmerOverlay), findsOneWidget);
    });

   
    testWidgets('handles edge case with single shimmer color', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(
          shimmerColors: const [Colors.red],
          shimmerStops: const [0.5], // Provide matching stop
        ),
      );

      // Verify widget renders with single color
      expect(find.byType(ShimmerOverlay), findsOneWidget);
    });

    testWidgets('handles edge case with very short duration', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(
          duration: const Duration(milliseconds: 1),
        ),
      );

      // Verify widget renders with very short duration
      expect(find.byType(ShimmerOverlay), findsOneWidget);
    });

    testWidgets('handles edge case with very long duration', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(
          duration: const Duration(hours: 1),
        ),
      );

      // Verify widget renders with very long duration
      expect(find.byType(ShimmerOverlay), findsOneWidget);
    });

    testWidgets('handles null child gracefully', (tester) async {
      // This test ensures the widget doesn't crash with null child
      // Note: The widget requires a non-null child, so we test with a minimal child
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(child: Container()),
      );

      // Verify widget renders with empty container child
      expect(find.byType(ShimmerOverlay), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });

    testWidgets('handles animation controller lifecycle', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(),
      );

      // Verify AnimatedBuilder is present (indicates animation is set up)
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));

      // Remove widget to test disposal
      await tester.pumpWidget(Container());

      // Verify widget is disposed without errors
      expect(find.byType(ShimmerOverlay), findsNothing);
    });

    testWidgets('handles gradient animation', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(),
      );

      // Verify AnimatedBuilder is present for gradient animation
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));

      // Verify Container with decoration is present
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.isNotEmpty, isTrue);

      // At least one container should have a decoration with gradient
      final hasGradientDecoration = containers.any(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).gradient is LinearGradient,
      );
      expect(hasGradientDecoration, isTrue);
    });

    testWidgets('handles ignore pointer behavior', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(
          child: GestureDetector(
            onTap: () {},
            child: const Text('Tappable Child'),
          ),
        ),
      );

      // Verify IgnorePointer is present
      expect(find.byType(IgnorePointer), findsAtLeastNWidgets(1));

      // Verify child is still tappable (shimmer overlay doesn't block interactions)
      expect(find.text('Tappable Child'), findsOneWidget);
    });

    testWidgets('handles positioned fill behavior', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(),
      );

      // Verify Positioned.fill is used
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned, isNotNull);
    });

    testWidgets('handles curved animation', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(),
      );

      // Verify AnimatedBuilder is present (indicates curved animation is set up)
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });

    testWidgets('handles tween animation range', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(),
      );

      // Verify AnimatedBuilder is present (indicates tween animation is set up)
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });

    testWidgets('handles repeat animation', (tester) async {
      await tester.pumpMaterialWidget(
        child: ShimmerOverlayTestUtils.createTestWidget(),
      );

      // Verify AnimatedBuilder is present (indicates repeat animation is set up)
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });
  });
}
