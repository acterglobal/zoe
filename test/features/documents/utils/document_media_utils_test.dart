import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/documents/utils/document_media_utils.dart';

void main() {
  group('DocumentMediaUtils Tests', () {
    group('calculateBackwardSeek', () {
      test('calculates backward seek correctly', () {
        final currentPosition = const Duration(minutes: 5);
        final seekAmount = const Duration(minutes: 2);
        
        final result = DocumentMediaUtils.calculateBackwardSeek(
          currentPosition,
          seekAmount,
        );
        
        expect(result, equals(const Duration(minutes: 3)));
      });

      test('returns zero when seek amount exceeds current position', () {
        final currentPosition = const Duration(minutes: 2);
        final seekAmount = const Duration(minutes: 5);
        
        final result = DocumentMediaUtils.calculateBackwardSeek(
          currentPosition,
          seekAmount,
        );
        
        expect(result, equals(Duration.zero));
      });
    });

    group('calculateForwardSeek', () {
      test('calculates forward seek correctly', () {
        final currentPosition = const Duration(minutes: 2);
        final seekAmount = const Duration(minutes: 3);
        final totalDuration = const Duration(minutes: 10);
        
        final result = DocumentMediaUtils.calculateForwardSeek(
          currentPosition,
          seekAmount,
          totalDuration,
        );
        
        expect(result, equals(const Duration(minutes: 5)));
      });

      test('returns total duration when seek exceeds total duration', () {
        final currentPosition = const Duration(minutes: 8);
        final seekAmount = const Duration(minutes: 5);
        final totalDuration = const Duration(minutes: 10);
        
        final result = DocumentMediaUtils.calculateForwardSeek(
          currentPosition,
          seekAmount,
          totalDuration,
        );
        
        expect(result, equals(totalDuration));
      });
    });

    group('validateSeekPosition', () {
      test('returns position when within valid range', () {
        final position = const Duration(minutes: 5);
        final totalDuration = const Duration(minutes: 10);
        
        final result = DocumentMediaUtils.validateSeekPosition(
          position,
          totalDuration,
        );
        
        expect(result, equals(position));
      });

      test('returns zero for negative position', () {
        final position = const Duration(minutes: -1);
        final totalDuration = const Duration(minutes: 10);
        
        final result = DocumentMediaUtils.validateSeekPosition(
          position,
          totalDuration,
        );
        
        expect(result, equals(Duration.zero));
      });

      test('returns total duration for position exceeding total duration', () {
        final position = const Duration(minutes: 15);
        final totalDuration = const Duration(minutes: 10);
        
        final result = DocumentMediaUtils.validateSeekPosition(
          position,
          totalDuration,
        );
        
        expect(result, equals(totalDuration));
      });
    });

    group('calculateProgressPercentage', () {
      test('calculates progress percentage correctly', () {
        final position = const Duration(minutes: 3);
        final totalDuration = const Duration(minutes: 10);
        
        final result = DocumentMediaUtils.calculateProgressPercentage(
          position,
          totalDuration,
        );
        
        expect(result, equals(0.3));
      });

      test('returns zero for zero total duration', () {
        final position = const Duration(minutes: 5);
        final totalDuration = Duration.zero;
        
        final result = DocumentMediaUtils.calculateProgressPercentage(
          position,
          totalDuration,
        );
        
        expect(result, equals(0.0));
      });

      test('clamps to 1.0 when position exceeds total duration', () {
        final position = const Duration(minutes: 15);
        final totalDuration = const Duration(minutes: 10);
        
        final result = DocumentMediaUtils.calculateProgressPercentage(
          position,
          totalDuration,
        );
        
        expect(result, equals(1.0));
      });
    });

    group('formatDuration', () {
      test('formats duration with hours correctly', () {
        final duration = const Duration(hours: 1, minutes: 30, seconds: 45);
        
        final result = DocumentMediaUtils.formatDuration(duration);
        
        expect(result, equals('1:30:45'));
      });

      test('formats duration without hours correctly', () {
        final duration = const Duration(minutes: 5, seconds: 30);
        
        final result = DocumentMediaUtils.formatDuration(duration);
        
        expect(result, equals('05:30'));
      });

      test('formats zero duration', () {
        final duration = Duration.zero;
        
        final result = DocumentMediaUtils.formatDuration(duration);
        
        expect(result, equals('00:00'));
      });
    });

    group('needsReset', () {
      test('returns true when position is at zero', () {
        final position = Duration.zero;
        final duration = const Duration(minutes: 10);
        
        final result = DocumentMediaUtils.needsReset(position, duration);
        
        expect(result, isTrue);
      });

      test('returns false when position is in middle', () {
        final position = const Duration(minutes: 5);
        final duration = const Duration(minutes: 10);
        
        final result = DocumentMediaUtils.needsReset(position, duration);
        
        expect(result, isFalse);
      });

      test('returns true when position equals duration', () {
        final position = const Duration(minutes: 10);
        final duration = const Duration(minutes: 10);
        
        final result = DocumentMediaUtils.needsReset(position, duration);
        
        expect(result, isTrue);
      });
    });
  });
}
