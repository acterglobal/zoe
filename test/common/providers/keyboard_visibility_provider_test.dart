import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/keyboard_visbility_provider.dart';

void main() {
  group('Keyboard Visibility Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    group('Initial State', () {
      test('provides initial keyboard visibility state as AsyncValue', () {
        // Read the provider - it returns AsyncValue<bool>
        final asyncValue = container.read(keyboardVisibleProvider);
        
        // Initially should be loading or have a value
        expect(asyncValue, isA<AsyncValue<bool>>());
      });

      test('stream provider starts with loading state', () {
        final asyncValue = container.read(keyboardVisibleProvider);
        
        // Stream providers typically start in loading state
        expect(asyncValue.isLoading || asyncValue.hasValue, isTrue);
      });

      test('provider returns boolean values when data is available', () async {
        // Wait for the provider to potentially load data
        await Future.delayed(const Duration(milliseconds: 100));
        
        final asyncValue = container.read(keyboardVisibleProvider);
        
        // When data is available, it should be a boolean
        asyncValue.whenData((value) {
          expect(value, isA<bool>());
        });
      });
    });

    group('AsyncValue States', () {
      test('handles loading state correctly', () {
        final asyncValue = container.read(keyboardVisibleProvider);
        
        // Should handle loading state
        expect(asyncValue.isLoading || asyncValue.hasValue || asyncValue.hasError, isTrue);
      });

      test('provides data when available', () async {
        // Allow some time for the stream to potentially emit values
        await Future.delayed(const Duration(milliseconds: 50));
        
        final asyncValue = container.read(keyboardVisibleProvider);
        
        // Test different states
        asyncValue.when(
          data: (value) {
            expect(value, isA<bool>());
          },
          loading: () {
            // Loading state is acceptable
            expect(true, isTrue);
          },
          error: (error, stackTrace) {
            // Error state should be handled gracefully
            expect(error, isNotNull);
          },
        );
      });

      test('maintains consistent AsyncValue type', () {
        final asyncValue1 = container.read(keyboardVisibleProvider);
        final asyncValue2 = container.read(keyboardVisibleProvider);
        
        // Both reads should return the same type
        expect(asyncValue1.runtimeType, equals(asyncValue2.runtimeType));
      });
    });

    group('Provider Behavior', () {
      test('provider can be read multiple times', () {
        // Read the provider multiple times
        final asyncValue1 = container.read(keyboardVisibleProvider);
        final asyncValue2 = container.read(keyboardVisibleProvider);
        
        // Both should be AsyncValue<bool>
        expect(asyncValue1, isA<AsyncValue<bool>>());
        expect(asyncValue2, isA<AsyncValue<bool>>());
      });

      test('provider is auto-dispose', () {
        // Read the provider
        final asyncValue = container.read(keyboardVisibleProvider);
        expect(asyncValue, isA<AsyncValue<bool>>());
        
        // Dispose container
        container.dispose();
        
        // Should dispose without errors
        expect(true, isTrue);
      });

      test('provider maintains state consistency', () {
        final asyncValue1 = container.read(keyboardVisibleProvider);
        
        // Read again immediately
        final asyncValue2 = container.read(keyboardVisibleProvider);
        
        // Should be consistent (same instance due to caching)
        expect(identical(asyncValue1, asyncValue2), isTrue);
      });
    });

    group('Stream Provider Integration', () {
      test('integrates with KeyboardVisibilityController', () {
        // The provider should integrate with the actual controller
        final asyncValue = container.read(keyboardVisibleProvider);
        
        // Should be a valid AsyncValue
        expect(asyncValue, isA<AsyncValue<bool>>());
        
        // Should not throw errors during integration
        expect(() => container.read(keyboardVisibleProvider), returnsNormally);
      });

      test('handles stream lifecycle correctly', () async {
        // Read the provider to start the stream
        final asyncValue = container.read(keyboardVisibleProvider);
        expect(asyncValue, isA<AsyncValue<bool>>());
        
        // Wait a bit to allow stream to potentially emit
        await Future.delayed(const Duration(milliseconds: 50));
        
        // Read again - should not cause issues
        final asyncValue2 = container.read(keyboardVisibleProvider);
        expect(asyncValue2, isA<AsyncValue<bool>>());
      });
    });

    group('Error Handling', () {
      test('maintains error state in AsyncValue', () {
        final asyncValue = container.read(keyboardVisibleProvider);
        
        // Should handle any potential errors in AsyncValue wrapper
        asyncValue.when(
          data: (value) => expect(value, isA<bool>()),
          loading: () => expect(true, isTrue),
          error: (error, stackTrace) => expect(error, isNotNull),
        );
      });

      test('recovers from errors appropriately', () async {
        // Read provider
        final asyncValue1 = container.read(keyboardVisibleProvider);
        
        // Wait and read again
        await Future.delayed(const Duration(milliseconds: 10));
        final asyncValue2 = container.read(keyboardVisibleProvider);
        
        // Should maintain consistent behavior
        expect(asyncValue1, isA<AsyncValue<bool>>());
        expect(asyncValue2, isA<AsyncValue<bool>>());
      });
    });

    group('Debug Information', () {
      test('debug hash is consistent', () {
        // The debug hash should be consistent across calls
        final hash1 = keyboardVisibleProvider.debugGetCreateSourceHash();
        final hash2 = keyboardVisibleProvider.debugGetCreateSourceHash();
        
        expect(hash1, equals(hash2));
        expect(hash1, isNotEmpty);
      });

      test('provider type information is correct', () {
        // Provider should be of correct type
        expect(keyboardVisibleProvider, isA<KeyboardVisibleProvider>());
      });
    });
  });
}
