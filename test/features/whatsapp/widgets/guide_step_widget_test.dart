import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/features/whatsapp/widgets/guide_step_widget.dart';

import '../../../helpers/test_utils.dart';

void main() {
  const testImagePath = 'assets/images/test_image.png';

  group('GuideStepWidget', () {
    testWidgets('renders with required properties', (tester) async {
      const stepNumber = 1;
      const title = 'Test Title';
      const description = 'Test Description';

      await tester.pumpMaterialWidget(
        child: const SizedBox(
          width: 800,
          height: 600,
          child: GuideStepWidget(
            stepNumber: stepNumber,
            title: title,
            description: description,
            imagePath: testImagePath,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify basic structure
      expect(find.byType(GlassyContainer), findsOneWidget);

      // Find the main Column directly under GlassyContainer
      final mainColumn = find
          .descendant(
            of: find.byType(GlassyContainer),
            matching: find.byType(Column),
          )
          .first;
      expect(
        tester.widget<Column>(mainColumn).crossAxisAlignment,
        CrossAxisAlignment.start,
      );

      // Find the Row containing step number and content
      final headerRow = find.descendant(
        of: find.byType(GlassyContainer),
        matching: find.byType(Row),
      );
      expect(headerRow, findsOneWidget);

      // Verify text content
      expect(find.text(stepNumber.toString()), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      expect(find.text(description), findsOneWidget);

      // Verify image
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('handles image loading error', (tester) async {
      await tester.pumpMaterialWidget(
        child: const SizedBox(
          width: 800,
          height: 600,
          child: GuideStepWidget(
            stepNumber: 1,
            title: 'Test Title',
            description: 'Test Description',
            imagePath: 'invalid_image_path.png',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify error state is shown
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    testWidgets('uses theme colors', (tester) async {
      final theme = ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.purple,
          secondary: Colors.orange,
          onSurface: Colors.black,
        ),
      );

      await tester.pumpMaterialWidget(
        theme: theme,
        child: const SizedBox(
          width: 800,
          height: 600,
          child: GuideStepWidget(
            stepNumber: 1,
            title: 'Test Title',
            description: 'Test Description',
            imagePath: testImagePath,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify colors in StyledContentContainer
      final container = tester.widget<StyledContentContainer>(
        find.byType(StyledContentContainer),
      );
      expect(container.primaryColor, theme.colorScheme.primary);
      expect(container.secondaryColor, theme.colorScheme.secondary);

      // Verify text colors
      final stepNumber = tester.widget<Text>(find.text('1'));
      expect(stepNumber.style?.color, theme.colorScheme.onSurface);

      final title = tester.widget<Text>(find.text('Test Title'));
      expect(title.style?.color, theme.colorScheme.onSurface);

      final description = tester.widget<Text>(find.text('Test Description'));
      expect(
        description.style?.color,
        theme.colorScheme.onSurface.withValues(alpha: 0.7),
      );
    });

    testWidgets('handles long text content', (tester) async {
      const longTitle =
          'This is a very long title that might wrap to multiple lines';
      const longDescription = '''
This is a very long description that definitely spans multiple lines.
It contains a lot of text to test how the widget handles text wrapping
and overall layout with larger content.
''';

      await tester.pumpMaterialWidget(
        child: const SizedBox(
          width: 800,
          height: 600,
          child: GuideStepWidget(
            stepNumber: 1,
            title: longTitle,
            description: longDescription,
            imagePath: testImagePath,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify text is rendered
      expect(find.text(longTitle), findsOneWidget);
      expect(find.text(longDescription), findsOneWidget);

      // No errors should be thrown for overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('maintains layout with different step numbers', (tester) async {
      Future<void> pumpStepWidget(int stepNumber) async {
        await tester.pumpMaterialWidget(
          child: SizedBox(
            width: 800,
            height: 600,
            child: GuideStepWidget(
              stepNumber: stepNumber,
              title: 'Test',
              description: 'Test',
              imagePath: testImagePath,
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      // Test with single digit
      await pumpStepWidget(1);
      expect(find.text('1'), findsOneWidget);

      // Test with double digits
      await pumpStepWidget(10);
      expect(find.text('10'), findsOneWidget);

      // Test with triple digits
      await pumpStepWidget(100);
      expect(find.text('100'), findsOneWidget);

      // Verify layout structure remains stable
      expect(find.byType(GlassyContainer), findsOneWidget);
      expect(find.byType(StyledContentContainer), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      // Verify column structure
      final mainColumn = find
          .descendant(
            of: find.byType(GlassyContainer),
            matching: find.byType(Column),
          )
          .first;
      expect(
        tester.widget<Column>(mainColumn).crossAxisAlignment,
        CrossAxisAlignment.start,
      );
    });
  });
}
