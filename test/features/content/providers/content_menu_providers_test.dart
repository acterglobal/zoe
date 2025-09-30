import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';

void main() {
  group('ToggleContentMenu Provider Tests', () {
    test('initial state is false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final value = container.read(toggleContentMenuProvider);
      expect(value, false);
    });

    test('can update state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initial state
      expect(container.read(toggleContentMenuProvider), false);

      // Update state
      container.read(toggleContentMenuProvider.notifier).update(true);
      expect(container.read(toggleContentMenuProvider), true);

      // Update back to false
      container.read(toggleContentMenuProvider.notifier).update(false);
      expect(container.read(toggleContentMenuProvider), false);
    });

    test('state changes are tracked by listener', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      var callCount = 0;
      container.listen(
        toggleContentMenuProvider,
        (previous, next) => callCount++,
        fireImmediately: true,
      );

      // Initial state triggers listener
      expect(callCount, 1);

      // Update state
      container.read(toggleContentMenuProvider.notifier).update(true);
      expect(callCount, 2);

      // Update with same value doesn't trigger listener
      container.read(toggleContentMenuProvider.notifier).update(true);
      expect(callCount, 2);

      // Update with different value triggers listener
      container.read(toggleContentMenuProvider.notifier).update(false);
      expect(callCount, 3);
    });
  });
}
