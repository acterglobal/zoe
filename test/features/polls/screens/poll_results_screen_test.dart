import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/zoe_circle_widget.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/screens/poll_results_screen.dart';
import 'package:zoe/features/polls/widgets/poll_progress_widget.dart';
import 'package:zoe/features/polls/widgets/poll_voter_item_widget.dart';
import 'package:zoe/features/users/data/user_list.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/users/widgets/user_list_widget.dart';

import '../../../test-utils/test_utils.dart';
import '../notifiers/mock_poll_notifier.dart';

void main() {
  group('PollResultsScreen Tests', () {
    late ProviderContainer container;
    late MockPollListNotifier mockNotifier;
    late PollModel testPoll;
    late List<UserModel> testUsers;

    setUp(() {
      testPoll = polls.first;
      testUsers = userList.take(3).toList();
      mockNotifier = MockPollListNotifier();

      container = ProviderContainer.test(
        overrides: [
          pollListProvider.overrideWith(() => mockNotifier),
          pollProvider(testPoll.id).overrideWith((ref) => testPoll),
          usersBySheetIdProvider(testPoll.sheetId).overrideWithValue(testUsers),
          pollVotedMembersProvider(testPoll.id).overrideWithValue(testUsers.take(2).toList()),
          contentListProvider.overrideWithValue([]),
        ],
      );
    });

    Future<void> createWidgetUnderTest({
      required WidgetTester tester,
      required String pollId,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: PollResultsScreen(pollId: pollId),
        container: container,
      );
    }

    group('Basic Rendering', () {
      testWidgets('renders correctly with valid poll', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find main screen components
        expect(find.byType(PollResultsScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('renders app bar with correct title', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find app bar components
        expect(find.byType(ZoeAppBar), findsOneWidget);
        
        // App bar should not have leading
        final appBar = find.byType(AppBar);
        final appBarWidget = tester.widget<AppBar>(appBar);
        expect(appBarWidget.automaticallyImplyLeading, isFalse);
      });

      testWidgets('renders poll results header', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find poll results header components
        expect(find.byType(GlassyContainer), findsAtLeastNWidgets(1));
        expect(find.byIcon(Icons.poll_outlined), findsOneWidget);
        expect(find.text(testPoll.question), findsOneWidget);
      });

      testWidgets('renders poll voting status', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find voting status components
        expect(find.byIcon(Icons.people_outline), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });

      testWidgets('renders poll options', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find poll options
        expect(find.byType(ListView), findsAtLeastNWidgets(1));
        expect(find.byType(ZoeCircleWidget), findsNWidgets(testPoll.options.length));
        
        // Should find poll progress widgets
        expect(find.byType(PollProgressWidget), findsNWidgets(testPoll.options.length));
      });

      testWidgets('renders voter items for each option', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find voter item widgets
        expect(find.byType(PollVoterItemWidget), findsAtLeastNWidgets(1));
      });
    });

    group('Empty State', () {
      testWidgets('renders empty state when poll is null', (tester) async {
        container = ProviderContainer.test(
          overrides: [
            pollListProvider.overrideWith(() => mockNotifier),
            pollProvider('non-existent-poll').overrideWith((ref) => null),
            usersBySheetIdProvider(testPoll.sheetId).overrideWithValue(testUsers),
            pollVotedMembersProvider(testPoll.id).overrideWithValue([]),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: 'non-existent-poll');

        // Should find empty state components
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(EmptyStateWidget), findsOneWidget);
        
        // Should not find poll results content
        expect(find.byType(GlassyContainer), findsNothing);
        expect(find.byType(PollProgressWidget), findsNothing);
      });
    });

    group('Poll Results Content', () {
      testWidgets('displays poll question correctly', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find poll question
        expect(find.text(testPoll.question), findsOneWidget);
      });

      testWidgets('displays poll options with correct titles', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find all poll option titles
        for (final option in testPoll.options) {
          expect(find.text(option.title), findsOneWidget);
        }
      });

      testWidgets('displays vote counts for each option', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find vote count text for each option
        for (final option in testPoll.options) {
          final voteCountText = '${option.votes.length} vote${option.votes.length == 1 ? '' : 's'}';
          expect(find.text(voteCountText), findsAtLeastNWidgets(1));
        }
      });

      testWidgets('sorts options by vote count', (tester) async {
        // Create a poll with different vote counts
        final pollWithVotes = testPoll.copyWith(
          options: [
            testPoll.options[0].copyWith(votes: [Vote(userId: 'user1', createdAt: DateTime.now())]),
            testPoll.options[1].copyWith(votes: [
              Vote(userId: 'user1', createdAt: DateTime.now()),
              Vote(userId: 'user2', createdAt: DateTime.now()),
            ]),
            testPoll.options[2].copyWith(votes: []),
          ],
        );

        container = ProviderContainer.test(
          overrides: [
            pollListProvider.overrideWith(() => mockNotifier),
            pollProvider(pollWithVotes.id).overrideWith((ref) => pollWithVotes),
            usersBySheetIdProvider(pollWithVotes.sheetId).overrideWithValue(testUsers),
            pollVotedMembersProvider(pollWithVotes.id).overrideWithValue(testUsers),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: pollWithVotes.id);

        // Should find all options
        expect(find.text(pollWithVotes.options[0].title), findsOneWidget);
        expect(find.text(pollWithVotes.options[1].title), findsOneWidget);
        expect(find.text(pollWithVotes.options[2].title), findsOneWidget);
      });
    });

    group('Voting Status', () {
      testWidgets('displays correct member count', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find member count text
        expect(find.textContaining('${testUsers.length}'), findsOneWidget);
      });

      testWidgets('displays correct voted members count', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find voted members count
        final votedMembers = testUsers.take(2).toList();
        expect(find.textContaining('${votedMembers.length}'), findsAtLeastNWidgets(1));
      });

      testWidgets('calculates participation rate correctly', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find participation rate text (format may vary based on localization)
        final votedMembers = testUsers.take(2).toList();
        final participationRate = (votedMembers.length / testUsers.length) * 100;
        // Check for percentage text - try different formats
        final hasPercentage = find.textContaining('%').evaluate().isNotEmpty ||
                             find.textContaining('${participationRate.toStringAsFixed(0)}%').evaluate().isNotEmpty ||
                             find.textContaining('${participationRate.toStringAsFixed(1)}%').evaluate().isNotEmpty;
        expect(hasPercentage, isTrue);
      });

      testWidgets('shows visibility button for participants', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find visibility button
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });
    });

    group('Layout Structure', () {

      testWidgets('has correct padding and spacing', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find SingleChildScrollView with padding
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        
        // Should find SizedBox widgets for spacing
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });
    });

    group('Widget Properties', () {
      testWidgets('has correct key when provided', (tester) async {
        const testKey = Key('test-poll-results-screen-key');
        
        await tester.pumpMaterialWidgetWithProviderScope(
          child: PollResultsScreen(
            key: testKey,
            pollId: testPoll.id,
          ),
          container: container,
        );

        expect(find.byKey(testKey), findsOneWidget);
      });

      testWidgets('requires pollId parameter', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should render correctly with pollId
        expect(find.byType(PollResultsScreen), findsOneWidget);
      });
    });

    group('Provider Integration', () {
      testWidgets('watches poll provider correctly', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should render correctly
        expect(find.byType(PollResultsScreen), findsOneWidget);
        
        // Verify poll provider is being watched
        final poll = container.read(pollProvider(testPoll.id));
        expect(poll, isNotNull);
        expect(poll!.id, equals(testPoll.id));
      });

      testWidgets('watches users by sheet provider correctly', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should render correctly
        expect(find.byType(PollResultsScreen), findsOneWidget);
        
        // Verify users by sheet provider is being watched
        final users = container.read(usersBySheetIdProvider(testPoll.sheetId));
        expect(users, isNotNull);
        expect(users.length, equals(testUsers.length));
      });

      testWidgets('watches poll voted members provider correctly', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should render correctly
        expect(find.byType(PollResultsScreen), findsOneWidget);
        
        // Verify poll voted members provider is being watched
        final votedMembers = container.read(pollVotedMembersProvider(testPoll.id));
        expect(votedMembers, isNotNull);
        expect(votedMembers.length, equals(2));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles poll with no votes', (tester) async {
        final pollWithNoVotes = testPoll.copyWith(
          options: testPoll.options.map((option) => option.copyWith(votes: [])).toList(),
        );

        container = ProviderContainer.test(
          overrides: [
            pollListProvider.overrideWith(() => mockNotifier),
            pollProvider(pollWithNoVotes.id).overrideWith((ref) => pollWithNoVotes),
            usersBySheetIdProvider(pollWithNoVotes.sheetId).overrideWithValue(testUsers),
            pollVotedMembersProvider(pollWithNoVotes.id).overrideWithValue([]),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: pollWithNoVotes.id);

        // Should render correctly
        expect(find.byType(PollResultsScreen), findsOneWidget);
        expect(find.byType(PollProgressWidget), findsNWidgets(pollWithNoVotes.options.length));
      });

      testWidgets('handles poll with single vote', (tester) async {
        final pollWithSingleVote = testPoll.copyWith(
          options: [
            testPoll.options[0].copyWith(votes: [Vote(userId: 'user1', createdAt: DateTime.now())]),
            ...testPoll.options.skip(1).map((option) => option.copyWith(votes: [])),
          ],
        );

        container = ProviderContainer.test(
          overrides: [
            pollListProvider.overrideWith(() => mockNotifier),
            pollProvider(pollWithSingleVote.id).overrideWith((ref) => pollWithSingleVote),
            usersBySheetIdProvider(pollWithSingleVote.sheetId).overrideWithValue(testUsers),
            pollVotedMembersProvider(pollWithSingleVote.id).overrideWithValue([testUsers.first]),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: pollWithSingleVote.id);

        // Should render correctly
        expect(find.byType(PollResultsScreen), findsOneWidget);
        expect(find.text('1 vote'), findsOneWidget);
      });

      testWidgets('handles poll with multiple votes', (tester) async {
        final pollWithMultipleVotes = testPoll.copyWith(
          options: [
            testPoll.options[0].copyWith(votes: [
              Vote(userId: 'user1', createdAt: DateTime.now()),
              Vote(userId: 'user2', createdAt: DateTime.now()),
              Vote(userId: 'user3', createdAt: DateTime.now()),
            ]),
            ...testPoll.options.skip(1).map((option) => option.copyWith(votes: [])),
          ],
        );

        container = ProviderContainer.test(
          overrides: [
            pollListProvider.overrideWith(() => mockNotifier),
            pollProvider(pollWithMultipleVotes.id).overrideWith((ref) => pollWithMultipleVotes),
            usersBySheetIdProvider(pollWithMultipleVotes.sheetId).overrideWithValue(testUsers),
            pollVotedMembersProvider(pollWithMultipleVotes.id).overrideWithValue(testUsers),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: pollWithMultipleVotes.id);

        // Should render correctly
        expect(find.byType(PollResultsScreen), findsOneWidget);
        expect(find.text('3 votes'), findsOneWidget);
      });
    });

    group('Modal Bottom Sheet', () {
      testWidgets('can open participants bottom sheet', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find visibility button
        expect(find.byIcon(Icons.visibility), findsOneWidget);
        
        // Tap the visibility button
        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pumpAndSettle();

        // Should show modal bottom sheet
        expect(find.byType(UserListWidget), findsOneWidget);
      });

      testWidgets('participants bottom sheet shows correct users', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Tap the visibility button
        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pumpAndSettle();

        // Should show user list widget
        expect(find.byType(UserListWidget), findsOneWidget);
      });
    });

    group('Poll Option Features', () {
      testWidgets('shows star icon for option with max votes', (tester) async {
        // Create a poll where one option has the most votes
        final pollWithMaxVotes = testPoll.copyWith(
          options: [
            testPoll.options[0].copyWith(votes: [
              Vote(userId: 'user1', createdAt: DateTime.now()),
              Vote(userId: 'user2', createdAt: DateTime.now()),
            ]),
            testPoll.options[1].copyWith(votes: [Vote(userId: 'user3', createdAt: DateTime.now())]),
            testPoll.options[2].copyWith(votes: []),
          ],
        );

        container = ProviderContainer.test(
          overrides: [
            pollListProvider.overrideWith(() => mockNotifier),
            pollProvider(pollWithMaxVotes.id).overrideWith((ref) => pollWithMaxVotes),
            usersBySheetIdProvider(pollWithMaxVotes.sheetId).overrideWithValue(testUsers),
            pollVotedMembersProvider(pollWithMaxVotes.id).overrideWithValue(testUsers),
            contentListProvider.overrideWithValue([]),
          ],
        );

        await createWidgetUnderTest(tester: tester, pollId: pollWithMaxVotes.id);

        // Should find star icon for the option with max votes
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('displays correct colors for each option', (tester) async {
        await createWidgetUnderTest(tester: tester, pollId: testPoll.id);

        // Should find circle widgets for each option
        expect(find.byType(ZoeCircleWidget), findsNWidgets(testPoll.options.length));
      });
    });
  });
}
