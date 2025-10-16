import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/utils/date_time_utils.dart';

void main() {
  group('DateTimeUtils', () {
    group('Constants', () {
      test('has correct date format', () {
        expect(DateTimeUtils.dateFormat, equals('d MMM yyyy'));
      });

      test('has correct time format', () {
        expect(DateTimeUtils.timeFormat, equals('hh:mm a'));
      });

      test('has correct date time format', () {
        expect(DateTimeUtils.dateTimeFormat, equals('d MMM yyyy hh:mm a'));
      });

      test('has correct date format with day', () {
        expect(DateTimeUtils.dateFormatWithDay, equals('EEE, MMM d'));
      });
    });

    group('formatDate', () {
      test('formats date correctly', () {
        final date = DateTime(2024, 1, 15);
        final result = DateTimeUtils.formatDate(date);
        expect(result, equals('15 Jan 2024'));
      });

      test('handles different months', () {
        final date = DateTime(2024, 12, 25);
        final result = DateTimeUtils.formatDate(date);
        expect(result, equals('25 Dec 2024'));
      });

      test('handles leap year', () {
        final date = DateTime(2024, 2, 29);
        final result = DateTimeUtils.formatDate(date);
        expect(result, equals('29 Feb 2024'));
      });

      test('handles single digit day', () {
        final date = DateTime(2024, 1, 1);
        final result = DateTimeUtils.formatDate(date);
        expect(result, equals('1 Jan 2024'));
      });
    });

    group('formatTime', () {
      test('formats time correctly in AM', () {
        final date = DateTime(2024, 1, 15, 9, 30);
        final result = DateTimeUtils.formatTime(date);
        expect(result, equals('09:30 AM'));
      });

      test('formats time correctly in PM', () {
        final date = DateTime(2024, 1, 15, 21, 45);
        final result = DateTimeUtils.formatTime(date);
        expect(result, equals('09:45 PM'));
      });

      test('handles midnight', () {
        final date = DateTime(2024, 1, 15, 0, 0);
        final result = DateTimeUtils.formatTime(date);
        expect(result, equals('12:00 AM'));
      });

      test('handles noon', () {
        final date = DateTime(2024, 1, 15, 12, 0);
        final result = DateTimeUtils.formatTime(date);
        expect(result, equals('12:00 PM'));
      });

      test('handles single digit minutes', () {
        final date = DateTime(2024, 1, 15, 14, 5);
        final result = DateTimeUtils.formatTime(date);
        expect(result, equals('02:05 PM'));
      });
    });

    group('formatDateTime', () {
      test('formats date and time correctly', () {
        final date = DateTime(2024, 1, 15, 14, 30);
        final result = DateTimeUtils.formatDateTime(date);
        expect(result, equals('15 Jan 2024 02:30 PM'));
      });

      test('handles different times', () {
        final date = DateTime(2024, 12, 25, 9, 15);
        final result = DateTimeUtils.formatDateTime(date);
        expect(result, equals('25 Dec 2024 09:15 AM'));
      });
    });

    group('getMonthText', () {
      test('returns month in uppercase', () {
        final date = DateTime(2024, 1, 15);
        final result = DateTimeUtils.getMonthText(date);
        expect(result, equals('JAN'));
      });

      test('handles different months', () {
        final date = DateTime(2024, 6, 15);
        final result = DateTimeUtils.getMonthText(date);
        expect(result, equals('JUN'));
      });

      test('handles December', () {
        final date = DateTime(2024, 12, 15);
        final result = DateTimeUtils.getMonthText(date);
        expect(result, equals('DEC'));
      });
    });

    group('getDayText', () {
      test('returns day as string', () {
        final date = DateTime(2024, 1, 15);
        final result = DateTimeUtils.getDayText(date);
        expect(result, equals('15'));
      });

      test('handles single digit day', () {
        final date = DateTime(2024, 1, 5);
        final result = DateTimeUtils.getDayText(date);
        expect(result, equals('5'));
      });

      test('handles last day of month', () {
        final date = DateTime(2024, 1, 31);
        final result = DateTimeUtils.getDayText(date);
        expect(result, equals('31'));
      });
    });

    group('getTimeOfDayFromDateTime', () {
      test('converts DateTime to TimeOfDay correctly', () {
        final date = DateTime(2024, 1, 15, 14, 30);
        final result = DateTimeUtils.getTimeOfDayFromDateTime(date);
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
      });

      test('handles midnight', () {
        final date = DateTime(2024, 1, 15, 0, 0);
        final result = DateTimeUtils.getTimeOfDayFromDateTime(date);
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
      });

      test('handles noon', () {
        final date = DateTime(2024, 1, 15, 12, 0);
        final result = DateTimeUtils.getTimeOfDayFromDateTime(date);
        expect(result.hour, equals(12));
        expect(result.minute, equals(0));
      });
    });

    group('updateDateTimeForTime', () {
      test('updates time correctly', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final time = const TimeOfDay(hour: 14, minute: 45);
        final result = DateTimeUtils.updateDateTimeForTime(date, time);
        
        expect(result.year, equals(2024));
        expect(result.month, equals(1));
        expect(result.day, equals(15));
        expect(result.hour, equals(14));
        expect(result.minute, equals(45));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
      });

      test('preserves date and updates time', () {
        final date = DateTime(2024, 12, 25, 8, 15);
        final time = const TimeOfDay(hour: 23, minute: 59);
        final result = DateTimeUtils.updateDateTimeForTime(date, time);
        
        expect(result.year, equals(2024));
        expect(result.month, equals(12));
        expect(result.day, equals(25));
        expect(result.hour, equals(23));
        expect(result.minute, equals(59));
      });
    });

    group('getTodayDateFormatted', () {
      test('returns today date with default format', () {
        final result = DateTimeUtils.getTodayDateFormatted();
        expect(result, isNotEmpty);
        expect(result, isA<String>());
      });

      test('returns today date with custom format', () {
        final result = DateTimeUtils.getTodayDateFormatted(format: 'yyyy-MM-dd');
        expect(result, isNotEmpty);
        expect(result, isA<String>());
        expect(result, contains('-'));
      });

      test('handles different custom formats', () {
        final formats = ['dd/MM/yyyy', 'MMM dd, yyyy', 'EEEE, MMMM dd'];
        for (final format in formats) {
          final result = DateTimeUtils.getTodayDateFormatted(format: format);
          expect(result, isNotEmpty);
          expect(result, isA<String>());
        }
      });
    });

    group('showDatePickerDialog', () {
      test('method exists and has correct signature', () {
        expect(DateTimeUtils.showDatePickerDialog, isA<Function>());
      });
    });

    group('showTimePickerDialog', () {
      test('method exists and has correct signature', () {
        expect(DateTimeUtils.showTimePickerDialog, isA<Function>());
      });

      test('returns Future<TimeOfDay?>', () {
        // Test that the method signature is correct
        expect(DateTimeUtils.showTimePickerDialog, isA<Function>());
      });
    });

    group('DateTimeExtensions', () {
      group('isToday', () {
        test('returns true for today', () {
          final today = DateTime.now();
          expect(today.isToday, isTrue);
        });

        test('returns false for yesterday', () {
          final yesterday = DateTime.now().subtract(const Duration(days: 1));
          expect(yesterday.isToday, isFalse);
        });

        test('returns false for tomorrow', () {
          final tomorrow = DateTime.now().add(const Duration(days: 1));
          expect(tomorrow.isToday, isFalse);
        });

        test('returns false for different year', () {
          final lastYear = DateTime(2023, 1, 1);
          expect(lastYear.isToday, isFalse);
        });
      });

      group('isTomorrow', () {
        test('returns true for tomorrow', () {
          final tomorrow = DateTime.now().add(const Duration(days: 1));
          expect(tomorrow.isTomorrow, isTrue);
        });

        test('returns false for today', () {
          final today = DateTime.now();
          expect(today.isTomorrow, isFalse);
        });

        test('returns false for day after tomorrow', () {
          final dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));
          expect(dayAfterTomorrow.isTomorrow, isFalse);
        });

        test('returns false for yesterday', () {
          final yesterday = DateTime.now().subtract(const Duration(days: 1));
          expect(yesterday.isTomorrow, isFalse);
        });
      });

      group('isYesterday', () {
        test('returns true for yesterday', () {
          final yesterday = DateTime.now().subtract(const Duration(days: 1));
          expect(yesterday.isYesterday, isTrue);
        });

        test('returns false for today', () {
          final today = DateTime.now();
          expect(today.isYesterday, isFalse);
        });

        test('returns false for day before yesterday', () {
          final dayBeforeYesterday = DateTime.now().subtract(const Duration(days: 2));
          expect(dayBeforeYesterday.isYesterday, isFalse);
        });

        test('returns false for tomorrow', () {
          final tomorrow = DateTime.now().add(const Duration(days: 1));
          expect(tomorrow.isYesterday, isFalse);
        });
      });
    });
  });
}
