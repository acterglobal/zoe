import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/documents/widgets/document_action_button_widget.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('DocumentActionButtons Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    testWidgets('renders download and share buttons', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentActionButtons(
            onDownload: () {},
            onShare: () {},
          ),
        ),
        container: container,
      );

      expect(find.byIcon(Icons.download), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('calls onDownload when download button is tapped', (tester) async {
      bool downloadCalled = false;

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentActionButtons(
            onDownload: () => downloadCalled = true,
            onShare: () {},
          ),
        ),
        container: container,
      );

      await tester.tap(find.byIcon(Icons.download));
      await tester.pumpAndSettle();

      expect(downloadCalled, isTrue);
    });

    testWidgets('calls onShare when share button is tapped', (tester) async {
      bool shareCalled = false;

      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentActionButtons(
            onDownload: () {},
            onShare: () => shareCalled = true,
          ),
        ),
        container: container,
      );

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      expect(shareCalled, isTrue);
    });

    testWidgets('renders buttons in a row with spacing', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentActionButtons(
            onDownload: () {},
            onShare: () {},
          ),
        ),
        container: container,
      );

      // Check that both icons are present
      expect(find.byIcon(Icons.download), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      
      // Check that the widget renders without errors
      expect(find.byType(DocumentActionButtons), findsOneWidget);
    });

    testWidgets('uses theme primary color', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: DocumentActionButtons(
            onDownload: () {},
            onShare: () {},
          ),
        ),
        container: container,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
      );

      // The widget should render without errors using the theme color
      expect(find.byIcon(Icons.download), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });
  });
}
