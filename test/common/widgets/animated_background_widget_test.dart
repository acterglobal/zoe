import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/animated_background_widget.dart';

import '../../test-utils/test_utils.dart';

/// Test utilities for AnimatedBackgroundWidget tests
class AnimatedBackgroundTestUtils {
  /// Creates a test wrapper for the AnimatedBackgroundWidget
  static AnimatedBackgroundWidget createTestWidget({
    Widget? child,
    double backgroundOpacity = 1.0,
  }) {
    return AnimatedBackgroundWidget(
      backgroundOpacity: backgroundOpacity,
      child: child ?? const Text('Test Child'),
    );
  }
}

void main() {
  group('AnimatedBackgroundWidget Tests -', () {
    testWidgets('renders child widget correctly', (tester) async {
      const testChild = Text('Test Content');

      await tester.pumpMaterialWidget(
        child: AnimatedBackgroundTestUtils.createTestWidget(child: testChild),
      );

      // Verify child is rendered
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('renders with default background opacity', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedBackgroundTestUtils.createTestWidget(),
      );

      // Verify widget renders without errors
      expect(find.byType(AnimatedBackgroundWidget), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('renders with custom background opacity', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedBackgroundTestUtils.createTestWidget(
          backgroundOpacity: 0.5,
        ),
      );

      // Verify widget renders without errors
      expect(find.byType(AnimatedBackgroundWidget), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('contains required UI structure', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedBackgroundTestUtils.createTestWidget(),
      );

      // Verify the main structure
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('applies gradient background', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedBackgroundTestUtils.createTestWidget(),
      );

      // Verify container with gradient decoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      final containerWithGradient = containers.firstWhere(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).gradient != null,
      );
      final decoration = containerWithGradient.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());

      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.begin, Alignment.topLeft);
      expect(gradient.end, Alignment.bottomRight);
      expect(gradient.stops, const [0.0, 0.5, 1.0]);
    });

    testWidgets('renders conceptual elements layer', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedBackgroundTestUtils.createTestWidget(),
      );

      // Verify CustomPaint is present for conceptual elements
      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final conceptualPaint = customPaints.firstWhere(
        (paint) => paint.painter is ConceptualElementsPainter,
      );
      expect(conceptualPaint.painter, isA<ConceptualElementsPainter>());
      expect(conceptualPaint.size, Size.infinite);
    });

    testWidgets('configures ConceptualElementsPainter correctly', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: AnimatedBackgroundTestUtils.createTestWidget(
          backgroundOpacity: 0.7,
        ),
      );

      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final conceptualPaint = customPaints.firstWhere(
        (paint) => paint.painter is ConceptualElementsPainter,
      );
      final painter = conceptualPaint.painter as ConceptualElementsPainter;

      expect(painter.backgroundOpacity, 0.7);
      expect(painter.colorScheme, isNotNull);
      expect(painter.isDark, isA<bool>());
      expect(painter.animation, isNotNull);
    });

    testWidgets('adapts to light theme', (tester) async {
      await tester.pumpMaterialWidget(
        child: Theme(
          data: ThemeData.light(),
          child: AnimatedBackgroundTestUtils.createTestWidget(),
        ),
      );

      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final conceptualPaint = customPaints.firstWhere(
        (paint) => paint.painter is ConceptualElementsPainter,
      );
      final painter = conceptualPaint.painter as ConceptualElementsPainter;

      expect(painter.isDark, isFalse);
    });

    testWidgets('adapts to dark theme', (tester) async {
      await tester.pumpMaterialWidget(
        child: Theme(
          data: ThemeData.dark(),
          child: AnimatedBackgroundTestUtils.createTestWidget(),
        ),
      );

      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final conceptualPaint = customPaints.firstWhere(
        (paint) => paint.painter is ConceptualElementsPainter,
      );
      final painter = conceptualPaint.painter as ConceptualElementsPainter;

      expect(painter.isDark, isTrue);
    });

    testWidgets('handles complex child widget', (tester) async {
      const complexChild = Column(
        children: [Text('Title'), Text('Subtitle'), Icon(Icons.star)],
      );

      await tester.pumpMaterialWidget(
        child: AnimatedBackgroundTestUtils.createTestWidget(
          child: complexChild,
        ),
      );

      // Verify all child elements are rendered
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('handles null child gracefully', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedBackgroundTestUtils.createTestWidget(child: null),
      );

      // Should render without errors even with null child
      expect(find.byType(AnimatedBackgroundWidget), findsOneWidget);
    });

    testWidgets('renders with different child types', (tester) async {
      final childTypes = [
        const Text('Text Child'),
        const Icon(Icons.home),
        const SizedBox(width: 100, height: 100),
        const Center(child: Text('Centered Text')),
        const Column(children: [Text('Item 1'), Text('Item 2')]),
      ];

      for (final child in childTypes) {
        await tester.pumpMaterialWidget(
          child: AnimatedBackgroundTestUtils.createTestWidget(child: child),
        );

        // Verify widget renders without errors
        expect(find.byType(AnimatedBackgroundWidget), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: SizedBox.shrink())),
        );
      }
    });

    testWidgets('handles animation state changes', (tester) async {
      await tester.pumpMaterialWidget(
        child: AnimatedBackgroundTestUtils.createTestWidget(),
      );

      // Let the animation run for a bit
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Verify widget still renders correctly
      expect(find.byType(AnimatedBackgroundWidget), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('applies correct theme colors', (tester) async {
      await tester.pumpMaterialWidget(
        child: Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
          ),
          child: AnimatedBackgroundTestUtils.createTestWidget(),
        ),
      );

      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final conceptualPaint = customPaints.firstWhere(
        (paint) => paint.painter is ConceptualElementsPainter,
      );
      final painter = conceptualPaint.painter as ConceptualElementsPainter;

      // Verify color scheme is applied
      expect(painter.colorScheme.primary, isNotNull);
      expect(painter.isDark, isFalse);
    });
  });
}
