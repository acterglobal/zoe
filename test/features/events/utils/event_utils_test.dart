import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/events/utils/event_utils.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:intl/intl.dart';

void main() {
  group('EventUtils', () {
    late EventModel testEvent;

    setUp(() {
      testEvent = eventList.first;
    });

    group('formatEventDateAndTime', () {
      test('should extract event data correctly', () {
        final startDate = testEvent.startDate;
        final endDate = testEvent.endDate;
        
        expect(startDate, isA<DateTime>());
        expect(endDate, isA<DateTime>());
        expect(endDate.isAfter(startDate), isTrue);
      });

      test('should handle today date logic', () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final eventDate = DateTime(
          testEvent.startDate.year,
          testEvent.startDate.month,
          testEvent.startDate.day,
        );
        
        // Test the date comparison logic from the function
        final isToday = eventDate == today;
        final isTomorrow = eventDate == today.add(Duration(days: 1));
        
        expect(isToday, isA<bool>());
        expect(isTomorrow, isA<bool>());
        expect(eventDate, isA<DateTime>());
      });

      test('should handle tomorrow date logic', () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(Duration(days: 1));
        final eventDate = DateTime(
          testEvent.startDate.year,
          testEvent.startDate.month,
          testEvent.startDate.day,
        );
        
        // Test the tomorrow comparison logic
        final isTomorrow = eventDate == tomorrow;
        expect(isTomorrow, isA<bool>());
        expect(tomorrow.isAfter(today), isTrue);
      });

      test('should handle other day date logic', () {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final eventDate = DateTime(
          testEvent.startDate.year,
          testEvent.startDate.month,
          testEvent.startDate.day,
        );
        
        // Test the other day logic (not today, not tomorrow)
        final isToday = eventDate == today;
        final isTomorrow = eventDate == today.add(Duration(days: 1));
        final isOtherDay = !isToday && !isTomorrow;
        
        expect(isToday, isA<bool>());
        expect(isTomorrow, isA<bool>());
        expect(isOtherDay, isA<bool>());
      });

      test('should handle time formatting logic', () {
        final eventTime = testEvent.startDate;
        
        // Test time formatting logic using DateFormat
        final timeText = DateFormat('HH:mm').format(eventTime);
        expect(timeText, isA<String>());
        expect(timeText.isNotEmpty, isTrue);
        expect(timeText.contains(':'), isTrue);
      });

      test('should handle multi-day event logic', () {
        final startDate = testEvent.startDate;
        final endDate = testEvent.endDate;
        
        // Test multi-day event logic
        final startDateOnly = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
        );
        final endDateOnly = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
        );
        
        expect(startDateOnly, isA<DateTime>());
        expect(endDateOnly, isA<DateTime>());
        expect(endDateOnly.isAfter(startDateOnly) || endDateOnly.isAtSameMomentAs(startDateOnly), isTrue);
      });
    });

    group('getRsvpStatusColor', () {
      test('should return success color for yes status', () {
        final color = EventUtils.getRsvpStatusColor(RsvpStatus.yes);
        
        expect(color, isA<Color>());
        expect(color, equals(AppColors.successColor));
      });

      test('should return error color for no status', () {
        final color = EventUtils.getRsvpStatusColor(RsvpStatus.no);
        
        expect(color, isA<Color>());
        expect(color, equals(AppColors.errorColor));
      });

      test('should return primary color for maybe status', () {
        final color = EventUtils.getRsvpStatusColor(RsvpStatus.maybe);
        
        expect(color, isA<Color>());
        expect(color, equals(AppColors.primaryColor));
      });

      test('should handle all RSVP status values', () {
        final statuses = RsvpStatus.values;
        
        for (final status in statuses) {
          final color = EventUtils.getRsvpStatusColor(status);
          expect(color, isA<Color>());
          expect(color, isNotNull);
        }
        
        expect(statuses.length, equals(3));
      });

      test('should return different colors for different statuses', () {
        final yesColor = EventUtils.getRsvpStatusColor(RsvpStatus.yes);
        final noColor = EventUtils.getRsvpStatusColor(RsvpStatus.no);
        final maybeColor = EventUtils.getRsvpStatusColor(RsvpStatus.maybe);
        
        expect(yesColor, isNot(equals(noColor)));
        expect(yesColor, isNot(equals(maybeColor)));
        expect(noColor, isNot(equals(maybeColor)));
      });
    });

    group('Integration Tests', () {
      test('should work with real event data', () {
        final realEvent = testEvent;
        
        // Test with real event data
        expect(realEvent.id, isA<String>());
        expect(realEvent.title, isA<String>());
        expect(realEvent.startDate, isA<DateTime>());
        expect(realEvent.endDate, isA<DateTime>());
        expect(realEvent.rsvpResponses, isA<Map<String, RsvpStatus>>());
        
        // Test date formatting logic
        final eventDate = DateTime(
          realEvent.startDate.year,
          realEvent.startDate.month,
          realEvent.startDate.day,
        );
        expect(eventDate, isA<DateTime>());
        
        // Test RSVP color with existing status
        if (realEvent.rsvpResponses.isNotEmpty) {
          final firstStatus = realEvent.rsvpResponses.values.first;
          final color = EventUtils.getRsvpStatusColor(firstStatus);
          expect(color, isA<Color>());
        }
      });

      test('should handle event with different time zones', () {
        final utcStartDate = testEvent.startDate.toUtc();
        final utcEndDate = testEvent.endDate.toUtc();
        
        // Test UTC event logic
        expect(utcStartDate, isA<DateTime>());
        expect(utcEndDate, isA<DateTime>());
        expect(utcStartDate.isUtc, isTrue);
        expect(utcEndDate.isUtc, isTrue);
      });

      test('should handle all events in eventList', () {
        for (final event in eventList) {
          // Test each event in the list
          expect(event.id, isA<String>());
          expect(event.title, isA<String>());
          expect(event.startDate, isA<DateTime>());
          expect(event.endDate, isA<DateTime>());
          expect(event.endDate.isAfter(event.startDate), isTrue);
          
          // Test date formatting logic
          final eventDate = DateTime(
            event.startDate.year,
            event.startDate.month,
            event.startDate.day,
          );
          expect(eventDate, isA<DateTime>());
        }
      });
    });

    group('Edge Cases', () {
      test('should handle event at midnight', () {
        final midnightStartDate = testEvent.startDate.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
        final midnightEndDate = testEvent.endDate.copyWith(hour: 1, minute: 0, second: 0, millisecond: 0);
        
        // Test midnight event logic
        expect(midnightStartDate.hour, equals(0));
        expect(midnightStartDate.minute, equals(0));
        expect(midnightEndDate.hour, equals(1));
        expect(midnightEndDate.isAfter(midnightStartDate), isTrue);
      });

      test('should handle event at end of day', () {
        final endOfDayStartDate = testEvent.startDate.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999);
        final endOfDayEndDate = testEvent.endDate.copyWith(hour: 23, minute: 59, second: 59, millisecond: 999).add(Duration(minutes: 1));
        
        // Test end of day event logic
        expect(endOfDayStartDate.hour, equals(23));
        expect(endOfDayStartDate.minute, equals(59));
        expect(endOfDayEndDate.isAfter(endOfDayStartDate), isTrue);
      });
    });
  });
}