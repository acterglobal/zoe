import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/widgets/poll_checkbox_widget.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('PollCheckboxWidget Tests', () {
    late PollModel testPoll;
    late PollOption testOption1;
    late PollOption testOption2;

    setUp(() {
      testPoll = polls.first; // 'poll-1' - single choice poll
      testOption1 = testPoll.options.first; // First option
      testOption2 = testPoll.options[1]; // Second option (has votes)
    });

    Future<void> createWidgetUnderTest({
      required WidgetTester tester,
      required PollModel poll,
      required PollOption option,
      required bool isVoted,
      ThemeData? theme,
    }) async {
      await tester.pumpMaterialWidget(
        child: Builder(
          builder: (context) =>
              pollCheckboxWidget(context, poll, option, isVoted),
        ),
        theme: theme,
      );
    }

    group('Multiple Choice Poll (Checkbox)', () {
      late PollModel multipleChoicePoll;

      setUp(() {
        // Use existing multiple choice poll from polls.dart
        multipleChoicePoll = polls.firstWhere((poll) => poll.isMultipleChoice);
      });

      testWidgets('renders checkbox widget for multiple choice poll', (
        tester,
      ) async {
        await createWidgetUnderTest(
          tester: tester,
          poll: multipleChoicePoll,
          option: testOption1,
          isVoted: false,
        );

        expect(find.byType(Container), findsOneWidget);

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.minWidth, 16);
        expect(container.constraints?.minHeight, 16);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.shape, BoxShape.rectangle);
      });

      testWidgets('shows unvoted state for multiple choice poll', (
        tester,
      ) async {
        await createWidgetUnderTest(
          tester: tester,
          poll: multipleChoicePoll,
          option: testOption1,
          isVoted: false,
        );

        expect(find.byIcon(Icons.check), findsNothing);

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Should have surface color with alpha
        expect(decoration.color, isA<Color>());
      });

      testWidgets('shows voted state for multiple choice poll', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          poll: multipleChoicePoll,
          option: testOption1,
          isVoted: true,
        );

        expect(find.byIcon(Icons.check), findsOneWidget);

        final icon = tester.widget<Icon>(find.byIcon(Icons.check));
        expect(icon.color, AppColors.darkOnSurface);
        expect(icon.size, 10);

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Should have option color with alpha
        expect(decoration.color, isA<Color>());
      });
    });

    group('Single Choice Poll (Radio Button)', () {
      late PollModel singleChoicePoll;

      setUp(() {
        // Use existing single choice poll from polls.dart
        singleChoicePoll = polls.firstWhere((poll) => !poll.isMultipleChoice);
      });

      testWidgets('renders radio button widget for single choice poll', (
        tester,
      ) async {
        await createWidgetUnderTest(
          tester: tester,
          poll: singleChoicePoll,
          option: testOption1,
          isVoted: false,
        );

        expect(find.byType(Container), findsOneWidget);

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints?.minWidth, 16);
        expect(container.constraints?.minHeight, 16);

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.shape, BoxShape.circle);
      });

      testWidgets('shows unvoted state for single choice poll', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          poll: singleChoicePoll,
          option: testOption1,
          isVoted: false,
        );

        expect(find.byIcon(Icons.circle), findsNothing);

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Should have surface color with alpha
        expect(decoration.color, isA<Color>());
      });

      testWidgets('shows voted state for single choice poll', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          poll: singleChoicePoll,
          option: testOption1,
          isVoted: true,
        );

        expect(find.byIcon(Icons.circle), findsOneWidget);

        final icon = tester.widget<Icon>(find.byIcon(Icons.circle));
        expect(icon.color, AppColors.darkOnSurface);
        expect(icon.size, 10);

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Should have option color with alpha
        expect(decoration.color, isA<Color>());
      });
    });

    group('Color Application', () {
      testWidgets('applies color from PollUtils for voted state', (
        tester,
      ) async {
        await createWidgetUnderTest(
          tester: tester,
          poll: testPoll,
          option: testOption1,
          isVoted: true,
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Color should be applied with alpha 0.6
        expect(decoration.color, isA<Color>());

        final border = decoration.border as Border;
        expect(border.top.color, isA<Color>());
      });

      testWidgets('applies theme colors for unvoted state', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          poll: testPoll,
          option: testOption1,
          isVoted: false,
        );

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Should use theme surface color with alpha
        expect(decoration.color, isA<Color>());

        final border = decoration.border as Border;
        // Should use theme outline color with alpha
        expect(border.top.color, isA<Color>());
      });

      testWidgets('applies different colors for different options', (
        tester,
      ) async {
        await createWidgetUnderTest(
          tester: tester,
          poll: testPoll,
          option: testOption1,
          isVoted: true,
        );

        final container1 = tester.widget<Container>(find.byType(Container));
        final decoration1 = container1.decoration as BoxDecoration;
        final color1 = decoration1.color;

        await createWidgetUnderTest(
          tester: tester,
          poll: testPoll,
          option: testOption2,
          isVoted: true,
        );

        final container2 = tester.widget<Container>(find.byType(Container));
        final decoration2 = container2.decoration as BoxDecoration;
        final color2 = decoration2.color;

        // Different options should have different colors
        expect(color1, isNot(equals(color2)));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles poll with no options gracefully', (tester) async {
        final emptyPoll = testPoll.copyWith(options: []);

        await createWidgetUnderTest(
          tester: tester,
          poll: emptyPoll,
          option: testOption1,
          isVoted: false,
        );

        expect(find.byType(Container), findsOneWidget);

        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        // Should still render with default styling
        expect(decoration.shape, BoxShape.circle); // Single choice default
      });

      testWidgets('handles option with no votes', (tester) async {
        // Use an option from existing poll that has no votes
        final emptyOption = testPoll.options.firstWhere(
          (option) => option.votes.isEmpty,
        );

        await createWidgetUnderTest(
          tester: tester,
          poll: testPoll,
          option: emptyOption,
          isVoted: false,
        );

        expect(find.byType(Container), findsOneWidget);
        expect(find.byIcon(Icons.circle), findsNothing);
      });

      testWidgets('handles option with many votes', (tester) async {
        // Use an option from existing poll that has many votes
        final manyVotesOption = polls
            .firstWhere(
              (poll) => poll.options.any((option) => option.votes.length > 5),
            )
            .options
            .firstWhere((option) => option.votes.length > 5);

        await createWidgetUnderTest(
          tester: tester,
          poll: testPoll,
          option: manyVotesOption,
          isVoted: true,
        );

        expect(find.byType(Container), findsOneWidget);
        expect(find.byIcon(Icons.circle), findsOneWidget);

        final icon = tester.widget<Icon>(find.byIcon(Icons.circle));
        expect(icon.size, 10);
        expect(icon.color, AppColors.darkOnSurface);
      });

      testWidgets('maintains correct icon size and color', (tester) async {
        await createWidgetUnderTest(
          tester: tester,
          poll: testPoll,
          option: testOption1,
          isVoted: true,
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.circle));
        expect(icon.size, 10);
        expect(icon.color, AppColors.darkOnSurface);
      });
    });

    group('Widget Structure', () {
      testWidgets('shows icon only when voted', (tester) async {
        // Unvoted state
        await createWidgetUnderTest(
          tester: tester,
          poll: testPoll,
          option: testOption1,
          isVoted: false,
        );

        expect(find.byType(Icon), findsNothing);

        // Voted state
        await createWidgetUnderTest(
          tester: tester,
          poll: testPoll,
          option: testOption1,
          isVoted: true,
        );

        expect(find.byType(Icon), findsOneWidget);
      });

      testWidgets('uses correct icon for poll type', (tester) async {
        // Single choice (radio) - use existing single choice poll
        final singleChoicePoll = polls.firstWhere(
          (poll) => !poll.isMultipleChoice,
        );
        await createWidgetUnderTest(
          tester: tester,
          poll: singleChoicePoll,
          option: singleChoicePoll.options.first,
          isVoted: true,
        );

        expect(find.byIcon(Icons.circle), findsOneWidget);
        expect(find.byIcon(Icons.check), findsNothing);

        // Multiple choice (checkbox) - use existing multiple choice poll
        final multipleChoicePoll = polls.firstWhere(
          (poll) => poll.isMultipleChoice,
        );
        await createWidgetUnderTest(
          tester: tester,
          poll: multipleChoicePoll,
          option: multipleChoicePoll.options.first,
          isVoted: true,
        );

        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(find.byIcon(Icons.circle), findsNothing);
      });
    });
  });
}
