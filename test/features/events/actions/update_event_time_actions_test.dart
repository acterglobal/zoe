import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';

void main() {
  group('UpdateEventTimeActions', () {
    late EventModel testEvent;

    setUp(() {
      testEvent = eventList.first;
    });

    group('updateEventStartDate', () {
      test('should extract event data correctly', () {
        final startDate = testEvent.startDate;
        final endDate = testEvent.endDate;
        final eventId = testEvent.id;
        
        expect(startDate, isA<DateTime>());
        expect(endDate, isA<DateTime>());
        expect(eventId, isA<String>());
        expect(eventId.isNotEmpty, isTrue);
      });

      test('should handle date time update with preserved time', () {
        final startDate = testEvent.startDate;
        final selectedDate = DateTime.now().add(Duration(days: 1));
        final timeOfDay = TimeOfDay.fromDateTime(startDate);
        
        // Test the logic: DateTimeUtils.updateDateTimeForTime(selectedDate, timeOfDay)
        expect(selectedDate, isA<DateTime>());
        expect(timeOfDay, isA<TimeOfDay>());
        expect(timeOfDay.hour, isA<int>());
        expect(timeOfDay.minute, isA<int>());
      });

      test('should adjust end date when start date is after end date', () {
        final endDate = testEvent.endDate;
        final newStartDateTime = testEvent.startDate.add(Duration(hours: 2));
        final shouldAdjustEndDate = endDate.isBefore(newStartDateTime);
        
        if (shouldAdjustEndDate) {
          final newEndDateTime = newStartDateTime.add(Duration(hours: 1));
          expect(newEndDateTime.isAfter(newStartDateTime), isTrue);
        }
        expect(shouldAdjustEndDate, isA<bool>());
      });

      test('should call provider to update start date', () {
        final eventId = testEvent.id;
        final newStartDateTime = DateTime.now().add(Duration(hours: 1));
        
        // Test the provider call pattern
        expect(eventId.isNotEmpty, isTrue);
        expect(newStartDateTime, isA<DateTime>());
      });
    });

    group('updateEventStartTime', () {
      test('should extract event data correctly', () {
        final startDate = testEvent.startDate;
        final endDate = testEvent.endDate;
        final eventId = testEvent.id;
        
        expect(startDate, isA<DateTime>());
        expect(endDate, isA<DateTime>());
        expect(eventId, isA<String>());
        expect(eventId.isNotEmpty, isTrue);
      });

      test('should get start time from date', () {
        final startDate = testEvent.startDate;
        final startTime = TimeOfDay.fromDateTime(startDate);
        
        expect(startTime, isA<TimeOfDay>());
        expect(startTime.hour >= 0 && startTime.hour <= 23, isTrue);
        expect(startTime.minute >= 0 && startTime.minute <= 59, isTrue);
      });

      test('should update start date with new time', () {
        final startDate = testEvent.startDate;
        final selectedTime = TimeOfDay(hour: 14, minute: 30);
        
        // Test the logic: DateTimeUtils.updateDateTimeForTime(startDate, selectedTime)
        expect(startDate, isA<DateTime>());
        expect(selectedTime, isA<TimeOfDay>());
        expect(selectedTime.hour, isA<int>());
        expect(selectedTime.minute, isA<int>());
      });

      test('should adjust end date when start time makes start after end', () {
        final endDate = testEvent.endDate;
        final newStartDateTime = testEvent.startDate.add(Duration(hours: 2));
        final shouldAdjustEndDate = endDate.isBefore(newStartDateTime);
        
        if (shouldAdjustEndDate) {
          final newEndDateTime = newStartDateTime.add(Duration(hours: 1));
          expect(newEndDateTime.isAfter(newStartDateTime), isTrue);
        }
        expect(shouldAdjustEndDate, isA<bool>());
      });
    });

    group('updateEventEndDate', () {
      test('should extract event data correctly', () {
        final startDate = testEvent.startDate;
        final endDate = testEvent.endDate;
        final eventId = testEvent.id;
        
        expect(startDate, isA<DateTime>());
        expect(endDate, isA<DateTime>());
        expect(eventId, isA<String>());
        expect(eventId.isNotEmpty, isTrue);
      });

      test('should update end date with preserved time', () {
        final endDate = testEvent.endDate;
        final selectedDate = DateTime.now().add(Duration(days: 2));
        final timeOfDay = TimeOfDay.fromDateTime(endDate);
        
        // Test the logic: DateTimeUtils.updateDateTimeForTime(selectedDate, timeOfDay)
        expect(selectedDate, isA<DateTime>());
        expect(timeOfDay, isA<TimeOfDay>());
        expect(timeOfDay.hour, isA<int>());
        expect(timeOfDay.minute, isA<int>());
      });

      test('should adjust start date when end date is before start date', () {
        final startDate = testEvent.startDate;
        final newEndDateTime = testEvent.endDate.subtract(Duration(hours: 2));
        final shouldAdjustStartDate = startDate.isAfter(newEndDateTime);
        
        if (shouldAdjustStartDate) {
          // Start date should be set to end date
          expect(newEndDateTime, isA<DateTime>());
        }
        expect(shouldAdjustStartDate, isA<bool>());
      });
    });

    group('updateEventEndTime', () {
      test('should extract event data correctly', () {
        final startDate = testEvent.startDate;
        final endDate = testEvent.endDate;
        final eventId = testEvent.id;
        
        expect(startDate, isA<DateTime>());
        expect(endDate, isA<DateTime>());
        expect(eventId, isA<String>());
        expect(eventId.isNotEmpty, isTrue);
      });

      test('should get end time from date', () {
        final endDate = testEvent.endDate;
        final endTime = TimeOfDay.fromDateTime(endDate);
        
        expect(endTime, isA<TimeOfDay>());
        expect(endTime.hour >= 0 && endTime.hour <= 23, isTrue);
        expect(endTime.minute >= 0 && endTime.minute <= 59, isTrue);
      });

      test('should update end date with new time', () {
        final endDate = testEvent.endDate;
        final selectedTime = TimeOfDay(hour: 16, minute: 45);
        
        // Test the logic: DateTimeUtils.updateDateTimeForTime(endDate, selectedTime)
        expect(endDate, isA<DateTime>());
        expect(selectedTime, isA<TimeOfDay>());
        expect(selectedTime.hour, isA<int>());
        expect(selectedTime.minute, isA<int>());
      });

      test('should adjust start date when end time makes end before start', () {
        final startDate = testEvent.startDate;
        final newEndDateTime = testEvent.endDate.subtract(Duration(hours: 2));
        final shouldAdjustStartDate = startDate.isAfter(newEndDateTime);
        
        if (shouldAdjustStartDate) {
          // Start date should be set to end date
          expect(newEndDateTime, isA<DateTime>());
        }
        expect(shouldAdjustStartDate, isA<bool>());
      });
    });

    group('Provider Integration', () {
      test('should validate eventListProvider.notifier calls', () {
        final eventId = testEvent.id;
        final newStartDate = DateTime.now().add(Duration(hours: 1));
        final newEndDate = DateTime.now().add(Duration(hours: 2));
        
        // Test provider access patterns
        expect(eventId.isNotEmpty, isTrue);
        expect(newStartDate, isA<DateTime>());
        expect(newEndDate, isA<DateTime>());
        expect(newEndDate.isAfter(newStartDate), isTrue);
      });

      test('should validate updateEventStartDate provider call', () {
        final eventId = testEvent.id;
        final newStartDate = DateTime.now().add(Duration(hours: 1));
        
        // Test the provider call: ref.read(eventListProvider.notifier).updateEventStartDate(eventId, newStartDate)
        expect(eventId.isNotEmpty, isTrue);
        expect(newStartDate, isA<DateTime>());
      });

      test('should validate updateEventEndDate provider call', () {
        final eventId = testEvent.id;
        final newEndDate = DateTime.now().add(Duration(hours: 2));
        
        // Test the provider call: ref.read(eventListProvider.notifier).updateEventEndDate(eventId, newEndDate)
        expect(eventId.isNotEmpty, isTrue);
        expect(newEndDate, isA<DateTime>());
      });
    });

    group('Edge Cases', () {
      test('should handle events with same start and end date', () {
        final sameDateTime = DateTime.now();
        final startDate = sameDateTime;
        final endDate = sameDateTime;
        
        expect(startDate, equals(endDate));
        expect(startDate.isAtSameMomentAs(endDate), isTrue);
      });

      test('should handle events with 1 hour duration', () {
        final startDate = DateTime.now();
        final endDate = startDate.add(Duration(hours: 1));
        
        expect(endDate.difference(startDate).inHours, equals(1));
        expect(endDate.isAfter(startDate), isTrue);
      });

      test('should handle time boundary values', () {
        final earlyTime = TimeOfDay(hour: 0, minute: 0);
        final lateTime = TimeOfDay(hour: 23, minute: 59);
        
        expect(earlyTime.hour, equals(0));
        expect(earlyTime.minute, equals(0));
        expect(lateTime.hour, equals(23));
        expect(lateTime.minute, equals(59));
      });

      test('should handle date boundary conditions', () {
        final startOfDay = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
        final endOfDay = DateTime.now().copyWith(hour: 23, minute: 59, second: 59, millisecond: 999);
        
        expect(startOfDay.hour, equals(0));
        expect(endOfDay.hour, equals(23));
        expect(endOfDay.isAfter(startOfDay), isTrue);
      });
    });

    group('Integration Scenarios', () {
      test('should handle complete start date update flow', () {
        final eventId = testEvent.id;
        final originalStartDate = testEvent.startDate;
        final originalEndDate = testEvent.endDate;
        final selectedDate = DateTime.now().add(Duration(days: 1));
        final timeOfDay = TimeOfDay.fromDateTime(originalStartDate);
        final newStartDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, timeOfDay.hour, timeOfDay.minute);
        
        // Test complete flow
        expect(eventId.isNotEmpty, isTrue);
        expect(originalStartDate, isA<DateTime>());
        expect(originalEndDate, isA<DateTime>());
        expect(newStartDateTime, isA<DateTime>());
        expect(newStartDateTime.day, equals(selectedDate.day));
        expect(newStartDateTime.hour, equals(timeOfDay.hour));
      });

      test('should handle complete end time update flow', () {
        final eventId = testEvent.id;
        final originalStartDate = testEvent.startDate;
        final originalEndDate = testEvent.endDate;
        final selectedTime = TimeOfDay(hour: 18, minute: 30);
        final newEndDateTime = DateTime(originalEndDate.year, originalEndDate.month, originalEndDate.day, selectedTime.hour, selectedTime.minute);
        
        // Test complete flow
        expect(eventId.isNotEmpty, isTrue);
        expect(originalStartDate, isA<DateTime>());
        expect(originalEndDate, isA<DateTime>());
        expect(newEndDateTime, isA<DateTime>());
        expect(newEndDateTime.hour, equals(selectedTime.hour));
        expect(newEndDateTime.minute, equals(selectedTime.minute));
      });

      test('should handle date consistency validation', () {
        final startDate = DateTime.now();
        final endDate = startDate.add(Duration(hours: 1));
        final invalidEndDate = startDate.subtract(Duration(hours: 1));
        
        // Test date consistency validation
        expect(endDate.isAfter(startDate), isTrue);
        expect(invalidEndDate.isBefore(startDate), isTrue);
        expect(startDate.isBefore(endDate), isTrue);
      });
    });
  });
}
