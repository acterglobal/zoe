import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/animated_background_widget.dart';
import 'package:zoe/common/widgets/drawer/hamburger_drawer_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/home/screens/home_screen.dart';
import 'package:zoe/features/home/widgets/section_header/section_header_widget.dart';
import 'package:zoe/features/home/widgets/stats_section/stats_section_widget.dart';
import 'package:zoe/features/home/widgets/today_focus/todays_focus_widget.dart';
import 'package:zoe/features/home/widgets/welcome_section/welcome_section_widget.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_widget.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
// import 'package:zoe_native/providers.dart';
// import 'package:zoe_native/zoe_native.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('HomeScreen', () {
    late ProviderContainer container;
    late GoRouter mockRouter;

    setUp(() {
      mockRouter = MockGoRouter();
      container = ProviderContainer.test(
        overrides: [
          // Override providers that might cause async operations
          currentUserProvider.overrideWithValue(const AsyncValue.data(null)),
          isUserLoggedInProvider.overrideWithValue(const AsyncValue.data(true)),
          // connectionStatusProvider.overrideWithValue(
          //   AsyncValue.data(
          //     OverallConnectionStatus(
          //       isConnected: true,
          //       connectedCount: BigInt.one,
          //       totalCount: BigInt.one,
          //     ),
          //   ),
          // ),
        ],
      );
    });

    Future<void> pumpHomeScreen(WidgetTester tester, {GoRouter? router}) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        router: router ?? mockRouter,
        child: const HomeScreen(),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      // Allow pending timers to complete
      await tester.pump(const Duration(milliseconds: 300));
    }

    L10n getL10n(WidgetTester tester) {
      return L10n.of(tester.element(find.byType(HomeScreen)));
    }

    group('Widget Structure', () {
      testWidgets('renders with proper scaffold structure', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AnimatedBackgroundWidget), findsOneWidget);
      });

      testWidgets('has app bar with correct configuration', (tester) async {
        await pumpHomeScreen(tester);

        final appBars = find.byType(AppBar);
        expect(appBars, findsAtLeastNWidgets(1));

        final appBar = tester.widget<AppBar>(appBars.last);
        expect(appBar.leadingWidth, equals(100));
        expect(appBar.actionsPadding, equals(const EdgeInsets.only(right: 16)));
      });

      testWidgets('has floating action button', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byType(ZoeFloatingActionButton), findsOneWidget);
      });

      testWidgets('uses SafeArea for body content', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
      });

      testWidgets('uses MaxWidthWidget for responsive layout', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byType(MaxWidthWidget), findsOneWidget);

        final maxWidthWidget = tester.widget<MaxWidthWidget>(
          find.byType(MaxWidthWidget),
        );
        expect(maxWidthWidget.isScrollable, isTrue);
        expect(
          maxWidthWidget.padding,
          equals(const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
        );
      });
    });

    group('AppBar Actions', () {
      testWidgets('renders menu button', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
      });

      testWidgets('renders search button', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byIcon(Icons.search_outlined), findsOneWidget);
      });

      group('QR Scan Button', () {
        testWidgets('shows QR scan button on mobile platforms', (tester) async {
          // Note: Flutter test environment defaults to web platform
          // The QR button is shown only on Android/iOS
          await pumpHomeScreen(tester);

          // On mobile platforms (Android/iOS), QR button should be present
          // On web/desktop, QR button should not be present
          if (Platform.isAndroid || Platform.isIOS) {
            expect(find.byIcon(Icons.qr_code_rounded), findsOneWidget);
          } else {
            expect(find.byIcon(Icons.qr_code_rounded), findsNothing);
          }
        });
      });

      testWidgets('opens drawer when menu button is tapped', (tester) async {
        await pumpHomeScreen(tester);

        await tester.tap(find.byIcon(Icons.menu_rounded));
        await tester.pump();
        await tester.pump();

        // Drawer should be visible after tap
        expect(find.byType(Drawer), findsAtLeastNWidgets(1));
        expect(find.byType(HamburgerDrawerWidget), findsAtLeastNWidgets(1));
      });
    });

    group('Body Sections', () {
      testWidgets('renders welcome section', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byType(WelcomeSectionWidget), findsOneWidget);
      });

      testWidgets('renders stats section', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byType(StatsSectionWidget), findsOneWidget);
      });

      testWidgets('renders today\'s focus section', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byType(TodaysFocusWidget), findsOneWidget);
      });

      testWidgets('renders sheets section header', (tester) async {
        await pumpHomeScreen(tester);

        final sectionHeaders = find.byType(SectionHeaderWidget);
        expect(sectionHeaders, findsAtLeastNWidgets(1));

        // Find the recent sheets section header
        final sheetsHeader = tester
            .widgetList<SectionHeaderWidget>(sectionHeaders)
            .firstWhere(
              (header) => header.title == getL10n(tester).recentSheets,
            );

        expect(sheetsHeader.icon, equals(Icons.description));
      });

      testWidgets('renders sheet list widget', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byType(SheetListWidget), findsOneWidget);

        final sheetList = tester.widget<SheetListWidget>(
          find.byType(SheetListWidget),
        );
        expect(sheetList.sheetsProvider, equals(sheetsListProvider));
        expect(sheetList.shrinkWrap, isTrue);
        expect(sheetList.maxItems, equals(3));
      });

      testWidgets('has correct vertical spacing between sections', (
        tester,
      ) async {
        await pumpHomeScreen(tester);

        // Check for SizedBox widgets with height 16
        final spacing16Widgets = tester
            .widgetList<SizedBox>(find.byType(SizedBox))
            .where((sizedBox) => sizedBox.height == 16);

        expect(spacing16Widgets.length, greaterThanOrEqualTo(1));

        // Check for spacing 32
        final spacing32Widgets = tester
            .widgetList<SizedBox>(find.byType(SizedBox))
            .where((sizedBox) => sizedBox.height == 32);

        expect(spacing32Widgets.length, greaterThanOrEqualTo(1));
      });
    });

    group('Floating Action Button', () {
      testWidgets('renders with correct icon', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      });

      testWidgets('sets edit content ID when creating new sheet', (
        tester,
      ) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.push(any())).thenAnswer((_) async {
          return Future.value(true);
        });

        await pumpHomeScreen(tester, router: mockRouter);

        await tester.tap(find.byType(ZoeFloatingActionButton));
        await tester.pump();
        await tester.pump();

        final newSheet = container.read(sheetListProvider).last;
        final editContentId = container.read(editContentIdProvider);

        expect(editContentId, equals(newSheet.id));
      });
    });

    group('Localization', () {
      testWidgets('displays localized "Recent Sheets" text', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.text(getL10n(tester).recentSheets), findsOneWidget);
      });
    });

    group('Provider Integration', () {
      testWidgets('displays sheets from sheetsListProvider', (tester) async {
        await pumpHomeScreen(tester);

        // The SheetListWidget should receive data from sheetsListProvider
        expect(find.byType(SheetListWidget), findsOneWidget);

        final sheetList = tester.widget<SheetListWidget>(
          find.byType(SheetListWidget),
        );

        expect(sheetList.sheetsProvider, equals(sheetsListProvider));
      });

      testWidgets('handles empty sheet list gracefully', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            sheetListProvider.overrideWithValue([]),
            // Include the same overrides as main setup to prevent timer issues
            currentUserProvider.overrideWithValue(const AsyncValue.data(null)),
            isUserLoggedInProvider.overrideWithValue(
              const AsyncValue.data(true),
            ),
            // connectionStatusProvider.overrideWithValue(
            //   AsyncValue.data(
            //     OverallConnectionStatus(
            //       isConnected: true,
            //       connectedCount: BigInt.one,
            //       totalCount: BigInt.one,
            //     ),
            //   ),
            // ),
          ],
        );

        await pumpHomeScreen(tester);

        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(SheetListWidget), findsOneWidget);
      });
    });

    group('Navigation', () {
      testWidgets('search button navigates to quick search', (tester) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.push(any())).thenAnswer((_) async {
          return Future.value(true);
        });

        await pumpHomeScreen(tester, router: mockRouter);

        await tester.tap(find.byIcon(Icons.search_outlined));
        await tester.pump();
        await tester.pump();
        verify(() => mockRouter.push(AppRoutes.quickSearch.route)).called(1);
      });
    });

    group('Edge Cases', () {
      testWidgets('has proper responsive padding', (tester) async {
        await pumpHomeScreen(tester);

        final maxWidthWidget = tester.widget<MaxWidthWidget>(
          find.byType(MaxWidthWidget),
        );

        expect(
          maxWidthWidget.padding,
          equals(const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
        );
      });

      testWidgets('scaffold has correct background', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byType(AnimatedBackgroundWidget), findsAtLeastNWidgets(1));
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });
    });

    group('Layout Structure', () {
      testWidgets('has proper widget hierarchy', (tester) async {
        await pumpHomeScreen(tester);

        // Verify the overall structure
        expect(find.byType(AnimatedBackgroundWidget), findsAtLeastNWidgets(1));
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
        expect(find.byType(MaxWidthWidget), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('all main sections are present', (tester) async {
        await pumpHomeScreen(tester);

        expect(find.byType(WelcomeSectionWidget), findsOneWidget);
        expect(find.byType(StatsSectionWidget), findsOneWidget);
        expect(find.byType(TodaysFocusWidget), findsOneWidget);
        expect(find.byType(SectionHeaderWidget), findsAtLeastNWidgets(1));
        expect(find.byType(SheetListWidget), findsOneWidget);
      });
    });

    group('User Actions', () {
      testWidgets('FAB creates new sheet with correct flow', (tester) async {
        final mockRouter = MockGoRouter();
        when(() => mockRouter.push(any())).thenAnswer((_) async {
          return Future.value(true);
        });

        await pumpHomeScreen(tester, router: mockRouter);

        final initialCount = container.read(sheetListProvider).length;

        // Wait for the widget to fully initialize
        await tester.pump();

        // Verify FAB exists and tap it
        expect(find.byType(ZoeFloatingActionButton), findsOneWidget);
        await tester.tap(find.byType(ZoeFloatingActionButton));
        await tester.pump();
        await tester.pump();

        // Verify new sheet was created
        final newCount = container.read(sheetListProvider).length;
        expect(newCount, equals(initialCount + 1));

        // Verify editContentId is set
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, isNotNull);
      });
    });
  });
}
