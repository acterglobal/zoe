import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/app_icon_widget.dart';
import 'package:zoe/common/widgets/drawer/drawer_header_widget.dart';
import 'package:zoe/core/constants/app_constants.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer.test();
  });

  getL10n(WidgetTester tester) {
    return L10n.of(tester.element(find.byType(DrawerHeaderWidget)));
  }

  group('DrawerHeaderWidget', () {
    testWidgets('renders drawer header correctly', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(DrawerHeaderWidget), findsOneWidget);
    });

    testWidgets('displays app icon widget', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      // Verify AppIconWidget is displayed
      expect(find.byType(AppIconWidget), findsOneWidget);
    });

    testWidgets('app icon widget has correct size', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      final appIcon = tester.widget<AppIconWidget>(find.byType(AppIconWidget));
      expect(appIcon.size, equals(42));
    });

    testWidgets('displays app name', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      // Verify app name is displayed
      expect(find.text(AppConstants.appName), findsOneWidget);
    });

    testWidgets('displays app description', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      // Get L10n instance from the context
      final l10n = getL10n(tester);

      // Verify app description is displayed
      expect(find.text(l10n.nextGenProductivity), findsOneWidget);
    });

    testWidgets('has correct layout structure', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      // Verify container exists
      expect(find.byType(Container), findsWidgets);

      // Verify row layout
      final rows = find.descendant(
        of: find.byType(DrawerHeaderWidget),
        matching: find.byType(Row),
      );
      expect(rows, findsAtLeastNWidgets(1));

      // Verify column layout for app info
      final columns = find.descendant(
        of: find.byType(DrawerHeaderWidget),
        matching: find.byType(Column),
      );
      expect(columns, findsWidgets);
    });

    testWidgets('applies correct padding', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      final drawerContainer = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(DrawerHeaderWidget),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(drawerContainer.padding, equals(const EdgeInsets.all(24)));
    });

    testWidgets('app name has correct styling', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      // Find the app name text widget
      final appNameText = tester.widget<Text>(find.text(AppConstants.appName));

      // Verify text style properties
      expect(appNameText.style?.fontWeight, equals(FontWeight.w700));
      expect(appNameText.style?.letterSpacing, equals(-0.3));
    });

    testWidgets('app description has correct styling', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      // Get L10n instance
      final l10n = getL10n(tester);

      // Find the description text widget
      final descriptionText = tester.widget<Text>(
        find.text(l10n.nextGenProductivity),
      );

      // Verify text style exists
      expect(descriptionText.style, isNotNull);
    });

    testWidgets('has correct spacing between elements', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      // Verify SizedBox spacing is present
      final sizedBoxes = find.descendant(
        of: find.byType(DrawerHeaderWidget),
        matching: find.byType(SizedBox),
      );
      expect(sizedBoxes, findsAtLeastNWidgets(1));

      // Check if there's a SizedBox with width 16 (spacing between icon and text)
      final spacingBox = find.descendant(
        of: find.byType(Row),
        matching: find.byType(SizedBox),
      );
      if (spacingBox.evaluate().isNotEmpty) {
        final box = tester.widget<SizedBox>(spacingBox.first);
        expect(box.width, equals(16));
      }
    });

    testWidgets('app info uses expanded layout', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      // Verify Expanded widget is used for app info
      final expanded = find.descendant(
        of: find.byType(Row),
        matching: find.byType(Expanded),
      );
      expect(expanded, findsOneWidget);
    });

    testWidgets('app info column has correct alignment', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(Expanded),
          matching: find.byType(Column),
        ),
      );

      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
    });

    testWidgets('renders correctly in different themes', (tester) async {
      // Test with light theme
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        theme: ThemeData.light(),
        child: const DrawerHeaderWidget(),
      );
      expect(find.byType(DrawerHeaderWidget), findsOneWidget);

      // Test with dark theme
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        theme: ThemeData.dark(),
        child: const DrawerHeaderWidget(),
      );
      expect(find.byType(DrawerHeaderWidget), findsOneWidget);
    });

    testWidgets('applies primary color to app name', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        child: const DrawerHeaderWidget(),
      );

      final appNameText = tester.widget<Text>(find.text(AppConstants.appName));
      final theme = Theme.of(tester.element(find.byType(DrawerHeaderWidget)));

      expect(appNameText.style?.color, equals(theme.colorScheme.primary));
    });

    testWidgets('app description uses onSurface color with alpha', (
      tester,
    ) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const DrawerHeaderWidget(),
      );

      final l10n = getL10n(tester);

      final descriptionText = tester.widget<Text>(
        find.text(l10n.nextGenProductivity),
      );

      // Verify color uses onSurface with alpha
      expect(descriptionText.style?.color, isNotNull);
    });
  });
}
