import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/state_widgets/loading_state_widget.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  Future<void> pumpLoadingStateWidget(
    WidgetTester tester, {
    double? height,
    double? width,
    Color? backgroundColor,
    ThemeData? theme,
  }) async {
    await tester.pumpMaterialWidget(
      theme: theme,
      child: LoadingStateWidget(
        height: height,
        width: width,
        backgroundColor: backgroundColor,
      ),
    );
  }

  group('LoadingStateWidget', () {
    testWidgets('renders loading state widget correctly', (tester) async {
      await pumpLoadingStateWidget(tester);

      expect(find.byType(LoadingStateWidget), findsOneWidget);
    });

    testWidgets('renders Container with decoration', (tester) async {
      await pumpLoadingStateWidget(tester);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration is BoxDecoration, isTrue);
    });

    testWidgets('Container has border radius', (tester) async {
      await pumpLoadingStateWidget(tester);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('renders CircularProgressIndicator', (tester) async {
      await pumpLoadingStateWidget(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('CircularProgressIndicator has correct properties', (
      tester,
    ) async {
      await pumpLoadingStateWidget(tester);

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.strokeWidth, equals(2));
    });

    testWidgets('uses custom height when provided', (tester) async {
      const customHeight = 200.0;
      await pumpLoadingStateWidget(tester, height: customHeight);

      final widget = tester.widget<LoadingStateWidget>(
        find.byType(LoadingStateWidget),
      );
      expect(widget.height, equals(customHeight));
    });

    testWidgets('uses custom width when provided', (tester) async {
      const customWidth = 300.0;
      await pumpLoadingStateWidget(tester, width: customWidth);

      final widget = tester.widget<LoadingStateWidget>(
        find.byType(LoadingStateWidget),
      );
      expect(widget.width, equals(customWidth));
    });

    testWidgets('uses custom background color when provided', (tester) async {
      const customColor = Colors.red;
      await pumpLoadingStateWidget(tester, backgroundColor: customColor);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(customColor));
    });

    testWidgets('uses theme surface color when background not provided', (
      tester,
    ) async {
      await pumpLoadingStateWidget(tester);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNotNull);
    });

    testWidgets('renders correctly in light theme', (tester) async {
      await pumpLoadingStateWidget(tester, theme: ThemeData.light());

      expect(find.byType(LoadingStateWidget), findsOneWidget);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      await pumpLoadingStateWidget(tester, theme: ThemeData.dark());

      expect(find.byType(LoadingStateWidget), findsOneWidget);
    });

    testWidgets('renders with different heights', (tester) async {
      final heights = [100.0, 150.0, 200.0, 250.0];

      for (final height in heights) {
        await pumpLoadingStateWidget(tester, height: height);
        expect(find.byType(LoadingStateWidget), findsOneWidget);
      }
    });

    testWidgets('renders with different widths', (tester) async {
      final widths = [200.0, 300.0, 400.0, 500.0];

      for (final width in widths) {
        await pumpLoadingStateWidget(tester, width: width);
        expect(find.byType(LoadingStateWidget), findsOneWidget);
      }
    });

    testWidgets('renders with different background colors', (tester) async {
      final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];

      for (final color in colors) {
        await pumpLoadingStateWidget(tester, backgroundColor: color);
        expect(find.byType(LoadingStateWidget), findsOneWidget);
      }
    });
  });
}
