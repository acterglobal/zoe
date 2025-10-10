import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/widgets/poll_settings_widget.dart';

import '../../../test-utils/test_utils.dart';
import '../notifiers/mock_poll_notifier.dart';

void main() {
  group('Poll Settings Widget Tests', () {
    late ProviderContainer container;
    late PollModel testPoll;
    late MockPollListNotifier mockNotifier;

    setUp(() {
      testPoll = polls.first;
      mockNotifier = MockPollListNotifier();

      container = ProviderContainer.test(
        overrides: [pollListProvider.overrideWith(() => mockNotifier)],
      );
    });

    Future<void> createWidgetUnderTest({
      required WidgetTester tester,
      required Widget widget,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: widget,
        container: container,
      );
    }

    group('addPollOptionWidget', () {
      testWidgets('renders add option widget correctly', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) =>
                addPollOptionWidget(context, ref, testPoll),
          ),
        );

        // Should find GestureDetector
        expect(find.byType(GestureDetector), findsOneWidget);

        // Should find Row
        expect(find.byType(Row), findsOneWidget);

        // Should find add circle icon
        expect(find.byIcon(Icons.add_circle), findsOneWidget);

        // Should find Text widget
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets(
        'applies correct styling to add option widget and handles tap',
        (tester) async {
          await createWidgetUnderTest(
            tester: tester,
            widget: Consumer(
              builder: (context, ref, child) =>
                  addPollOptionWidget(context, ref, testPoll),
            ),
          );

          final icon = tester.widget<Icon>(find.byIcon(Icons.add_circle));
          expect(icon.size, 24);
          expect(icon.color, isA<Color>());

          final text = tester.widget<Text>(find.byType(Text));
          expect(text.style, isA<TextStyle>());

          // Tap the widget to test interaction
          await tester.tap(find.byType(GestureDetector), warnIfMissed: false);
          await tester.pump();

          // Widget should still be present after tap
          expect(find.byType(GestureDetector), findsOneWidget);
        },
      );
    });

    group('startPollButtonWidget', () {
      testWidgets('renders start poll button correctly', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) =>
                startPollButtonWidget(context, ref, testPoll),
          ),
        );

        // Should find GestureDetector
        expect(find.byType(GestureDetector), findsOneWidget);

        // Should find Row
        expect(find.byType(Row), findsOneWidget);

        // Should find play circle outline icon
        expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);

        // Should find Text widget
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('applies correct styling to start poll button', (
        tester,
      ) async {
        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) =>
                startPollButtonWidget(context, ref, testPoll),
          ),
        );

        final icon = tester.widget<Icon>(
          find.byIcon(Icons.play_circle_outline),
        );
        expect(icon.size, 18);
        expect(icon.color, isA<Color>());

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style, isA<TextStyle>());
        expect(text.style?.color, isA<Color>());
      });

      testWidgets('handles tap gesture and calls notifier', (tester) async {
        mockNotifier.reset();

        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) =>
                startPollButtonWidget(context, ref, testPoll),
          ),
        );

        // Tap the widget
        await tester.tap(find.byType(GestureDetector), warnIfMissed: false);
        await tester.pump();

        // Widget should still be present after tap
        expect(find.byType(GestureDetector), findsOneWidget);

        // Verify notifier method was called
        expect(mockNotifier.methodCalls, contains('startPoll'));
        expect(
          mockNotifier.methodArguments.first['pollId'],
          equals(testPoll.id),
        );
      });
    });

    group('endPollButtonWidget', () {
      testWidgets('renders end poll button correctly', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) =>
                endPollButtonWidget(context, ref, testPoll),
          ),
        );

        // Should find GestureDetector
        expect(find.byType(GestureDetector), findsOneWidget);

        // Should find Row
        expect(find.byType(Row), findsOneWidget);

        // Should find stop circle icon
        expect(find.byIcon(Icons.stop_circle), findsOneWidget);

        // Should find Text widget
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('applies correct styling to end poll button', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) =>
                endPollButtonWidget(context, ref, testPoll),
          ),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.stop_circle));
        expect(icon.size, 18);
        expect(icon.color, isA<Color>());

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.style, isA<TextStyle>());
        expect(text.style?.color, isA<Color>());
        expect(text.style?.fontWeight, FontWeight.w600);
      });

      testWidgets('handles tap gesture and calls notifier', (tester) async {
        mockNotifier.reset();

        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) =>
                endPollButtonWidget(context, ref, testPoll),
          ),
        );

        // Tap the widget
        await tester.tap(find.byType(GestureDetector), warnIfMissed: false);
        await tester.pump();

        // Widget should still be present after tap
        expect(find.byType(GestureDetector), findsOneWidget);

        // Verify notifier method was called
        expect(mockNotifier.methodCalls, contains('endPoll'));
        expect(
          mockNotifier.methodArguments.first['pollId'],
          equals(testPoll.id),
        );
      });
    });

    group('choiceTypeSelectorWidget', () {
      testWidgets('renders choice type selector correctly', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) =>
                choiceTypeSelectorWidget(context, ref, testPoll),
          ),
        );

        // Should find Row
        expect(
          find.byType(Row),
          findsNWidgets(3),
        ); // Main row + 2 choice option rows

        // Should find two GestureDetector widgets (one for each option)
        expect(find.byType(GestureDetector), findsNWidgets(2));

        // Should find radio button icon for single choice
        expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);

        // Should find check box icon for multiple choice
        expect(find.byIcon(Icons.check_box), findsOneWidget);

        // Should find Text widgets for both options
        expect(find.byType(Text), findsNWidgets(2));
      });

      testWidgets('shows correct selection state for single choice poll', (
        tester,
      ) async {
        final singleChoicePoll = testPoll.copyWith(isMultipleChoice: false);

        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) =>
                choiceTypeSelectorWidget(context, ref, singleChoicePoll),
          ),
        );

        // Should find radio button icon
        expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);

        // Should find check box icon
        expect(find.byIcon(Icons.check_box), findsOneWidget);

        // Should find both text options
        expect(find.byType(Text), findsNWidgets(2));
      });

      testWidgets('handles tap gestures on both options and calls notifier', (
        tester,
      ) async {
        mockNotifier.reset();

        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) =>
                choiceTypeSelectorWidget(context, ref, testPoll),
          ),
        );

        // Tap on first GestureDetector
        await tester.tap(
          find.byType(GestureDetector).first,
          warnIfMissed: false,
        );
        await tester.pump();

        // Tap on second GestureDetector
        await tester.tap(
          find.byType(GestureDetector).last,
          warnIfMissed: false,
        );
        await tester.pump();

        // Widgets should still be present after taps
        expect(find.byType(Row), findsNWidgets(3));
        expect(find.byType(GestureDetector), findsNWidgets(2));

        // Verify notifier method was called twice
        expect(
          mockNotifier.methodCalls
              .where((call) => call == 'togglePollMultipleChoice')
              .length,
          equals(2),
        );
        expect(
          mockNotifier.methodArguments.every(
            (args) => args['pollId'] == testPoll.id,
          ),
          isTrue,
        );
      });
    });
    group('Widget Integration', () {
      testWidgets('all widgets render together correctly', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) => Column(
              children: [
                addPollOptionWidget(context, ref, testPoll),
                const SizedBox(height: 16),
                startPollButtonWidget(context, ref, testPoll),
                const SizedBox(height: 16),
                endPollButtonWidget(context, ref, testPoll),
                const SizedBox(height: 16),
                choiceTypeSelectorWidget(context, ref, testPoll),
              ],
            ),
          ),
        );

        // Should find all widget types
        expect(
          find.byType(GestureDetector),
          findsNWidgets(5),
        ); // 1 add option + 1 start + 1 end + 2 choice options
        expect(
          find.byType(Row),
          findsNWidgets(6),
        ); // 5 widget rows + 1 choice selector row
        expect(
          find.byType(Container),
          findsNWidgets(2),
        ); // Only choice options have containers

        // Should find all icons
        expect(find.byIcon(Icons.add_circle), findsOneWidget);
        expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
        expect(find.byIcon(Icons.stop_circle), findsOneWidget);
        expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
        expect(find.byIcon(Icons.check_box), findsOneWidget);

        // Should find all text labels
        expect(find.byType(Text), findsNWidgets(5));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles different poll states', (tester) async {
        final draftPoll = testPoll.copyWith(startDate: null);

        // Test with draft poll
        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) => Column(
              children: [
                addPollOptionWidget(context, ref, draftPoll),
                startPollButtonWidget(context, ref, draftPoll),
                endPollButtonWidget(context, ref, draftPoll),
                choiceTypeSelectorWidget(context, ref, draftPoll),
              ],
            ),
          ),
        );

        expect(find.byType(GestureDetector), findsNWidgets(5));
        expect(find.byType(Row), findsNWidgets(6));
      });

      testWidgets('handles empty poll options', (tester) async {
        final pollWithNoOptions = testPoll.copyWith(options: []);

        await createWidgetUnderTest(
          tester: tester,
          widget: Consumer(
            builder: (context, ref, child) => Column(
              children: [
                addPollOptionWidget(context, ref, pollWithNoOptions),
                choiceTypeSelectorWidget(context, ref, pollWithNoOptions),
              ],
            ),
          ),
        );

        expect(find.byType(GestureDetector), findsNWidgets(3));
        expect(find.byType(Row), findsNWidgets(4));
      });
    });
  });
}
