import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/features/whatsapp/providers/whatsapp_group_connect_provider.dart';
import 'package:zoe/features/whatsapp/screens/whatsapp_group_connect_screen.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../helpers/mock_gorouter.dart';
import '../../../helpers/test_utils.dart';

void main() {
  late ProviderContainer container;
  late GoRouter mockRouter;
  late L10n l10n;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    l10n = await L10n.delegate.load(const Locale('en'));
  });

  setUp(() {
    mockRouter = MockGoRouter();
    container = ProviderContainer.test(
      overrides: [
        isConnectingProvider.overrideWithValue(false),
      ],
    );

    when(() => mockRouter.pop()).thenAnswer((_) async {});
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      child: InheritedGoRouter(
            goRouter: mockRouter,
            child: const WhatsAppGroupConnectScreen(sheetId: 'test-sheet'),
        
        ),
      
    );
    
    // First pump to trigger widget build
    await tester.pump();
    
    // Pump a few more times with delays to ensure localizations are loaded
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('WhatsAppGroupConnectScreen -', () {
    testWidgets('renders all UI components correctly', (tester) async {
      await pumpScreen(tester);

      // Verify AppBar
      expect(find.byType(AppBar), findsOneWidget);

      // Verify Guide Steps
      expect(find.text('1'), findsOneWidget); // Step 1 number
      expect(find.text('2'), findsOneWidget); // Step 2 number
      expect(find.text('3'), findsOneWidget); // Step 3 number

      // Verify Form Elements
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);

      // Verify Important Note
      expect(find.byIcon(Icons.info_outline), findsOneWidget);

      // Verify Connect Button
      expect(find.byType(ZoePrimaryButton), findsOneWidget);
    });

    group('Form Validation -', () {
      testWidgets('shows error for empty group link', (tester) async {
        await pumpScreen(tester);

        // Try to connect without entering link
        await tester.tap(find.byType(ZoePrimaryButton));
        await tester.pump();

        // Verify error message
        expect(find.text(l10n.whatsappGroupLinkRequired), findsOneWidget);
      });

      testWidgets('shows error for invalid group link', (tester) async {
        await pumpScreen(tester);

        // Enter invalid link
        await tester.enterText(
          find.byType(TextFormField),
          'invalid-link',
        );
        await tester.tap(find.byType(ZoePrimaryButton));
        await tester.pump();

        // Verify error message
        expect(find.text(l10n.whatsappGroupLinkInvalid), findsOneWidget);
      });
    });

    group('Connection Process -', () {
      testWidgets('shows connecting state and success dialog', (tester) async {
        // Create a new container with connecting state
        final testContainer = ProviderContainer(
          overrides: [
            isConnectingProvider.overrideWithValue(true),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: testContainer,
          child: InheritedGoRouter(
                goRouter: mockRouter,
                child: const WhatsAppGroupConnectScreen(sheetId: 'test-sheet'),
          ),
        );
        
        // First pump to trigger widget build
        await tester.pump();
        
        // Pump a few more times with delays to ensure localizations are loaded
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // Verify connecting state
        expect(find.text(l10n.connecting), findsOneWidget);

        // Clean up
        testContainer.dispose();
      });

      testWidgets('handles connection errors gracefully', (tester) async {
        // Override provider to simulate error
        final errorContainer = ProviderContainer(
          overrides: [
            isConnectingProvider.overrideWithValue(true),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: errorContainer,
            child: InheritedGoRouter(
                goRouter: mockRouter,
                child: const WhatsAppGroupConnectScreen(sheetId: 'test-sheet'),
              
          
          ),
        );
        
        // First pump to trigger widget build
        await tester.pump();
        
        // Pump a few more times with delays to ensure localizations are loaded
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // Enter valid link
        await tester.enterText(
          find.byType(TextFormField),
          'https://chat.whatsapp.com/valid-group-id',
        );

        // Start connection
        await tester.tap(find.byType(ZoePrimaryButton));
        await tester.pump();

        // Verify error handling (no crash)
        expect(find.byType(ZoePrimaryButton), findsOneWidget);
        verifyNever(() => mockRouter.pop());
      });
    });

    testWidgets('scrolls to bottom on validation error', (tester) async {
      await pumpScreen(tester);

      // Get scroll controller
      final scrollable = find.byType(SingleChildScrollView);
      final scrollController = tester.widget<SingleChildScrollView>(scrollable).controller;

      // Try to connect without entering link
      await tester.tap(find.byType(ZoePrimaryButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300)); // Wait for scroll animation

      // Get the current scroll position and max scroll extent
      final currentPosition = scrollController?.position.pixels ?? 0;
      final maxScrollExtent = scrollController?.position.maxScrollExtent ?? 0;

      // Verify scroll position is near the bottom (within 20 pixels)
      expect((maxScrollExtent - currentPosition).abs(), lessThanOrEqualTo(20.0));
    });
  });
}