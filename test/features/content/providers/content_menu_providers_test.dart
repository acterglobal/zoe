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

  group('IsEditValue Provider Tests', () {
    test('initial state is false for any parentId', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final value = container.read(isEditValueProvider('test-parent'));
      expect(value, false);
    });

    test('maintains separate states for different parentIds', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initial states
      expect(container.read(isEditValueProvider('parent1')), false);
      expect(container.read(isEditValueProvider('parent2')), false);

      // Update parent1
      container.read(isEditValueProvider('parent1').notifier).update(true);
      expect(container.read(isEditValueProvider('parent1')), true);
      expect(container.read(isEditValueProvider('parent2')), false);

      // Update parent2
      container.read(isEditValueProvider('parent2').notifier).update(true);
      expect(container.read(isEditValueProvider('parent1')), true);
      expect(container.read(isEditValueProvider('parent2')), true);

      // Update parent1 back to false
      container.read(isEditValueProvider('parent1').notifier).update(false);
      expect(container.read(isEditValueProvider('parent1')), false);
      expect(container.read(isEditValueProvider('parent2')), true);
    });

    test('state changes are tracked by listener', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      var callCount = 0;
      container.listen(
        isEditValueProvider('test-parent'),
        (previous, next) => callCount++,
        fireImmediately: true,
      );

      // Initial state triggers listener
      expect(callCount, 1);

      // Update state
      container.read(isEditValueProvider('test-parent').notifier).update(true);
      expect(callCount, 2);

      // Update with same value doesn't trigger listener
      container.read(isEditValueProvider('test-parent').notifier).update(true);
      expect(callCount, 2);

      // Update with different value triggers listener
      container.read(isEditValueProvider('test-parent').notifier).update(false);
      expect(callCount, 3);
    });

    test('different parentIds have independent listeners', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      var parent1CallCount = 0;
      var parent2CallCount = 0;

      container.listen(
        isEditValueProvider('parent1'),
        (previous, next) => parent1CallCount++,
        fireImmediately: true,
      );

      container.listen(
        isEditValueProvider('parent2'),
        (previous, next) => parent2CallCount++,
        fireImmediately: true,
      );

      // Initial states trigger listeners
      expect(parent1CallCount, 1);
      expect(parent2CallCount, 1);

      // Update parent1
      container.read(isEditValueProvider('parent1').notifier).update(true);
      expect(parent1CallCount, 2);
      expect(parent2CallCount, 1);

      // Update parent2
      container.read(isEditValueProvider('parent2').notifier).update(true);
      expect(parent1CallCount, 2);
      expect(parent2CallCount, 2);
    });
  });
}
