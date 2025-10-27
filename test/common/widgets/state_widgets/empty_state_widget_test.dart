import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  Future<void> pumpEmptyStateWidget(
    WidgetTester tester, {
    String? message,
    IconData? icon,
    double? height,
    double? width,
    ThemeData? theme,
  }) async {
    await tester.pumpMaterialWidget(
      theme: theme,
      child: EmptyStateWidget(
        message: message ?? 'Test message',
        icon: icon ?? Icons.inbox_outlined,
        height: height,
        width: width,
      ),
    );
  }

  group('EmptyStateWidget', () {
    testWidgets('renders empty state widget correctly', (tester) async {
      await pumpEmptyStateWidget(tester, message: 'No items');

      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets('displays message text', (tester) async {
      const message = 'No items available';
      await pumpEmptyStateWidget(tester, message: message);

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('displays default icon when not provided', (tester) async {
      await pumpEmptyStateWidget(tester);

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('displays custom icon when provided', (tester) async {
      await pumpEmptyStateWidget(tester, icon: Icons.favorite);

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('applies correct padding', (tester) async {
      await pumpEmptyStateWidget(tester);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, equals(const EdgeInsets.all(24)));
    });

    testWidgets('Column has correct mainAxisAlignment', (tester) async {
      await pumpEmptyStateWidget(tester);

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
    });

    testWidgets('Text has correct alignment', (tester) async {
      await pumpEmptyStateWidget(tester);

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.textAlign, equals(TextAlign.center));
    });

    testWidgets('Icon has correct size', (tester) async {
      await pumpEmptyStateWidget(tester);

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, equals(64));
    });

    testWidgets('uses custom height when provided', (tester) async {
      const customHeight = 500.0;
      await pumpEmptyStateWidget(tester, height: customHeight);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints, isNotNull);
    });

    testWidgets('uses custom width when provided', (tester) async {
      const customWidth = 400.0;
      await pumpEmptyStateWidget(tester, width: customWidth);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints, isNotNull);
    });

    testWidgets('uses default height when not provided', (tester) async {
      await pumpEmptyStateWidget(tester, message: 'Test message');

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxHeight, equals(300));
    });

    testWidgets('renders correctly in light theme', (tester) async {
      await pumpEmptyStateWidget(tester, theme: ThemeData.light());

      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      await pumpEmptyStateWidget(tester, theme: ThemeData.dark());

      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets('renders with different messages', (tester) async {
      final messages = ['No items', 'No tasks', 'No events', 'Empty list'];

      for (final message in messages) {
        await pumpEmptyStateWidget(tester, message: message);
        expect(find.text(message), findsOneWidget);
      }
    });

    testWidgets('renders with different icons', (tester) async {
      final icons = [Icons.favorite, Icons.star, Icons.settings, Icons.home];

      for (final icon in icons) {
        await pumpEmptyStateWidget(tester, icon: icon);
        expect(find.byIcon(icon), findsOneWidget);
      }
    });

    testWidgets('renders with different heights', (tester) async {
      final heights = [200.0, 400.0, 600.0, 800.0];

      for (final height in heights) {
        await pumpEmptyStateWidget(tester, height: height);
        expect(find.byType(EmptyStateWidget), findsOneWidget);
      }
    });

    testWidgets('renders with different widths', (tester) async {
      final widths = [300.0, 400.0, 500.0, 600.0];

      for (final width in widths) {
        await pumpEmptyStateWidget(tester, width: width);
        expect(find.byType(EmptyStateWidget), findsOneWidget);
      }
    });
  });
}
