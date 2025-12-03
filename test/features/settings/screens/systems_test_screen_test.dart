// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:zoe/features/settings/screens/systems_test_screen.dart';
// import 'package:zoe_native/providers.dart';
// import 'package:zoe_native/src/rust/third_party/zoe_client/client.dart';
//
// import '../../../test-utils/test_utils.dart';
//
// /// Mock client for testing
// class MockClient implements Client {
//   @override
//   Future<String> idHex() async => 'test-client-123';
//
//   @override
//   dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }
//
// /// Mock enhanced systems test notifier for testing
// class MockEnhancedSystemsTestNotifier extends EnhancedSystemsTestNotifier {
//   final AsyncValue<EnhancedSystemsTestResult> initialState;
//
//   MockEnhancedSystemsTestNotifier(this.initialState);
//
//   @override
//   Future<EnhancedSystemsTestResult> build() async {
//     return initialState.when(
//       data: (data) => data,
//       loading: () => throw StateError('Still loading'),
//       error: (error, stack) => throw error,
//     );
//   }
//
//   @override
//   AsyncValue<EnhancedSystemsTestResult> get state => initialState;
// }
//
// void main() {
//   late ProviderContainer container;
//
//   Future<void> pumpSystemsTestScreen(WidgetTester tester) async {
//     await tester.pumpMaterialWidgetWithProviderScope(
//       child: const SystemsTestScreen(),
//       container: container,
//     );
//     await tester.pumpAndSettle();
//   }
//
//   setUp(() {
//     container = ProviderContainer.test(
//       overrides: [
//         clientProvider.overrideWith((ref) => Future.value(MockClient())),
//         enhancedSystemsTestProvider.overrideWith(
//           () => MockEnhancedSystemsTestNotifier(const AsyncLoading()),
//         ),
//       ],
//     );
//   });
//
//   group('SystemsTestScreen', () {
//     testWidgets('shows error state when loading fails', (tester) async {
//       // Set error state
//       container = ProviderContainer.test(
//         overrides: [
//           clientProvider.overrideWith((ref) => Future.value(MockClient())),
//           enhancedSystemsTestProvider.overrideWith(
//             () => MockEnhancedSystemsTestNotifier(
//               AsyncError('Failed to load systems test', StackTrace.empty),
//             ),
//           ),
//         ],
//       );
//
//       // Pump the widget and wait for it to settle
//       await pumpSystemsTestScreen(tester);
//
//       // Verify error UI
//       expect(
//         find.byWidgetPredicate(
//           (widget) {
//             if (widget is! Icon) return false;
//             return widget.icon == Icons.error_outline;
//           },
//         ),
//         findsOneWidget,
//       );
//       expect(find.text('Failed to load client information'), findsOneWidget);
//     });
//
//     testWidgets('shows client info when data is available', (tester) async {
//
//       // Set success state with test data
//       final clientInfo = ClientInfo(
//         clientId: 'test-client-123',
//         serverAddress: 'test.server.com',
//         serverKey: 'test-key-456',
//         isConnected: true,
//         relayServers: [],
//       );
//
//       final testResult = EnhancedSystemsTestResult(
//         clientInfo: clientInfo,
//         success: true,
//         timestamp: DateTime.now(),
//         totalDuration: const Duration(milliseconds: 100),
//         categories: [],
//         currentResults: null,
//         isRunning: false,
//       );
//
//       container = ProviderContainer.test(
//         overrides: [
//           clientProvider.overrideWith((ref) => Future.value(MockClient())),
//           enhancedSystemsTestProvider.overrideWith(
//             () => MockEnhancedSystemsTestNotifier(AsyncData(testResult)),
//           ),
//         ],
//       );
//
//       // Pump the widget and wait for it to settle
//       await pumpSystemsTestScreen(tester);
//
//       // Verify client info UI
//       expect(find.text('Client Information'), findsOneWidget);
//       expect(find.text('test-client-123'), findsOneWidget);
//       expect(find.text('test.server.com'), findsOneWidget);
//       expect(find.text('test-key-456'), findsOneWidget);
//       expect(find.text('Connected'), findsOneWidget);
//     });
//   });
// }
