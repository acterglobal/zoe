import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/core/deeplink/deep_link_initializer.dart';
import 'package:zoe/core/routing/app_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
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

  setUp(() async {
    mockGoRouter = MockGoRouter();
    final mockRouterDelegate = MockGoRouterDelegate();
    final navigatorKey = GlobalKey<NavigatorState>();
    when(() => mockGoRouter.routerDelegate).thenReturn(mockRouterDelegate);
    when(() => mockRouterDelegate.navigatorKey).thenReturn(navigatorKey);

    mockAppLinks = MockAppLinks();
    container = ProviderContainer.test();

    // Prevent navigation calls from throwing during tests.
    when(() => mockGoRouter.go(any())).thenReturn(null);
    when(() => mockGoRouter.push(any())).thenAnswer((_) async => null);
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

  group('DeepLinkInitializer', () {
    late SheetModel testSheet;
    late UserModel testUser;
    late String testSheetId;

    setUp(() {
      // First build a base container to obtain sample models from mocks.
      container = buildContainer();
      final sheetList = container.read(sheetListProvider);
      if (sheetList.isEmpty) fail('Sheet list is empty');
      testSheet = sheetList.first;
      testSheetId = testSheet.id;

      final userList = container.read(userListProvider);
      if (userList.isEmpty) fail('User list is empty');
      testUser = userList.first;

      // Rebuild container with an authenticated user and a concrete sheet lookup.
      container = buildContainer(user: testUser, sheet: testSheet);
    });

    group('widget structure', () {
      testWidgets('renders child widget correctly', (tester) async {
        await pumpDeepLinkInitializer(tester);

        expect(find.byType(DeepLinkInitializer), findsOneWidget);
        expect(find.text('Test Child'), findsOneWidget);
      });
    });

    group('link parsing and ignoring invalid URIs', () {
      testWidgets('ignores link with different host', (tester) async {
        await pumpDeepLinkInitializer(tester);

        final uri = Uri.parse('https://example.com/sheet/$testSheetId');
        mockAppLinks.emitLink(uri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('ignores link with non-https scheme', (tester) async {
        await pumpDeepLinkInitializer(tester);

        final uri = Uri.parse('http://hellozoe.app/sheet/$testSheetId');
        mockAppLinks.emitLink(uri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('ignores link with non-sheet path', (tester) async {
        await pumpDeepLinkInitializer(tester);

        final uri = Uri.parse('https://hellozoe.app/other/$testSheetId');
        mockAppLinks.emitLink(uri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('ignores URI with empty sheet ID segment', (tester) async {
        await pumpDeepLinkInitializer(tester);

        final uri = Uri.parse('https://hellozoe.app/sheet/');
        mockAppLinks.emitLink(uri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });
    });

    group('stream handling', () {
      testWidgets('handles valid sheet link without crashing', (tester) async {
        await pumpDeepLinkInitializer(tester);

        final uri = Uri.parse('https://hellozoe.app/sheet/$testSheetId');
        mockAppLinks.emitLink(uri);

        // Allow post-frame callbacks, navigation and potential bottom sheet.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('handles error event from link stream without crashing', (
        tester,
      ) async {
        await pumpDeepLinkInitializer(tester);

        mockAppLinks.emitError(Exception('Stream error'));

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('ignores incoming link when widget is no longer mounted', (
        tester,
      ) async {
        await pumpDeepLinkInitializer(tester);

        // Replace the widget tree so DeepLinkInitializer is disposed.
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();

        final uri = Uri.parse('https://hellozoe.app/sheet/$testSheetId');
        mockAppLinks.emitLink(uri);

        await tester.pumpAndSettle();
        expect(find.text('Test Child'), findsNothing);
      });
    });

    group('navigation and membership', () {
      testWidgets('does nothing when user is not authenticated', (
        tester,
      ) async {
        // Build a container without auth override so currentUser is null.
        final unauthContainer = buildContainer();

        await pumpDeepLinkInitializer(tester, testContainer: unauthContainer);

        final uri = Uri.parse('https://hellozoe.app/sheet/$testSheetId');
        mockAppLinks.emitLink(uri);

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        verifyNever(() => mockGoRouter.go(any()));
        verifyNever(() => mockGoRouter.push(any()));
      });

      testWidgets('shows join sheet bottom sheet when user is not a member', (
        tester,
      ) async {
        // Ensure the sheet does not contain the current user's id.
        final nonMemberSheet = testSheet.copyWith(users: ['testUser']);

        final nonMemberContainer = buildContainer(
          user: testUser,
          sheet: nonMemberSheet,
        );

        await pumpDeepLinkInitializer(
          tester,
          testContainer: nonMemberContainer,
        );

        final uri = Uri.parse('https://hellozoe.app/sheet/$testSheetId');
        mockAppLinks.emitLink(uri);

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        // For a non-member, we expect no sheet route push.
        verifyNever(() => mockGoRouter.push(any()));
      });

      testWidgets('navigates to sheet route when user is a member', (
        tester,
      ) async {
        final memberSheet = testSheet.copyWith(users: [testUser.id]);

        final memberContainer = buildContainer(
          user: testUser,
          sheet: memberSheet,
        );

        await pumpDeepLinkInitializer(tester, testContainer: memberContainer);

        final uri = Uri.parse('https://hellozoe.app/sheet/$testSheetId');
        mockAppLinks.emitLink(uri);

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        verify(
          () => mockGoRouter.push(
            AppRoutes.sheet.route.replaceAll(':sheetId', testSheetId),
          ),
        ).called(1);
      });
    });

    group('sheet share info', () {
      testWidgets('updates sheet share info when query parameters are present', (
        tester,
      ) async {
        await pumpDeepLinkInitializer(tester);

        final beforeSheet = container
            .read(sheetListProvider)
            .firstWhere((s) => s.id == testSheetId);
        expect(beforeSheet.sharedBy, isNull);
        expect(beforeSheet.message, isNull);

        final uri = Uri.parse(
          'https://hellozoe.app/sheet/$testSheetId?sharedBy=${testUser.id}&message=hello',
        );
        mockAppLinks.emitLink(uri);

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        final updatedSheet = container
            .read(sheetListProvider)
            .firstWhere((s) => s.id == testSheetId);
        expect(updatedSheet.sharedBy, testUser.id);
        expect(updatedSheet.message, 'hello');
      });

      testWidgets('handles sheet not found gracefully', (tester) async {
        // New container where fetching the sheet returns null.
        final notFoundContainer = buildContainer(user: testUser);

        await pumpDeepLinkInitializer(tester, testContainer: notFoundContainer);

        final uri = Uri.parse('https://hellozoe.app/sheet/non-existent-id');
        mockAppLinks.emitLink(uri);

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();

        // No additional navigation to sheet route should occur.
        verifyNever(() => mockGoRouter.push(any()));
      });
    });
  });
}
