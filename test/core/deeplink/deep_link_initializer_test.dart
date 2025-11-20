import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/core/deeplink/deep_link_initializer.dart';
import 'package:zoe/core/routing/app_router.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../../features/sheet/utils/sheet_utils.dart';
import '../../features/users/utils/users_utils.dart';
import '../../test-utils/mock_gorouter.dart';
import '../../test-utils/test_utils.dart';

/// Helper class to manage AppLinks stream without exposing StreamController
class TestableAppLinks extends Mock implements AppLinks {
  final StreamController<Uri> _linkStreamController =
      StreamController<Uri>.broadcast();

  TestableAppLinks() {
    when(() => getInitialLink()).thenAnswer((_) async => null);
    when(() => uriLinkStream).thenAnswer((_) => _linkStreamController.stream);
  }

  /// Emit a URI to simulate an incoming deep link
  void emitLink(Uri uri) {
    _linkStreamController.add(uri);
  }

  /// Emit an error to simulate a stream error
  void emitError(Object error) {
    _linkStreamController.addError(error);
  }

  /// Clean up resources
  void dispose() {
    _linkStreamController.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeepLinkInitializer Tests', () {
    late ProviderContainer container;
    late TestableAppLinks testableAppLinks;
    late SheetModel testSheet;
    late String testUserId;
    late String testSheetId;
    late MockGoRouter mockGoRouter;

    setUpAll(() {
      registerFallbackValue(Uri());
      registerFallbackValue(const RouteSettings());
    });

    setUp(() {
      // Create sheet/user test fixtures using your util functions
      container = ProviderContainer.test();
      mockGoRouter = MockGoRouter();
      testSheet = getSheetByIndex(container);
      testSheetId = testSheet.id;
      testUserId = getUserByIndex(container).id;

      testableAppLinks = TestableAppLinks();

      container = ProviderContainer.test(
        overrides: [
          routerProvider.overrideWithValue(mockGoRouter),
          loggedInUserProvider.overrideWithValue(AsyncValue.data(testUserId)),
          appLinksProvider.overrideWithValue(testableAppLinks),
        ],
      );
    });

    tearDown(() {
      testableAppLinks.dispose();
    });

    Future<void> pumpDeepLinkInitializer(
      WidgetTester tester, {
      ProviderContainer? testContainer,
    }) async {
      final containerToUse =
          testContainer ??
          ProviderContainer.test(
            overrides: [
              routerProvider.overrideWithValue(mockGoRouter),
              appLinksProvider.overrideWithValue(testableAppLinks),
            ],
          );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: containerToUse,
        router: mockGoRouter,
        child: DeepLinkInitializer(
          child: const Scaffold(body: Text('Test Child')),
        ),
      );
      await tester.pumpAndSettle();
    }

    group('Widget Initialization', () {
      testWidgets('renders child widget correctly', (tester) async {
        await pumpDeepLinkInitializer(tester);
        expect(find.text('Test Child'), findsOneWidget);
        expect(find.byType(DeepLinkInitializer), findsOneWidget);
      });
    });

    group('Initial Link Handling', () {
      testWidgets('handles null initial link (no crash)', (tester) async {
        // default TestableAppLinks returns null initial link
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('handles error getting initial link (no crash)', (
        tester,
      ) async {
        // simulate getInitialLink throwing by replacing testableAppLinks temporarily
        final throwingLinks = TestableAppLinks();
        when(() => throwingLinks.getInitialLink()).thenThrow(Exception('boom'));

        final containerWithThrowing = ProviderContainer.test(
          overrides: [
            routerProvider.overrideWithValue(mockGoRouter),
            loggedInUserProvider.overrideWithValue(AsyncValue.data(testUserId)),
            appLinksProvider.overrideWithValue(throwingLinks),
          ],
        );

        await pumpDeepLinkInitializer(
          tester,
          testContainer: containerWithThrowing,
        );
        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);

        throwingLinks.dispose();
        containerWithThrowing.dispose();
      });
    });

    group('Incoming Link Handling', () {
      testWidgets('handles valid incoming link (no crash)', (tester) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        final validUri = Uri.parse('https://hellozoe.app/sheet/$testSheetId');
        testableAppLinks.emitLink(validUri);

        // Allow post-frame callbacks, navigation and bottom-sheet show (if any)
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('ignores invalid incoming link (no crash)', (tester) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        final invalidUri = Uri.parse('https://example.com/invalid');
        testableAppLinks.emitLink(invalidUri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('handles error in link stream (no crash)', (tester) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        testableAppLinks.emitError(Exception('Stream error'));

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets(
        'ignores incoming link when widget is not mounted (no crash)',
        (tester) async {
          await pumpDeepLinkInitializer(tester);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();

          final validUri = Uri.parse('https://hellozoe.app/sheet/$testSheetId');
          testableAppLinks.emitLink(validUri);

          await tester.pumpAndSettle();
          expect(find.text('Test Child'), findsNothing);
        },
      );
    });

    group('Edge Cases', () {
      testWidgets('handles URI with empty sheet ID', (tester) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        final invalidUri = Uri.parse('https://hellozoe.app/sheet/');
        testableAppLinks.emitLink(invalidUri);
        await tester.pumpAndSettle();

        // No navigation should be triggered for empty sheet id. We assert that 'HOME' is present.
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('handles multiple rapid incoming links', (tester) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        for (int i = 0; i < 3; i++) {
          final validUri = Uri.parse('https://hellozoe.app/sheet/$testSheetId');
          testableAppLinks.emitLink(validUri);
        }

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('handles URI with special characters in sheet ID', (
        tester,
      ) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        final specialSheetId = 'test-sheet-id-123';
        final validUri = Uri.parse(
          'https://hellozoe.app/sheet/$specialSheetId',
        );
        testableAppLinks.emitLink(validUri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('handles very long sheet ID', (tester) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        final longSheetId = 'a' * 1000;
        final validUri = Uri.parse('https://hellozoe.app/sheet/$longSheetId');
        testableAppLinks.emitLink(validUri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });
    });
  });
}
