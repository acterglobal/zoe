import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/documents/widgets/document_error_widget.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('DocumentErrorWidget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    testWidgets('renders error widget with error name', (tester) async {
      const errorName = 'Failed to load document';

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentErrorWidget(errorName: errorName),
        ),
        container: container,
      );

      expect(find.text(errorName), findsOneWidget);
      expect(find.byIcon(Icons.broken_image_rounded), findsOneWidget);
    });

    testWidgets('displays correct icon', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentErrorWidget(errorName: 'Test Error'),
        ),
        container: container,
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.broken_image_rounded));
      expect(iconWidget.size, equals(64));
    });

    testWidgets('has correct container dimensions', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentErrorWidget(errorName: 'Test Error'),
        ),
        container: container,
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      expect(containerWidget.constraints?.maxHeight, equals(300));
      expect(containerWidget.constraints?.maxWidth, equals(double.infinity));
    });

    testWidgets('has correct border radius', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentErrorWidget(errorName: 'Test Error'),
        ),
        container: container,
      );

      final containerWidget = tester.widget<Container>(find.byType(Container));
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.borderRadius, equals(BorderRadius.circular(16)));
    });

    testWidgets('uses theme colors', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentErrorWidget(errorName: 'Test Error'),
        ),
        container: container,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
      );

      // The widget should render without errors using theme colors
      expect(find.text('Test Error'), findsOneWidget);
      expect(find.byIcon(Icons.broken_image_rounded), findsOneWidget);
    });

    testWidgets('handles empty error name', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentErrorWidget(errorName: ''),
        ),
        container: container,
      );

      expect(find.text(''), findsOneWidget);
      expect(find.byIcon(Icons.broken_image_rounded), findsOneWidget);
    });

    testWidgets('uses error color for icon and text', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentErrorWidget(errorName: 'Test Error'),
        ),
        container: container,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
      );

      // Check that icon and text are rendered with error styling
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.broken_image_rounded));
      expect(iconWidget.color, isNotNull);

      final textWidget = tester.widget<Text>(find.text('Test Error'));
      expect(textWidget.style?.color, isNotNull);
    });
  });
}
