import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/features/whatsapp/widgets/important_note_widget.dart';

import '../../../helpers/test_utils.dart';

void main() {
  group('ImportantNoteWidget', () {
    testWidgets('renders with required properties', (tester) async {
      const title = 'Test Title';
      const message = 'Test Message';

      await tester.pumpMaterialWidget(
        child: ImportantNoteWidget(title: title, message: message),
      );

      // Verify basic structure
      expect(find.byType(GlassyContainer), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);

      // Verify text content
      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);

      // Verify no icon is shown when not provided
      expect(find.byType(Icon), findsNothing);
      expect(find.byType(StyledContentContainer), findsNothing);
    });

    testWidgets('renders with icon when provided', (tester) async {
      await tester.pumpMaterialWidget(
        child: ImportantNoteWidget(
          title: 'Test Title',
          message: 'Test Message',
          icon: Icons.info,
        ),
      );

      // Verify icon is shown
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(StyledContentContainer), findsOneWidget);

      // Verify icon spacing
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 16,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 8,
        ),
        findsOneWidget,
      );
    });

    testWidgets('handles onTap callback', (tester) async {
      var tapCount = 0;
      await tester.pumpMaterialWidget(
        child: Center(
          child: ImportantNoteWidget(
            title: 'Test Title',
            message: 'Test Message',
            onTap: () => tapCount++,
          ),
        ),
      );

      // Verify tap behavior
      await tester.tap(find.byType(ImportantNoteWidget));
      expect(tapCount, 1);

      await tester.tap(find.byType(ImportantNoteWidget));
      expect(tapCount, 2);
    });

    testWidgets('applies custom colors', (tester) async {
      const primaryColor = Colors.red;
      const secondaryColor = Colors.blue;

      await tester.pumpMaterialWidget(
        child: const ImportantNoteWidget(
          title: 'Test Title',
          message: 'Test Message',
          icon: Icons.info,
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
      );

      // Verify colors in StyledContentContainer
      final container = tester.widget<StyledContentContainer>(
        find.byType(StyledContentContainer),
      );
      expect(container.primaryColor, primaryColor);
      expect(container.secondaryColor, secondaryColor);

      // Verify icon color
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, primaryColor);

      // Verify title color
      final titleWidget = tester.widget<Text>(find.text('Test Title'));
      expect(titleWidget.style?.color, primaryColor);
    });

    testWidgets('uses theme colors when custom colors not provided', (
      tester,
    ) async {
      final theme = ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.purple,
          secondary: Colors.orange,
        ),
      );

      await tester.pumpMaterialWidget(
        theme: theme,
        child: const ImportantNoteWidget(
          title: 'Test Title',
          message: 'Test Message',
          icon: Icons.info,
        ),
      );

      // Verify colors in StyledContentContainer
      final container = tester.widget<StyledContentContainer>(
        find.byType(StyledContentContainer),
      );
      expect(container.primaryColor, theme.colorScheme.primary);
      expect(container.secondaryColor, theme.colorScheme.secondary);

      // Verify icon color
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, theme.colorScheme.primary);

      // Verify title color
      final titleWidget = tester.widget<Text>(find.text('Test Title'));
      expect(titleWidget.style?.color, theme.colorScheme.primary);
    });

    testWidgets('handles long text content', (tester) async {
      const longTitle =
          'This is a very long title that might wrap to multiple lines';
      const longMessage = '''
This is a very long message that definitely spans multiple lines.
It contains a lot of text to test how the widget handles text wrapping
and overall layout with larger content.
''';

      await tester.pumpMaterialWidget(
        child: const ImportantNoteWidget(
          title: longTitle,
          message: longMessage,
          icon: Icons.info,
        ),
      );

      // Verify text is rendered
      expect(find.text(longTitle), findsOneWidget);
      expect(find.text(longMessage), findsOneWidget);

      // No errors should be thrown for overflow
      expect(tester.takeException(), isNull);
    });
  });
}
