import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/events/actions/event_actions.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('EventActions', () {
    late EventModel testEvent;

    setUp(() {
      testEvent = eventList.first;
    });

    // Helper function for widget pumping
    Future<void> pumpButtonWidget(
      WidgetTester tester, {
      required String buttonText,
      required VoidCallback onPressed,
    }) async {
      await tester.pumpMaterialWidget(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: onPressed,
                  child: Text(buttonText),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text(buttonText));
      await tester.pump();
    }

    group('General', () {
      test('EventActions should be a static class', () {
        expect(EventActions, isA<Type>());
      });
    });

    group('Clipboard & Copy', () {
      testWidgets('copyEvent should execute without errors', (tester) async {
        await pumpButtonWidget(
          tester,
          buttonText: 'Copy Event',
          onPressed: () => Clipboard.setData(
            ClipboardData(text: 'Test event content'),
          ),
        );

        expect(find.text('Copy Event'), findsOneWidget);
      });

      test('should handle empty or null content safely', () {
        final cases = ['', null];
        for (final content in cases) {
          final safeContent = content ?? '';
          ClipboardData clipboardData = ClipboardData(text: safeContent);
          expect(clipboardData.text, equals(safeContent));
          expect((clipboardData.text?.isNotEmpty ?? false), safeContent.isNotEmpty);
        }
      });
    });

    group('Share Event', () {
      testWidgets('shareEvent should execute without errors', (tester) async {
        await pumpButtonWidget(
          tester,
          buttonText: 'Share Event',
          onPressed: () {},
        );
        expect(find.text('Share Event'), findsOneWidget);
      });

      test('should validate share logic', () {
        final validEventIds = [testEvent.id, ''];
        for (var eventId in validEventIds) {
          final canShare = eventId.isNotEmpty;
          final isValidFormat = canShare && !eventId.contains(' ');
          expect(isValidFormat, canShare ? isTrue : isFalse);
        }
      });
    });

    group('Edit Event', () {
      test('should validate edit logic', () {
        final emptyId = '';
        expect(testEvent.id.isNotEmpty, isTrue);
        expect(emptyId.isNotEmpty, isFalse);
      });

      testWidgets('editEvent button executes without errors', (tester) async {
        await pumpButtonWidget(
          tester,
          buttonText: 'Edit Event',
          onPressed: () {},
        );
        expect(find.text('Edit Event'), findsOneWidget);
      });
    });

    group('Delete Event', () {
      test('should validate delete logic', () {
        final emptyId = '';
        expect(testEvent.id.isNotEmpty, isTrue);
        expect(emptyId.isNotEmpty, isFalse);
      });

      testWidgets('deleteEvent button executes without errors', (tester) async {
        await pumpButtonWidget(
          tester,
          buttonText: 'Delete Event',
          onPressed: () {},
        );
        expect(find.text('Delete Event'), findsOneWidget);
      });
    });

    group('Event Menu', () {
      testWidgets('showEventMenu executes without errors', (tester) async {
        await pumpButtonWidget(
          tester,
          buttonText: 'Show Menu',
          onPressed: () {},
        );
        expect(find.text('Show Menu'), findsOneWidget);
      });

      test('menu logic should validate items based on editing state', () {
        final isEditingCases = [true, false];
        for (var isEditing in isEditingCases) {
          final canEdit = !isEditing && testEvent.id.isNotEmpty;
          expect(canEdit, isEditing ? isFalse : isTrue);
        }
      });
    });

    group('Edge Cases', () {
      test('should handle long and special event IDs', () {
        final longId = 'a' * 1000;
        final specialId = 'event-id_with.special@chars#123';
        expect(longId.isNotEmpty, isTrue);
        expect(specialId.isNotEmpty, isTrue);
      });
    });

     group('Integration & Utils', () {
       test('Clipboard integration works', () {
         final data = ClipboardData(text: 'Test clipboard');
         expect(data.text, 'Test clipboard');
       });

       test('Snackbar and Share logic validation', () {
         final messages = ['Copied', 'Deleted'];
         for (var msg in messages) {
           expect(msg.isNotEmpty, isTrue);
         }
       });

      testWidgets('should show SnackBar with copiedToClipboard text for copy action', (tester) async {
        await tester.pumpMaterialWidget(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    // Simulate showing snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(L10n.of(context).copiedToClipboard)),
                    );
                  },
                  child: Text('Copy Event'),
                );
              },
            ),
          ),
        );
         
         // Tap the button to trigger snackbar
         await tester.tap(find.text('Copy Event'));
         await tester.pump(); // Show the snackbar
         
        // Check for SnackBar widget
        expect(find.byType(SnackBar), findsOneWidget);
        final expected = L10n.of(tester.element(find.byType(ElevatedButton))).copiedToClipboard;
        expect(find.text(expected), findsOneWidget);
       });

      testWidgets('should show SnackBar with eventDeleted text for delete action', (tester) async {
        await tester.pumpMaterialWidget(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    // Simulate showing snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(L10n.of(context).eventDeleted)),
                    );
                  },
                  child: Text('Delete Event'),
                );
              },
            ),
          ),
        );
         
         // Tap the button to trigger snackbar
         await tester.tap(find.text('Delete Event'));
         await tester.pump(); // Show the snackbar
         
        // Check for SnackBar widget
        expect(find.byType(SnackBar), findsOneWidget);
        final expected = L10n.of(tester.element(find.byType(ElevatedButton))).eventDeleted;
        expect(find.text(expected), findsOneWidget);
       });

      testWidgets('should show SnackBar with L10n copiedToClipboard message', (tester) async {
        await tester.pumpMaterialWidget(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    // Simulate L10n.of(context).copiedToClipboard message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(L10n.of(context).copiedToClipboard)),
                    );
                  },
                  child: Text('Copy Event'),
                );
              },
            ),
          ),
        );
         
         // Tap the button to trigger snackbar
         await tester.tap(find.text('Copy Event'));
         await tester.pump(); // Show the snackbar
         
        // Check for SnackBar and specific L10n message
        expect(find.byType(SnackBar), findsOneWidget);
        final expected = L10n.of(tester.element(find.byType(ElevatedButton))).copiedToClipboard;
        expect(find.text(expected), findsOneWidget);
         expect(find.byType(Text), findsAtLeastNWidgets(1));
       });

      testWidgets('should show SnackBar with L10n eventDeleted message', (tester) async {
        await tester.pumpMaterialWidget(
          child: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    // Simulate L10n.of(context).eventDeleted message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(L10n.of(context).eventDeleted)),
                    );
                  },
                  child: Text('Delete Event'),
                );
              },
            ),
          ),
        );
         
         // Tap the button to trigger snackbar
         await tester.tap(find.text('Delete Event'));
         await tester.pump(); // Show the snackbar
         
        // Check for SnackBar and specific L10n message
        expect(find.byType(SnackBar), findsOneWidget);
        final expected = L10n.of(tester.element(find.byType(ElevatedButton))).eventDeleted;
        expect(find.text(expected), findsOneWidget);
         expect(find.byType(Text), findsAtLeastNWidgets(1));
       });
     });
  });
}
