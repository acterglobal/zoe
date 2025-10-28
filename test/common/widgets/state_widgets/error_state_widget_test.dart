import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/state_widgets/error_state_widget.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  Future<void> pumpErrorStateWidget(
    WidgetTester tester, {
    String? message,
    ThemeData? theme,
  }) async {
    await tester.pumpMaterialWidget(
      theme: theme,
      child: ErrorStateWidget(message: message ?? 'Error occurred'),
    );
  }

  group('ErrorStateWidget', () {
    testWidgets('renders error state widget correctly', (tester) async {
      await pumpErrorStateWidget(tester);

      expect(find.byType(ErrorStateWidget), findsOneWidget);
    });

    testWidgets('displays error message', (tester) async {
      const message = 'An error occurred';
      await pumpErrorStateWidget(tester, message: message);

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('displays error icon', (tester) async {
      await pumpErrorStateWidget(tester);

      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('renders Container with decoration', (tester) async {
      await pumpErrorStateWidget(tester);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration is BoxDecoration, isTrue);
    });

    testWidgets('Container has correct height', (tester) async {
      await pumpErrorStateWidget(tester);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxHeight, equals(120));
    });

    testWidgets('Container has border radius', (tester) async {
      await pumpErrorStateWidget(tester);

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('renders Text widget', (tester) async {
      await pumpErrorStateWidget(tester);

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders SizedBox for spacing', (tester) async {
      await pumpErrorStateWidget(tester);

      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('renders correctly in light theme', (tester) async {
      await pumpErrorStateWidget(tester, theme: ThemeData.light());

      expect(find.byType(ErrorStateWidget), findsOneWidget);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      await pumpErrorStateWidget(tester, theme: ThemeData.dark());

      expect(find.byType(ErrorStateWidget), findsOneWidget);
    });

    testWidgets('renders with different error messages', (tester) async {
      final messages = [
        'Error loading data',
        'Connection failed',
        'Invalid input',
        'Resource not found',
      ];

      for (final message in messages) {
        await pumpErrorStateWidget(tester, message: message);
        expect(find.text(message), findsOneWidget);
      }
    });
  });
}
