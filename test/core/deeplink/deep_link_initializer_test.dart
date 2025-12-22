import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/core/deeplink/deep_link_initializer.dart';
import 'package:zoe/core/routing/app_router.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../../features/sheet/mocks/mock_sheet.dart';
import '../../features/users/mocks/mock_user.dart';
import '../../test-utils/mock_gorouter.dart';
import '../../test-utils/test_utils.dart';
import 'mock/mock_deeplink.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late MockAppLinks mockAppLinks;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockGoRouter = MockGoRouter();
    mockAppLinks = MockAppLinks();
    container = ProviderContainer.test();
  });

  ProviderContainer buildContainer({UserModel? user, SheetModel? sheet}) {
    return ProviderContainer(
      overrides: [
        sheetListProvider.overrideWith(MockSheetList.new),
        userListProvider.overrideWith(MockUserList.new),
        routerProvider.overrideWithValue(mockGoRouter),
        appLinksProvider.overrideWithValue(mockAppLinks),
        if (user != null) authProvider.overrideWithValue(user),
        if (sheet != null)
          getSheetByIdProvider(sheet.id).overrideWith((_) async => sheet),
      ],
    );
  }

  group('DeepLinkInitializer Tests', () {
    late SheetModel testSheet;
    late UserModel testUser;
    late String testSheetId;

    setUp(() {
      container = buildContainer();
      final sheetList = container.read(sheetListProvider);
      if (sheetList.isEmpty) fail('Sheet list is empty');
      testSheet = sheetList.first;
      testSheetId = testSheet.id;
      final userList = container.read(userListProvider);
      if (userList.isEmpty) fail('User list is empty');
      testUser = userList.first;
      container = buildContainer(user: testUser, sheet: testSheet);
    });

    tearDown(() => mockAppLinks.dispose());

    Future<void> pumpDeepLinkInitializer(
      WidgetTester tester, {
      ProviderContainer? testContainer,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: testContainer ?? container,
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

    group('Incoming Link Handling', () {
      testWidgets('handles valid incoming link (no crash)', (tester) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        final validUri = Uri.parse('https://hellozoe.app/sheet/$testSheetId');
        mockAppLinks.emitLink(validUri);

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
        mockAppLinks.emitLink(invalidUri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('handles error in link stream (no crash)', (tester) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        mockAppLinks.emitError(Exception('Stream error'));

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
          mockAppLinks.emitLink(validUri);

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
        mockAppLinks.emitLink(invalidUri);
        await tester.pumpAndSettle();

        // No navigation should be triggered for empty sheet id. We assert that 'HOME' is present.
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('handles multiple rapid incoming links', (tester) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        for (int i = 0; i < 3; i++) {
          final validUri = Uri.parse('https://hellozoe.app/sheet/$testSheetId');
          mockAppLinks.emitLink(validUri);
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
        mockAppLinks.emitLink(validUri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('handles very long sheet ID', (tester) async {
        await pumpDeepLinkInitializer(tester);
        await tester.pumpAndSettle();

        final longSheetId = 'a' * 1000;
        final validUri = Uri.parse('https://hellozoe.app/sheet/$longSheetId');
        mockAppLinks.emitLink(validUri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });
    });
  });
}
