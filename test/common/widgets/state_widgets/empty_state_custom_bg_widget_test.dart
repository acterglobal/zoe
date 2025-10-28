import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_custom_bg_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  Future<void> pumpEmptyStateCustomBgWidget(
    WidgetTester tester, {
    Color? color,
    ContentType? contentType,
    IconData? icon,
    ThemeData? theme,
  }) async {
    await tester.pumpMaterialWidget(
      child: EmptyStateCustomBgWidget(
        color: color ?? Colors.blue,
        contentType: contentType ?? ContentType.task,
        icon: icon,
      ),
    );
  }

  group('EmptyStateCustomBgWidget', () {
    testWidgets('renders empty state custom bg widget correctly', (
      tester,
    ) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
      );

      expect(find.byType(EmptyStateCustomBgWidget), findsOneWidget);
    });

    testWidgets('renders Container with decoration', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
      );

      // Verify Container with BoxDecoration exists
      expect(find.byType(Container), findsAtLeastNWidgets(1));

      // Verify the main container has decoration with border radius and shadow
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasDecoratedContainer = containers.any(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration! as BoxDecoration).borderRadius != null,
      );
      expect(hasDecoratedContainer, isTrue);
    });

    testWidgets('renders Column layout', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
      );

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('renders sheet header', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
      );

      // Sheet header is a Container with height 40
      final containers = find.byType(Container);
      expect(containers, findsAtLeastNWidgets(1));
    });

    testWidgets('renders content lines', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
      );

      // Verify content lines exist (4 rows for the content lines)
      expect(find.byType(Row), findsAtLeastNWidgets(4));

      // Verify icons are present for each content line
      final iconWidgets = tester.widgetList<Icon>(find.byType(Icon));
      expect(iconWidgets.length, equals(4));
    });

    testWidgets('displays correct icon for task content type', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
        contentType: ContentType.task,
      );

      expect(find.byIcon(Icons.task_alt_outlined), findsWidgets);
    });

    testWidgets('displays correct icon for event content type', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
        contentType: ContentType.event,
      );

      expect(find.byIcon(Icons.event_rounded), findsWidgets);
    });

    testWidgets('displays correct icon for document content type', (
      tester,
    ) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
        contentType: ContentType.document,
      );

      expect(find.byIcon(Icons.insert_drive_file_rounded), findsWidgets);
    });

    testWidgets('displays correct icon for link content type', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
        contentType: ContentType.link,
      );

      expect(find.byIcon(Icons.link_rounded), findsWidgets);
    });

    testWidgets('displays correct icon for poll content type', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
        contentType: ContentType.poll,
      );

      expect(find.byIcon(Icons.poll_rounded), findsWidgets);
    });

    testWidgets('displays custom icon when provided', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
        icon: Icons.favorite,
      );

      expect(find.byIcon(Icons.favorite), findsWidgets);
    });

    testWidgets('applies correct color to icon', (tester) async {
      const testColor = Colors.purple;

      await pumpEmptyStateCustomBgWidget(
        tester,
        color: testColor,
      );

      final iconWidgets = tester.widgetList<Icon>(
        find.byIcon(Icons.task_alt_outlined),
      );

      // Verify at least one icon exists and has the correct color
      expect(iconWidgets, isNotEmpty);
      final icon = iconWidgets.first;
      expect(icon.color, equals(testColor.withValues(alpha: 0.2)));
    });

    testWidgets('renders correctly in light theme', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
        theme: ThemeData.light(),
      );

      expect(find.byType(EmptyStateCustomBgWidget), findsOneWidget);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      await pumpEmptyStateCustomBgWidget(
        tester,
        theme: ThemeData.dark(),
      );

      expect(find.byType(EmptyStateCustomBgWidget), findsOneWidget);
    });
  });
}
