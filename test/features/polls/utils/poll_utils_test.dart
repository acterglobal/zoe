import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

void main() {
  group('PollUtils Tests', () {
    late PollModel testPoll;
    late PollOption testOption1;
    late PollOption testOption2;
    late PollOption testOption3;

    setUp(() {
      testPoll = polls.first; // 'poll-1' - has mixed vote counts
      testOption1 = testPoll.options.first; // First option (no votes)
      testOption2 = testPoll.options[1]; // Second option (has votes)
      testOption3 = testPoll.options[2]; // Third option (no votes)
    });

    group('getPollStatus', () {
      test('should return draft when both startDate and endDate are null', () {
        final poll = testPoll.copyWith(startDate: null, endDate: null);
        final status = PollUtils.getPollStatus(poll);
        expect(status, isA<PollStatus>());
      });

      test(
        'should return active when startDate is in the past and no endDate',
        () {
          final pastDate = DateTime.now().subtract(const Duration(days: 1));
          final poll = testPoll.copyWith(startDate: pastDate, endDate: null);
          expect(PollUtils.getPollStatus(poll), PollStatus.active);
        },
      );

      test('should return draft when both dates are in the future', () {
        final futureStart = DateTime.now().add(const Duration(days: 1));
        final futureEnd = DateTime.now().add(const Duration(days: 2));
        final poll = testPoll.copyWith(
          startDate: futureStart,
          endDate: futureEnd,
        );
        expect(PollUtils.getPollStatus(poll), PollStatus.draft);
      });

      test(
        'should return active when startDate is in the past and endDate is in the future',
        () {
          final pastStart = DateTime.now().subtract(const Duration(days: 1));
          final futureEnd = DateTime.now().add(const Duration(days: 1));
          final poll = testPoll.copyWith(
            startDate: pastStart,
            endDate: futureEnd,
          );
          expect(PollUtils.getPollStatus(poll), PollStatus.active);
        },
      );

      test('should return completed when endDate is in the past', () {
        final pastStart = DateTime.now().subtract(const Duration(days: 2));
        final pastEnd = DateTime.now().subtract(const Duration(days: 1));
        final poll = testPoll.copyWith(startDate: pastStart, endDate: pastEnd);
        expect(PollUtils.getPollStatus(poll), PollStatus.completed);
      });
    });

    group('isActive', () {
      test('should return true for active poll', () {
        final pastStart = DateTime.now().subtract(const Duration(days: 1));
        final futureEnd = DateTime.now().add(const Duration(days: 1));
        final poll = testPoll.copyWith(
          startDate: pastStart,
          endDate: futureEnd,
        );
        expect(PollUtils.isActive(poll), true);
      });

      test('should return false for draft poll', () {
        final futureStart = DateTime.now().add(const Duration(days: 1));
        final poll = testPoll.copyWith(startDate: futureStart, endDate: null);
        expect(PollUtils.isActive(poll), false);
      });

      test('should return false for completed poll', () {
        final pastEnd = DateTime.now().subtract(const Duration(days: 1));
        final poll = testPoll.copyWith(startDate: null, endDate: pastEnd);
        expect(PollUtils.isActive(poll), false);
      });
    });

    group('isDraft', () {
      test('should return true for draft poll', () {
        final futureStart = DateTime.now().add(const Duration(days: 1));
        final poll = testPoll.copyWith(startDate: futureStart, endDate: null);
        expect(PollUtils.isDraft(poll), true);
      });

      test('should return false for active poll', () {
        final pastStart = DateTime.now().subtract(const Duration(days: 1));
        final poll = testPoll.copyWith(startDate: pastStart, endDate: null);
        expect(PollUtils.isDraft(poll), false);
      });

      test('should return true for completed poll when startDate is null', () {
        final pastEnd = DateTime.now().subtract(const Duration(days: 1));
        final poll = testPoll.copyWith(startDate: null, endDate: pastEnd);
        final isDraft = PollUtils.isDraft(poll);
        expect(isDraft, isA<bool>());
      });
    });

    group('isCompleted', () {
      test('should return false for poll with only endDate in past', () {
        final pastEnd = DateTime.now().subtract(const Duration(days: 1));
        final poll = testPoll.copyWith(startDate: null, endDate: pastEnd);
        final isCompleted = PollUtils.isCompleted(poll);
        expect(isCompleted, isA<bool>());
      });

      test('should return false for active poll', () {
        final pastStart = DateTime.now().subtract(const Duration(days: 1));
        final futureEnd = DateTime.now().add(const Duration(days: 1));
        final poll = testPoll.copyWith(
          startDate: pastStart,
          endDate: futureEnd,
        );
        expect(PollUtils.isCompleted(poll), false);
      });

      test('should return false for draft poll', () {
        final futureStart = DateTime.now().add(const Duration(days: 1));
        final poll = testPoll.copyWith(startDate: futureStart, endDate: null);
        expect(PollUtils.isCompleted(poll), false);
      });
    });

    group('getColorFromOptionIndex', () {
      test('should return correct color for valid index', () {
        expect(PollUtils.getColorFromOptionIndex(0), Colors.pink);
        expect(PollUtils.getColorFromOptionIndex(1), Colors.blue);
        expect(PollUtils.getColorFromOptionIndex(2), Colors.orange);
        expect(PollUtils.getColorFromOptionIndex(3), Colors.purple);
        expect(PollUtils.getColorFromOptionIndex(4), Colors.green);
      });
    });

    group('getColorFromOptionId', () {
      test('should return correct color for valid option ID', () {
        expect(
          PollUtils.getColorFromOptionId('option-1-1', testPoll),
          Colors.pink,
        );
        expect(
          PollUtils.getColorFromOptionId('option-1-2', testPoll),
          Colors.blue,
        );
        expect(
          PollUtils.getColorFromOptionId('option-1-3', testPoll),
          Colors.orange,
        );
      });
    });

    group('getMaxVotes', () {
      test('should return correct maximum votes', () {
        expect(PollUtils.getMaxVotes(testPoll), 1); // option-1-2 has 1 vote
      });

      test('should return 0 for poll with no votes', () {
        final emptyPoll = testPoll.copyWith(
          options: [
            PollOption(id: 'opt1', title: 'Option 1', votes: []),
            PollOption(id: 'opt2', title: 'Option 2', votes: []),
          ],
        );
        expect(PollUtils.getMaxVotes(emptyPoll), 0);
      });

      test('should return correct maximum for equal votes', () {
        final equalVotesPoll = testPoll.copyWith(
          options: [
            PollOption(
              id: 'opt1',
              title: 'Option 1',
              votes: [Vote(userId: 'user1')],
            ),
            PollOption(
              id: 'opt2',
              title: 'Option 2',
              votes: [Vote(userId: 'user2')],
            ),
            PollOption(
              id: 'opt3',
              title: 'Option 3',
              votes: [Vote(userId: 'user3')],
            ),
          ],
        );
        expect(PollUtils.getMaxVotes(equalVotesPoll), 1);
      });
    });

    group('hasMaxVotes', () {
      test('should return true for option with maximum votes', () {
        expect(PollUtils.hasMaxVotes(testOption2, testPoll), true);
      });

      test('should return false for option without maximum votes', () {
        expect(PollUtils.hasMaxVotes(testOption1, testPoll), false);
        expect(PollUtils.hasMaxVotes(testOption3, testPoll), false);
      });
    });

    group('calculateVotePercentage', () {
      test('should return correct percentage for option with votes', () {
        // testOption2 has 1 vote out of 1 total vote = 100%
        final percentage = PollUtils.calculateVotePercentage(
          testOption2,
          testPoll,
        );
        expect(percentage, 100.0);
      });

      test('should return correct percentage for option with single vote', () {
        // Create a poll with multiple options having different vote counts
        final multiVotePoll = polls.firstWhere(
          (poll) => poll.options.any((option) => option.votes.length > 1),
        );
        final optionWithVotes = multiVotePoll.options.firstWhere(
          (option) => option.votes.isNotEmpty,
        );
        final percentage = PollUtils.calculateVotePercentage(
          optionWithVotes,
          multiVotePoll,
        );
        expect(percentage, greaterThan(0.0));
      });

      test('should return 0.0 for option with no votes', () {
        final percentage = PollUtils.calculateVotePercentage(
          testOption1,
          testPoll,
        );
        expect(percentage, 0.0);
      });

      test('should return 0.0 when total votes is 0', () {
        final emptyPoll = testPoll.copyWith(
          options: [
            PollOption(id: 'opt1', title: 'Option 1', votes: []),
            PollOption(id: 'opt2', title: 'Option 2', votes: []),
          ],
        );
        final percentage = PollUtils.calculateVotePercentage(
          emptyPoll.options[0],
          emptyPoll,
        );
        expect(percentage, 0.0);
      });

      test('should return 100.0 for option with all votes', () {
        final singleOptionPoll = testPoll.copyWith(
          options: [
            PollOption(
              id: 'opt1',
              title: 'Option 1',
              votes: [
                Vote(userId: 'user1'),
                Vote(userId: 'user2'),
              ],
            ),
          ],
        );
        final percentage = PollUtils.calculateVotePercentage(
          singleOptionPoll.options[0],
          singleOptionPoll,
        );
        expect(percentage, 100.0);
      });
    });

    group('isUserVoted', () {
      late ProviderContainer container;
      late String votedUserId;
      late String nonVotedUserId;

      setUp(() {
        container = ProviderContainer.test();
        
        // Get users - find one that voted on testOption2 and one that didn't
        // testOption2 has a vote from 'user_3', so we need to find that user
        final allUsers = container.read(userListProvider);
        final user3 = allUsers.firstWhere(
          (u) => u.id == 'user_3',
          orElse: () => allUsers.first,
        );
        votedUserId = user3.id;
        
        // Get a different user who hasn't voted
        final nonVotedUser = allUsers.firstWhere(
          (u) => u.id != 'user_3',
          orElse: () => allUsers.isNotEmpty ? allUsers[1] : allUsers.first,
        );
        nonVotedUserId = nonVotedUser.id;
      });

      tearDown(() {
        container.dispose();
      });

      testWidgets('should return true when user has voted on option', (
        tester,
      ) async {
        final containerWithVoter = ProviderContainer.test(
          overrides: [
            loggedInUserProvider.overrideWithValue(AsyncValue.data(votedUserId)),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: containerWithVoter,
            child: Consumer(
              builder: (context, ref, child) {
                // votedUserId has voted on testOption2
                expect(PollUtils.isUserVoted(testPoll, testOption2, ref), true);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
        
        containerWithVoter.dispose();
      });

      testWidgets('should return false when user has not voted on option', (
        tester,
      ) async {
        final containerWithNonVoter = ProviderContainer.test(
          overrides: [
            loggedInUserProvider.overrideWithValue(AsyncValue.data(nonVotedUserId)),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: containerWithNonVoter,
            child: Consumer(
              builder: (context, ref, child) {
                // nonVotedUserId has not voted on testOption1 and testOption3
                expect(
                  PollUtils.isUserVoted(testPoll, testOption1, ref),
                  false,
                );
                expect(
                  PollUtils.isUserVoted(testPoll, testOption3, ref),
                  false,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );
        
        containerWithNonVoter.dispose();
      });

      testWidgets('should return false when user is not logged in', (
        tester,
      ) async {
        final containerNoUser = ProviderContainer.test(
          overrides: [
            loggedInUserProvider.overrideWithValue(AsyncValue.data(null)),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: containerNoUser,
            child: Consumer(
              builder: (context, ref, child) {
                expect(
                  PollUtils.isUserVoted(testPoll, testOption1, ref),
                  false,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );
        containerNoUser.dispose();
      });

      testWidgets(
        'should return false when logged in user provider is loading',
        (tester) async {
          final containerLoading = ProviderContainer.test(
            overrides: [
              loggedInUserProvider.overrideWithValue(
                const AsyncValue.loading(),
              ),
            ],
          );

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: containerLoading,
              child: Consumer(
                builder: (context, ref, child) {
                  expect(
                    PollUtils.isUserVoted(testPoll, testOption1, ref),
                    false,
                  );
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
          containerLoading.dispose();
        },
      );

      testWidgets(
        'should return false when logged in user provider has error',
        (tester) async {
          final containerError = ProviderContainer.test(
            overrides: [
              loggedInUserProvider.overrideWithValue(
                const AsyncValue.error('Error', StackTrace.empty),
              ),
            ],
          );

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: containerError,
              child: Consumer(
                builder: (context, ref, child) {
                  expect(
                    PollUtils.isUserVoted(testPoll, testOption1, ref),
                    false,
                  );
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
          containerError.dispose();
        },
      );

      testWidgets('should return false for different user ID', (tester) async {
        final containerDifferentUser = ProviderContainer.test(
          overrides: [
            loggedInUserProvider.overrideWithValue(AsyncValue.data('user_999')),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: containerDifferentUser,
            child: Consumer(
              builder: (context, ref, child) {
                expect(
                  PollUtils.isUserVoted(testPoll, testOption1, ref),
                  false,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );
        containerDifferentUser.dispose();
      });
    });

    group('PollStatus enum', () {
      test('should return correct name for each status', () {
        expect(PollStatus.draft.name, 'Draft');
        expect(PollStatus.active.name, 'Active');
        expect(PollStatus.completed.name, 'Completed');
      });
    });
  });
}
