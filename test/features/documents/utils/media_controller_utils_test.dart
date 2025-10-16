import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/documents/utils/media_controller_utils.dart';

void main() {
  group('MediaControllerUtils Tests', () {
    group('executeOperation', () {
      test('executes operation successfully when not processing', () async {
        const expectedResult = 'test result';

        final result = await MediaControllerUtils.executeOperation(() async {
          return expectedResult;
        });

        expect(result, equals(expectedResult));
      });

      test('returns null when already processing', () async {
        // Start a long-running operation
        final longOperation = MediaControllerUtils.executeOperation(() async {
          await Future.delayed(const Duration(milliseconds: 100));
          return 'long operation result';
        });

        // Try to execute another operation while the first is running
        final secondResult = await MediaControllerUtils.executeOperation(
          () async {
            return 'second operation result';
          },
        );

        // The second operation should return null because the first is still processing
        expect(secondResult, isNull);

        // Wait for the first operation to complete
        await longOperation;
      });

      test('handles operation that throws exception', () async {
        String? result;
        Object? caughtException;

        try {
          result = await MediaControllerUtils.executeOperation(() async {
            throw Exception('Test exception');
          });
        } catch (e) {
          caughtException = e;
        }

        // The operation should throw the exception
        expect(caughtException, isA<Exception>());
        expect(
          (caughtException as Exception).toString(),
          contains('Test exception'),
        );
        expect(result, isNull);
      });

      test('allows new operation after previous one completes', () async {
        const firstResult = 'first result';
        const secondResult = 'second result';

        // Execute first operation
        final first = await MediaControllerUtils.executeOperation(() async {
          await Future.delayed(const Duration(milliseconds: 50));
          return firstResult;
        });

        expect(first, equals(firstResult));

        // Execute second operation after first completes
        final second = await MediaControllerUtils.executeOperation(() async {
          return secondResult;
        });

        expect(second, equals(secondResult));
      });

      test('handles operation that returns null', () async {
        final result = await MediaControllerUtils.executeOperation(() async {
          return null;
        });

        expect(result, isNull);
      });

      test('handles operation that returns different types', () async {
        // Test with String
        final stringResult = await MediaControllerUtils.executeOperation(
          () async {
            return 'string result';
          },
        );
        expect(stringResult, equals('string result'));

        // Test with int
        final intResult = await MediaControllerUtils.executeOperation(() async {
          return 42;
        });
        expect(intResult, equals(42));

        // Test with bool
        final boolResult = await MediaControllerUtils.executeOperation(
          () async {
            return true;
          },
        );
        expect(boolResult, equals(true));

        // Test with List
        final listResult = await MediaControllerUtils.executeOperation(
          () async {
            return [1, 2, 3];
          },
        );
        expect(listResult, equals([1, 2, 3]));
      });
    });
  });
}
