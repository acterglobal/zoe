import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/loading_indicator_widget.dart';

import '../../test-utils/test_utils.dart';

void main() {
  Future<void> pumpLoadingIndicator(
    WidgetTester tester, {
    LoadingIndicatorType type = LoadingIndicatorType.linear,
    double? size,
    Color? backgroundColor,
  }) async {
    await tester.pumpMaterialWidget(
      child: LoadingIndicatorWidget(
        type: type,
        size: size,
        backgroundColor: backgroundColor,
      ),
    );
  }

  group('LoadingIndicatorWidget', () {
    group('Linear', () {
      testWidgets('renders LinearProgressIndicator by default', (tester) async {
        await pumpLoadingIndicator(tester);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('applies size to height only', (tester) async {
        const size = 20.0;
        await pumpLoadingIndicator(tester, size: size);

        final sizedBoxFinder = find.ancestor(
          of: find.byType(LinearProgressIndicator),
          matching: find.byType(SizedBox),
        );
        expect(sizedBoxFinder, findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);
        expect(sizedBox.height, equals(size));
        expect(sizedBox.width, equals(double.infinity));
      });

      testWidgets('applies background color', (tester) async {
        const color = Colors.red;
        await pumpLoadingIndicator(tester, backgroundColor: color);

        final indicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        expect(indicator.backgroundColor, equals(color));
      });
    });

    group('Circular', () {
      testWidgets('renders CircularProgressIndicator when type is circular', (
        tester,
      ) async {
        await pumpLoadingIndicator(tester, type: LoadingIndicatorType.circular);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsNothing);
      });

      testWidgets('applies size to width and height', (tester) async {
        const size = 30.0;
        await pumpLoadingIndicator(
          tester,
          type: LoadingIndicatorType.circular,
          size: size,
        );

        final sizedBoxFinder = find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(SizedBox),
        );
        expect(sizedBoxFinder, findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);
        expect(sizedBox.width, equals(size));
        expect(sizedBox.height, equals(size));
      });

      testWidgets('applies background color', (tester) async {
        const color = Colors.blue;
        await pumpLoadingIndicator(
          tester,
          type: LoadingIndicatorType.circular,
          backgroundColor: color,
        );

        final indicator = tester.widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator),
        );
        expect(indicator.backgroundColor, equals(color));
      });
    });
  });
}
