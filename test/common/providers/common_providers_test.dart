import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';

void main() {
  group('Common Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    group('SearchValue Provider', () {
      test('initial state is empty string', () {
        final searchValue = container.read(searchValueProvider);
        expect(searchValue, equals(''));
      });

      test('update method changes state correctly', () {
        const testValue = 'test search';

        container.read(searchValueProvider.notifier).update(testValue);

        final updatedValue = container.read(searchValueProvider);
        expect(updatedValue, equals(testValue));
      });

      test('update method with empty string', () {
        container.read(searchValueProvider.notifier).update('');

        final value = container.read(searchValueProvider);
        expect(value, equals(''));
      });

      test('multiple updates work correctly', () {
        const values = ['first', 'second', 'third', 'final'];

        for (final value in values) {
          container.read(searchValueProvider.notifier).update(value);
          final currentValue = container.read(searchValueProvider);
          expect(currentValue, equals(value));
        }

        // Final value should be the last one
        final finalValue = container.read(searchValueProvider);
        expect(finalValue, equals('final'));
      });
    });

    group('editContentIdProvider', () {
      test('initial state is null', () {
        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, isNull);
      });

      test('can be set to a string value', () {
        const testId = 'test-content-id';

        container.read(editContentIdProvider.notifier).state = testId;

        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(testId));
      });

      test('can be set to null', () {
        // First set a value
        container.read(editContentIdProvider.notifier).state = 'some-id';
        expect(container.read(editContentIdProvider), equals('some-id'));

        // Then set to null
        container.read(editContentIdProvider.notifier).state = null;

        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, isNull);
      });

      test('can be set to empty string', () {
        container.read(editContentIdProvider.notifier).state = '';

        final editContentId = container.read(editContentIdProvider);
        expect(editContentId, equals(''));
      });

      test('multiple state changes work correctly', () {
        const values = ['id1', null, 'id2', '', 'id3', null];

        for (final value in values) {
          container.read(editContentIdProvider.notifier).state = value;
          final currentValue = container.read(editContentIdProvider);
          expect(currentValue, equals(value));
        }
      });
    });
  });
}
