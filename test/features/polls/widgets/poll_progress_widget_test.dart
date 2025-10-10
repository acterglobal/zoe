import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/widgets/poll_progress_widget.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('PollProgressWidget Tests', () {
    late PollModel testPoll;
    late PollOption optionWithVotes;
    late PollOption optionWithoutVotes;

    setUp(() {
      testPoll = polls.first; // 'poll-1' - has mixed vote counts
      optionWithVotes = testPoll.options[1]; // Second option (has votes)
      optionWithoutVotes = testPoll.options.first; // First option (no votes)
    });

    Future<void> createWidgetUnderTest({
      required WidgetTester tester,
      required PollOption option,
      required PollModel poll,
      required Color color,
      double? height,
      double? maxWidth,
      bool? showPercentage,
      TextStyle? percentageStyle,
      EdgeInsets? margin,
      ThemeData? theme,
    }) async {
      await tester.pumpMaterialWidget(
        child: PollProgressWidget(
          option: option,
          poll: poll,
          color: color,
          height: height ?? 8.0,
          maxWidth: maxWidth ?? 0.8,
          showPercentage: showPercentage ?? true,
          percentageStyle: percentageStyle,
          margin: margin,
        ),
        theme: theme,
      );
    }

    group('Basic Rendering', () {
      testWidgets(
        'should render progress bar and percentage for option with votes',
        (tester) async {
          await createWidgetUnderTest(
            tester: tester,
            option: optionWithVotes,
            poll: testPoll,
            color: Colors.blue,
          );

          // Should find LinearProgressIndicator
          expect(find.byType(LinearProgressIndicator), findsOneWidget);

          // Should find percentage text
          expect(find.textContaining('%'), findsOneWidget);

          // Should find SizedBox for spacing
          expect(find.byType(SizedBox), findsWidgets);
        },
      );

      testWidgets('should return SizedBox.shrink for option without votes', (
        tester,
      ) async {
        await createWidgetUnderTest(
          tester: tester,
          option: optionWithoutVotes,
          poll: testPoll,
          color: Colors.red,
        );

        // Should find SizedBox.shrink (no progress bar)
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsNothing);
        expect(find.textContaining('%'), findsNothing);
      });
    });

    group('Progress Bar Properties', () {
      testWidgets('should apply correct height to progress bar', (
        tester,
      ) async {
        const customHeight = 12.0;
        await createWidgetUnderTest(
          tester: tester,
          option: optionWithVotes,
          poll: testPoll,
          color: Colors.green,
          height: customHeight,
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);

        expect(sizedBox.height, customHeight);
      });

      testWidgets('should calculate correct progress value', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          option: optionWithVotes,
          poll: testPoll,
          color: Colors.purple,
        );

        final progressIndicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );

        // Should have a value between 0 and 1
        expect(progressIndicator.value, greaterThanOrEqualTo(0.0));
        expect(progressIndicator.value, lessThanOrEqualTo(1.0));
      });

      testWidgets('should apply correct background color with alpha', (
        tester,
      ) async {
        const testColor = Colors.orange;
        await createWidgetUnderTest(
          tester: tester,
          option: optionWithVotes,
          poll: testPoll,
          color: testColor,
        );

        final progressIndicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );

        // Background color should have alpha 0.1
        expect(
          progressIndicator.backgroundColor,
          testColor.withValues(alpha: 0.1),
        );
      });

      testWidgets('should apply correct border radius', (tester) async {
        const customHeight = 16.0;
        await createWidgetUnderTest(
          tester: tester,
          option: optionWithVotes,
          poll: testPoll,
          color: Colors.indigo,
          height: customHeight,
        );

        final progressIndicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );

        // Border radius should be height / 2
        expect(
          progressIndicator.borderRadius,
          BorderRadius.circular(customHeight / 2),
        );
      });
    });

    group('Percentage Display', () {
      testWidgets('should show percentage text when showPercentage is true', (
        tester,
      ) async {
        await createWidgetUnderTest(
          tester: tester,
          option: optionWithVotes,
          poll: testPoll,
          color: Colors.pink,
          showPercentage: true,
        );

        expect(find.textContaining('%'), findsOneWidget);

        // Should find Text widget
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('should hide percentage text when showPercentage is false', (
        tester,
      ) async {
        await createWidgetUnderTest(
          tester: tester,
          option: optionWithVotes,
          poll: testPoll,
          color: Colors.cyan,
          showPercentage: false,
        );

        expect(find.textContaining('%'), findsNothing);

        // Should only find LinearProgressIndicator, no Text widget
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
        expect(find.byType(Text), findsNothing);
      });

      testWidgets('should apply custom percentage style when provided', (
        tester,
      ) async {
        const customStyle = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        );

        await createWidgetUnderTest(
          tester: tester,
          option: optionWithVotes,
          poll: testPoll,
          color: Colors.blue,
          percentageStyle: customStyle,
        );

        final textWidget = tester.widget<Text>(find.byType(Text));

        expect(textWidget.style, customStyle);
      });

      testWidgets(
        'should apply theme-based style when no custom style provided',
        (tester) async {
          const testColor = Colors.green;
          await createWidgetUnderTest(
            tester: tester,
            option: optionWithVotes,
            poll: testPoll,
            color: testColor,
          );

          final textWidget = tester.widget<Text>(find.byType(Text));

          expect(textWidget.style?.fontWeight, FontWeight.w600);
          expect(textWidget.style?.color, testColor);
        },
      );
    });

    group('Edge Cases', () {
      testWidgets('should handle zero votes gracefully', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          option: optionWithoutVotes,
          poll: testPoll,
          color: Colors.grey,
        );

        // Should render SizedBox.shrink
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsNothing);
        expect(find.textContaining('%'), findsNothing);
      });

      testWidgets('should handle different poll types', (tester) async {
        // Test with a different poll from the data
        final differentPoll = polls[1]; // poll-2
        final optionFromDifferentPoll = differentPoll.options.first;

        await createWidgetUnderTest(
          tester: tester,
          option: optionFromDifferentPoll,
          poll: differentPoll,
          color: Colors.deepPurple,
        );

        // Should still render progress bar if option has votes
        if (optionFromDifferentPoll.votes.isNotEmpty) {
          expect(find.byType(LinearProgressIndicator), findsOneWidget);
        } else {
          expect(find.byType(SizedBox), findsOneWidget);
        }
      });

      testWidgets('should handle custom margin', (tester) async {
        const customMargin = EdgeInsets.all(16.0);
        await createWidgetUnderTest(
          tester: tester,
          option: optionWithVotes,
          poll: testPoll,
          color: Colors.amber,
          margin: customMargin,
        );

        // Widget should render successfully with custom margin
        expect(find.byType(PollProgressWidget), findsOneWidget);
      });
    });

    group('Color Variations', () {
      testWidgets('should work with different color types', (tester) async {
        final colors = [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
          Colors.teal,
          Colors.pink,
        ];

        for (final color in colors) {
          await createWidgetUnderTest(
            tester: tester,
            option: optionWithVotes,
            poll: testPoll,
            color: color,
          );

          final progressIndicator = tester.widget<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          );

          expect(
            progressIndicator.backgroundColor,
            color.withValues(alpha: 0.1),
          );

          final valueColor =
              progressIndicator.valueColor as AlwaysStoppedAnimation<Color>;
          expect(valueColor.value, color.withValues(alpha: 0.8));
        }
      });
    });
  });
}
