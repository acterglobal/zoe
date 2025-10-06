import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/bullets/widgets/bullet_added_by_header_widget.dart';
import '../../../helpers/test_utils.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    container = ProviderContainer.test();
  });

  group('Bullet Added By Header Widget', () {
    group('Basic Rendering', () {
      testWidgets('displays icon and text correctly', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(),
        );

        // Verify icon is displayed
        expect(find.byIcon(Icons.person_rounded), findsOneWidget);
        
        // Verify text is displayed (using a more flexible approach)
        expect(find.textContaining('Added by'), findsOneWidget);
        
        // Verify row structure
        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('displays with custom icon size', (tester) async {
        const customIconSize = 24.0;
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(iconSize: customIconSize),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.person_rounded));
        expect(icon.size, equals(customIconSize));
      });

      testWidgets('displays with custom text size', (tester) async {
        const customTextSize = 16.0;
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(textSize: customTextSize),
        );

        final text = tester.widget<Text>(find.textContaining('Added by'));
        expect(text.style?.fontSize, equals(customTextSize));
      });

      testWidgets('displays with both custom sizes', (tester) async {
        const customIconSize = 28.0;
        const customTextSize = 18.0;
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(
            iconSize: customIconSize,
            textSize: customTextSize,
          ),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.person_rounded));
        expect(icon.size, equals(customIconSize));

        final text = tester.widget<Text>(find.textContaining('Added by'));
        expect(text.style?.fontSize, equals(customTextSize));
      });
    });

    group('Default Values', () {
      testWidgets('uses default icon size when not provided', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.person_rounded));
        expect(icon.size, equals(20.0));
      });

      testWidgets('uses default text size when not provided', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(),
        );

        final text = tester.widget<Text>(find.textContaining('Added by'));
        expect(text.style?.fontSize, equals(14.0));
      });
    });

    group('Layout Structure', () {
      testWidgets('has correct row layout with proper spacing', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(),
        );

        // Verify main row
        final row = tester.widget<Row>(find.byType(Row));
        expect(row.children.length, equals(3)); // Icon, SizedBox, Text

        // Verify spacing between icon and text by checking the SizedBox in the row
        final rowWidget = tester.widget<Row>(find.byType(Row));
        final spacingSizedBox = rowWidget.children[1] as SizedBox;
        expect(spacingSizedBox.width, equals(5.0));
      });

      testWidgets('maintains correct widget order', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(),
        );

        final row = tester.widget<Row>(find.byType(Row));
        final children = row.children;

        // First child should be Icon
        expect(children[0], isA<Icon>());
        
        // Second child should be SizedBox
        expect(children[1], isA<SizedBox>());
        
        // Third child should be Text
        expect(children[2], isA<Text>());
      });
    });

    group('Theme Integration', () {
      testWidgets('applies correct icon color from theme', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.person_rounded));
        final theme = Theme.of(tester.element(find.byType(MaterialApp)));
        
        expect(icon.color, equals(theme.colorScheme.onSurface.withValues(alpha: 0.4)));
      });

      testWidgets('applies correct text style from theme', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(),
        );

        final text = tester.widget<Text>(find.textContaining('Added by'));
        expect(text.style?.fontSize, equals(14.0));
        expect(text.style, isA<TextStyle>());
      });

      testWidgets('respects custom text size while maintaining theme style', (tester) async {
        const customTextSize = 16.0;
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(textSize: customTextSize),
        );

        final text = tester.widget<Text>(find.textContaining('Added by'));
        expect(text.style?.fontSize, equals(customTextSize));
        expect(text.style, isA<TextStyle>());
      });
    });

    group('Edge Cases', () {
      testWidgets('handles zero icon size gracefully', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(iconSize: 0.0),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.person_rounded));
        expect(icon.size, equals(0.0));
        
        // Widget should still render without errors
        expect(find.byType(BulletAddedByHeaderWidget), findsOneWidget);
      });

      testWidgets('handles zero text size gracefully', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(textSize: 0.0),
        );

        final text = tester.widget<Text>(find.textContaining('Added by'));
        expect(text.style?.fontSize, equals(0.0));
        
        // Widget should still render without errors
        expect(find.byType(BulletAddedByHeaderWidget), findsOneWidget);
      });

      testWidgets('handles reasonable large sizes gracefully', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: const BulletAddedByHeaderWidget(
            iconSize: 50.0,
            textSize: 20.0,
          ),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.person_rounded));
        expect(icon.size, equals(50.0));

        final text = tester.widget<Text>(find.textContaining('Added by'));
        expect(text.style?.fontSize, equals(20.0));
        
        // Widget should still render without errors
        expect(find.byType(BulletAddedByHeaderWidget), findsOneWidget);
      });
    });
  });
}