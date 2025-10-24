import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/home/widgets/app_bar/connection_status_indicator.dart';
import 'package:zoe_native/providers.dart';
import 'package:zoe_native/zoe_native.dart';
import '../../../../test-utils/test_utils.dart';

class MockOverallConnectionStatus extends Mock
    implements OverallConnectionStatus {}

void main() {
  group('ConnectionStatusWidget', () {
    late ProviderContainer container;
    late MockOverallConnectionStatus mockConnectionStatus;

    setUp(() {
      container = ProviderContainer.test();
      mockConnectionStatus = MockOverallConnectionStatus();
    });

    Future<void> pumpConnectionStatusWidget(WidgetTester tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const ConnectionStatusWidget(),
      );
    }

    // Helper function to get Tooltip widget
    Tooltip getTooltip(WidgetTester tester) {
      return tester.widget<Tooltip>(find.byType(Tooltip));
    }

    group('Loading State', () {
      testWidgets('shows loading indicator when connection status is loading', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              const AsyncValue.loading(),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        // Verify loading indicator is shown
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Error State', () {
      testWidgets('shows error icon when connection status has error', (
        tester,
      ) async {
        const errorMessage = 'Connection failed';
        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.error(errorMessage, StackTrace.current),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        // Verify error icon is shown
        expect(find.byIcon(Icons.error_outline_outlined), findsOneWidget);
        expect(find.byType(Tooltip), findsOneWidget);

        // Verify tooltip message
        final tooltip = getTooltip(tester);
        expect(tooltip.message, equals(errorMessage));

        // Verify icon color
        final icon = tester.widget<Icon>(
          find.byIcon(Icons.error_outline_outlined),
        );
        expect(icon.color, equals(Colors.red));
      });

      testWidgets('shows error icon with custom error message', (tester) async {
        const customErrorMessage = 'Network timeout';
        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.error(customErrorMessage, StackTrace.current),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        expect(find.byIcon(Icons.error_outline_outlined), findsOneWidget);

        final tooltip = getTooltip(tester);
        expect(tooltip.message, equals(customErrorMessage));
      });
    });

    group('Connected State', () {
      testWidgets('shows connected icon when fully connected', (tester) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(true);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.from(5));
        when(
          () => mockConnectionStatus.connectedCount,
        ).thenReturn(BigInt.from(5));

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        // Verify connected icon is shown
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
        expect(find.byType(Tooltip), findsOneWidget);

        // Verify icon color
        final icon = tester.widget<Icon>(find.byIcon(Icons.check_circle));
        expect(icon.color, equals(Colors.green));

        // Verify tooltip message
        final tooltip = getTooltip(tester);
        expect(tooltip.message, equals('connected to 5 / 5'));
      });

      testWidgets('shows connected icon with different connection counts', (
        tester,
      ) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(true);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.from(3));
        when(
          () => mockConnectionStatus.connectedCount,
        ).thenReturn(BigInt.from(2));

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        expect(find.byIcon(Icons.check_circle), findsOneWidget);

        final tooltip = getTooltip(tester);
        expect(tooltip.message, equals('connected to 3 / 3'));
      });
    });

    group('Disconnected State', () {
      testWidgets('shows error icon when no connections available', (
        tester,
      ) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(false);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.zero);
        when(() => mockConnectionStatus.connectedCount).thenReturn(BigInt.zero);

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        // Verify error icon is shown
        expect(find.byIcon(Icons.error_outline_outlined), findsOneWidget);
        expect(find.byType(Tooltip), findsOneWidget);

        // Verify icon color
        final icon = tester.widget<Icon>(
          find.byIcon(Icons.error_outline_outlined),
        );
        expect(icon.color, equals(Colors.red));

        // Verify tooltip message
        final tooltip = getTooltip(tester);
        expect(tooltip.message, equals('connected to 0 / 0'));
      });

      testWidgets('shows warning icon when partially connected', (
        tester,
      ) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(false);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.from(5));
        when(
          () => mockConnectionStatus.connectedCount,
        ).thenReturn(BigInt.from(2));

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        // Verify warning icon is shown
        expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
        expect(find.byType(Tooltip), findsOneWidget);

        // Verify icon color
        final icon = tester.widget<Icon>(
          find.byIcon(Icons.warning_amber_outlined),
        );
        expect(icon.color, equals(Colors.yellow));

        // Verify tooltip message
        final tooltip = getTooltip(tester);
        expect(tooltip.message, equals('connected to 5 / 5'));
      });
    });

    group('Tooltip Messages', () {
      testWidgets('displays correct tooltip for connected state', (
        tester,
      ) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(true);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.from(4));
        when(
          () => mockConnectionStatus.connectedCount,
        ).thenReturn(BigInt.from(4));

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        final tooltip = getTooltip(tester);
        expect(tooltip.message, equals('connected to 4 / 4'));
      });

      testWidgets('displays correct tooltip for warning state', (tester) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(false);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.from(3));
        when(
          () => mockConnectionStatus.connectedCount,
        ).thenReturn(BigInt.from(1));

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        final tooltip = getTooltip(tester);
        expect(tooltip.message, equals('connected to 3 / 3'));
      });

      testWidgets('displays correct tooltip for error state', (tester) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(false);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.zero);
        when(() => mockConnectionStatus.connectedCount).thenReturn(BigInt.zero);

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        final tooltip = getTooltip(tester);
        expect(tooltip.message, equals('connected to 0 / 0'));
      });
    });

    group('Icon Colors', () {
      testWidgets('uses green color for connected state', (tester) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(true);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.from(2));
        when(
          () => mockConnectionStatus.connectedCount,
        ).thenReturn(BigInt.from(2));

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        final icon = tester.widget<Icon>(find.byIcon(Icons.check_circle));
        expect(icon.color, equals(Colors.green));
      });

      testWidgets('uses red color for error state', (tester) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(false);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.zero);
        when(() => mockConnectionStatus.connectedCount).thenReturn(BigInt.zero);

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        final icon = tester.widget<Icon>(
          find.byIcon(Icons.error_outline_outlined),
        );
        expect(icon.color, equals(Colors.red));
      });

      testWidgets('uses yellow color for warning state', (tester) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(false);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.from(3));
        when(
          () => mockConnectionStatus.connectedCount,
        ).thenReturn(BigInt.from(1));

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        final icon = tester.widget<Icon>(
          find.byIcon(Icons.warning_amber_outlined),
        );
        expect(icon.color, equals(Colors.yellow));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles zero total count correctly', (tester) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(false);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.zero);
        when(() => mockConnectionStatus.connectedCount).thenReturn(BigInt.zero);

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        expect(find.byIcon(Icons.error_outline_outlined), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber_outlined), findsNothing);
        expect(find.byIcon(Icons.check_circle), findsNothing);
      });

      testWidgets('handles large connection counts correctly', (tester) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(true);
        when(
          () => mockConnectionStatus.totalCount,
        ).thenReturn(BigInt.from(1000));
        when(
          () => mockConnectionStatus.connectedCount,
        ).thenReturn(BigInt.from(1000));

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        expect(find.byIcon(Icons.check_circle), findsOneWidget);

        final tooltip = getTooltip(tester);
        expect(tooltip.message, equals('connected to 1000 / 1000'));
      });

      testWidgets('handles partial connection correctly', (tester) async {
        when(() => mockConnectionStatus.isConnected).thenReturn(false);
        when(() => mockConnectionStatus.totalCount).thenReturn(BigInt.from(10));
        when(
          () => mockConnectionStatus.connectedCount,
        ).thenReturn(BigInt.from(7));

        container = ProviderContainer.test(
          overrides: [
            connectionStatusProvider.overrideWithValue(
              AsyncValue.data(mockConnectionStatus),
            ),
          ],
        );

        await pumpConnectionStatusWidget(tester);

        expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
        expect(find.byIcon(Icons.error_outline_outlined), findsNothing);
        expect(find.byIcon(Icons.check_circle), findsNothing);
      });
    });
  });
}
