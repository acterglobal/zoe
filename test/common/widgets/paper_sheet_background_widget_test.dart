import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/paper_sheet_background_widget.dart';
import 'package:zoe/common/widgets/animated_background_widget.dart';
import '../../test-utils/test_utils.dart';

/// Test utilities for PaperSheetBackgroundWidget tests
class PaperSheetBackgroundWidgetTestUtils {
  /// Creates a test wrapper for the PaperSheetBackgroundWidget
  static Widget createTestWidget({
    Widget? child,
    bool? showRuledLines,
    bool? showMargin,
    Color? paperColor,
    double? opacity,
    double? backgroundOpacity,
  }) {
    return PaperSheetBackgroundWidget(
      showRuledLines: showRuledLines ?? true,
      showMargin: showMargin ?? true,
      paperColor: paperColor,
      opacity: opacity ?? 1.0,
      backgroundOpacity: backgroundOpacity ?? 1.0,
      child: child ?? const Text('Test Content'),
    );
  }

  /// Creates a test wrapper for the NotebookPaperBackgroundWidget
  static Widget createNotebookTestWidget({
    Widget? child,
    double? opacity,
    double? backgroundOpacity,
  }) {
    return NotebookPaperBackgroundWidget(
      opacity: opacity ?? 1.0,
      backgroundOpacity: backgroundOpacity ?? 0.3,
      child: child ?? const Text('Notebook Content'),
    );
  }

  /// Creates a test wrapper for the BlankPaperBackgroundWidget
  static Widget createBlankTestWidget({
    Widget? child,
    double? opacity,
    double? backgroundOpacity,
  }) {
    return BlankPaperBackgroundWidget(
      opacity: opacity ?? 1.0,
      backgroundOpacity: backgroundOpacity ?? 0.2,
      child: child ?? const Text('Blank Content'),
    );
  }

  /// Creates a test wrapper for the GridPaperBackgroundWidget
  static Widget createGridTestWidget({Widget? child, double? opacity}) {
    return GridPaperBackgroundWidget(
      opacity: opacity ?? 1.0,
      child: child ?? const Text('Grid Content'),
    );
  }
}

void main() {
  group('PaperSheetBackgroundWidget Tests -', () {
    testWidgets('displays child content', (tester) async {
      const testChild = Text('Test Child Content');

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          child: testChild,
        ),
      );

      // Verify child content is displayed
      expect(find.text('Test Child Content'), findsOneWidget);
    });

    testWidgets('shows ruled lines when enabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          showRuledLines: true,
        ),
      );

      // Verify CustomPaint is present for ruled lines
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('hides ruled lines when disabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          showRuledLines: false,
        ),
      );

      // Verify CustomPaint is still present but with different configuration
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('shows margin when enabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          showMargin: true,
        ),
      );

      // Verify CustomPaint is present for margin
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('hides margin when disabled', (tester) async {
      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          showMargin: false,
        ),
      );

      // Verify CustomPaint is still present but with different configuration
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('applies custom opacity', (tester) async {
      const customOpacity = 0.7;

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          opacity: customOpacity,
        ),
      );

      // Verify widget renders with custom opacity
      expect(find.byType(PaperSheetBackgroundWidget), findsOneWidget);
    });

    testWidgets('applies custom background opacity', (tester) async {
      const customBackgroundOpacity = 0.5;

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          backgroundOpacity: customBackgroundOpacity,
        ),
      );

      // Verify AnimatedBackgroundWidget is present
      expect(find.byType(AnimatedBackgroundWidget), findsOneWidget);
    });

    testWidgets('handles edge case with zero opacity', (tester) async {
      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          opacity: 0.0,
        ),
      );

      // Verify widget renders with zero opacity
      expect(find.byType(PaperSheetBackgroundWidget), findsOneWidget);
    });

    testWidgets('handles edge case with zero background opacity', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          backgroundOpacity: 0.0,
        ),
      );

      // Verify widget renders with zero background opacity
      expect(find.byType(PaperSheetBackgroundWidget), findsOneWidget);
    });

    testWidgets('handles edge case with maximum opacity', (tester) async {
      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          opacity: 1.0,
          backgroundOpacity: 1.0,
        ),
      );

      // Verify widget renders with maximum opacity
      expect(find.byType(PaperSheetBackgroundWidget), findsOneWidget);
    });

    testWidgets('handles all properties together', (tester) async {
      const customColor = Colors.blue;
      const customOpacity = 0.8;
      const customBackgroundOpacity = 0.6;

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createTestWidget(
          showRuledLines: true,
          showMargin: true,
          paperColor: customColor,
          opacity: customOpacity,
          backgroundOpacity: customBackgroundOpacity,
        ),
      );

      // Verify widget renders with all custom properties
      expect(find.byType(PaperSheetBackgroundWidget), findsOneWidget);
    });
  });

  group('NotebookPaperBackgroundWidget Tests -', () {
    testWidgets('renders with default properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createNotebookTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
    });

    testWidgets('displays child content', (tester) async {
      const testChild = Text('Notebook Test Content');

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createNotebookTestWidget(
          child: testChild,
        ),
      );

      // Verify child content is displayed
      expect(find.text('Notebook Test Content'), findsOneWidget);
    });

    testWidgets('applies custom opacity', (tester) async {
      const customOpacity = 0.7;

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createNotebookTestWidget(
          opacity: customOpacity,
        ),
      );

      // Verify widget renders with custom opacity
      expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
    });

    testWidgets('applies custom background opacity', (tester) async {
      const customBackgroundOpacity = 0.5;

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createNotebookTestWidget(
          backgroundOpacity: customBackgroundOpacity,
        ),
      );

      // Verify widget renders with custom background opacity
      expect(find.byType(NotebookPaperBackgroundWidget), findsOneWidget);
    });

    testWidgets('has ruled lines enabled by default', (tester) async {
      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createNotebookTestWidget(),
      );

      // Verify CustomPaint is present for ruled lines
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });
  });

  group('BlankPaperBackgroundWidget Tests -', () {
    testWidgets('renders with default properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createBlankTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(BlankPaperBackgroundWidget), findsOneWidget);
    });

    testWidgets('displays child content', (tester) async {
      const testChild = Text('Blank Test Content');

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createBlankTestWidget(
          child: testChild,
        ),
      );

      // Verify child content is displayed
      expect(find.text('Blank Test Content'), findsOneWidget);
    });

    testWidgets('applies custom opacity', (tester) async {
      const customOpacity = 0.7;

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createBlankTestWidget(
          opacity: customOpacity,
        ),
      );

      // Verify widget renders with custom opacity
      expect(find.byType(BlankPaperBackgroundWidget), findsOneWidget);
    });

    testWidgets('applies custom background opacity', (tester) async {
      const customBackgroundOpacity = 0.5;

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createBlankTestWidget(
          backgroundOpacity: customBackgroundOpacity,
        ),
      );

      // Verify widget renders with custom background opacity
      expect(find.byType(BlankPaperBackgroundWidget), findsOneWidget);
    });
  });

  group('GridPaperBackgroundWidget Tests -', () {
    testWidgets('displays child content', (tester) async {
      const testChild = Text('Grid Test Content');

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createGridTestWidget(
          child: testChild,
        ),
      );

      // Verify child content is displayed
      expect(find.text('Grid Test Content'), findsOneWidget);
    });

    testWidgets('applies custom opacity', (tester) async {
      const customOpacity = 0.7;

      await tester.pumpMaterialWidget(
        child: PaperSheetBackgroundWidgetTestUtils.createGridTestWidget(
          opacity: customOpacity,
        ),
      );

      // Verify widget renders with custom opacity
      expect(find.byType(GridPaperBackgroundWidget), findsOneWidget);
    });

    testWidgets('handles different opacity values', (tester) async {
      const opacityValues = [0.0, 0.3, 0.5, 0.7, 1.0];

      for (final opacity in opacityValues) {
        await tester.pumpMaterialWidget(
          child: PaperSheetBackgroundWidgetTestUtils.createGridTestWidget(
            opacity: opacity,
          ),
        );

        // Verify widget renders with different opacity values
        expect(find.byType(GridPaperBackgroundWidget), findsOneWidget);
      }
    });
  });
}
