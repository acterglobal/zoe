import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/whatsapp/providers/whatsapp_group_connect_provider.dart';

void main() {
  group('IsConnecting Provider -', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    test('initial state is false', () {
      final isConnecting = container.read(isConnectingProvider);
      expect(isConnecting, false);
    });

    test('update() changes state correctly', () {
      // Initial state should be false
      expect(container.read(isConnectingProvider), false);

      // Update to true
      container.read(isConnectingProvider.notifier).update(true);
      expect(container.read(isConnectingProvider), true);

      // Update back to false
      container.read(isConnectingProvider.notifier).update(false);
      expect(container.read(isConnectingProvider), false);
    });

    test('state updates trigger listeners', () {
      int listenerCallCount = 0;
      bool? lastValue;

      // Add listener
      container.listen(
        isConnectingProvider,
        (previous, next) {
          listenerCallCount++;
          lastValue = next;
        },
      );

      // Initial state should not trigger listener
      expect(listenerCallCount, 0);
      expect(lastValue, null);

      // Update to true should trigger listener
      container.read(isConnectingProvider.notifier).update(true);
      expect(listenerCallCount, 1);
      expect(lastValue, true);

      // Update to same value should not trigger listener
      container.read(isConnectingProvider.notifier).update(true);
      expect(listenerCallCount, 1);
      expect(lastValue, true);

      // Update to false should trigger listener
      container.read(isConnectingProvider.notifier).update(false);
      expect(listenerCallCount, 2);
      expect(lastValue, false);
    });
  });
}
