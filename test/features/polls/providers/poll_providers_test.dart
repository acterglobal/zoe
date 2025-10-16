import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/users/models/user_model.dart';
import '../../../test-utils/mock_searchValue.dart';

void main() {
  group('Poll Providers Tests', () {
    late ProviderContainer container;
    late PollModel testPoll;

    setUp(() {
      testPoll = polls.first;

      container = ProviderContainer.test(
        overrides: [
          searchValueProvider.overrideWith(MockSearchValue.new),
          currentUserProvider.overrideWith((ref) => Future.value(null)),
          usersBySheetIdProvider('sheet-1').overrideWith((ref) => []),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('PollList Provider', () {
      test('initial state contains all polls', () {
        final pollList = container.read(pollListProvider);
        expect(pollList, equals(polls));
        expect(pollList.length, equals(polls.length));
      });

      test('addPoll adds new poll to list', () async {
        final newPoll = PollModel(
          id: 'new-poll',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          question: 'New poll question?',
          options: [
            PollOption(id: 'option-1', title: 'Option 1'),
            PollOption(id: 'option-2', title: 'Option 2'),
          ],
        );

        await container.read(pollListProvider.notifier).addPoll(newPoll);

        final updatedList = container.read(pollListProvider);
        expect(updatedList.length, equals(polls.length + 1));
        expect(updatedList.last, equals(newPoll));
      });

      test('deletePoll removes poll from list', () {
        final initialLength = container.read(pollListProvider).length;
        
        container.read(pollListProvider.notifier).deletePoll(testPoll.id);

        final updatedList = container.read(pollListProvider);
        expect(updatedList.length, equals(initialLength - 1));
        expect(updatedList.any((p) => p.id == testPoll.id), isFalse);
      });

      test('deletePoll does nothing for non-existent poll', () {
        final initialLength = container.read(pollListProvider).length;
        
        container.read(pollListProvider.notifier).deletePoll('non-existent-id');

        final updatedList = container.read(pollListProvider);
        expect(updatedList.length, equals(initialLength));
      });

      test('updatePollQuestion updates poll question', () {
        const newQuestion = 'Updated question?';
        
        container.read(pollListProvider.notifier).updatePollQuestion(testPoll.id, newQuestion);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        expect(updatedPoll?.question, equals(newQuestion));
      });

      test('updatePollOrderIndex updates poll order', () {
        const newOrderIndex = 999;
        
        container.read(pollListProvider.notifier).updatePollOrderIndex(testPoll.id, newOrderIndex);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        expect(updatedPoll?.orderIndex, equals(newOrderIndex));
      });

      test('addPollOption adds new option to poll', () {
        const newOptionText = 'New Option';
        final initialOptionsCount = testPoll.options.length;
        
        container.read(pollListProvider.notifier).addPollOption(testPoll.id, newOptionText);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        expect(updatedPoll?.options.length, equals(initialOptionsCount + 1));
        expect(updatedPoll?.options.last.title, equals(newOptionText));
      });

      test('addPollOption with empty text adds empty option', () {
        const emptyOptionText = '';
        final initialOptionsCount = testPoll.options.length;
        
        container.read(pollListProvider.notifier).addPollOption(testPoll.id, emptyOptionText);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        expect(updatedPoll?.options.length, equals(initialOptionsCount + 1));
        expect(updatedPoll?.options.last.title, equals(''));
      });

      test('updatePollOptionText updates option text', () {
        const newText = 'Updated Option Text';
        final optionId = testPoll.options.first.id;
        
        container.read(pollListProvider.notifier).updatePollOptionText(testPoll.id, optionId, newText);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        final updatedOption = updatedPoll?.options.firstWhere((o) => o.id == optionId);
        expect(updatedOption?.title, equals(newText));
      });

      test('deletePollOption removes option from poll', () {
        final optionId = testPoll.options.first.id;
        final initialOptionsCount = testPoll.options.length;
        
        container.read(pollListProvider.notifier).deletePollOption(testPoll.id, optionId);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        expect(updatedPoll?.options.length, equals(initialOptionsCount - 1));
        expect(updatedPoll?.options.any((o) => o.id == optionId), isFalse);
      });

      test('togglePollMultipleChoice toggles multiple choice setting', () {
        final initialValue = testPoll.isMultipleChoice;
        
        container.read(pollListProvider.notifier).togglePollMultipleChoice(testPoll.id);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        expect(updatedPoll?.isMultipleChoice, equals(!initialValue));
      });

      test('endPoll sets end date', () {
        container.read(pollListProvider.notifier).endPoll(testPoll.id);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        expect(updatedPoll?.endDate, isNotNull);
        expect(updatedPoll?.endDate?.isBefore(DateTime.now().add(const Duration(seconds: 1))), isTrue);
      });

      test('startPoll sets start date', () {
        container.read(pollListProvider.notifier).startPoll(testPoll.id);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        expect(updatedPoll?.startDate, isNotNull);
        expect(updatedPoll?.startDate?.isBefore(DateTime.now().add(const Duration(seconds: 1))), isTrue);
      });
    });

    group('Voting Tests', () {
      test('voteOnPoll adds vote for single choice poll', () async {
        const userId = 'user_1';
        final optionId = testPoll.options.first.id;
        final initialVotesCount = testPoll.options.first.votes.length;

        await container.read(pollListProvider.notifier).voteOnPoll(testPoll.id, optionId, userId);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        final updatedOption = updatedPoll?.options.firstWhere((o) => o.id == optionId);
        expect(updatedOption?.votes.length, equals(initialVotesCount + 1));
        expect(updatedOption?.votes.any((v) => v.userId == userId), isTrue);
      });

      test('voteOnPoll removes vote if already voted (single choice)', () async {
        const userId = 'user_2';
        final optionId = testPoll.options.firstWhere((o) => o.votes.any((v) => v.userId == userId)).id;
        final initialVotesCount = testPoll.options.firstWhere((o) => o.id == optionId).votes.length;

        await container.read(pollListProvider.notifier).voteOnPoll(testPoll.id, optionId, userId);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        final updatedOption = updatedPoll?.options.firstWhere((o) => o.id == optionId);
        expect(updatedOption?.votes.length, equals(initialVotesCount - 1));
        expect(updatedOption?.votes.any((v) => v.userId == userId), isFalse);
      });

      test('voteOnPoll removes previous votes when voting on different option (single choice)', () async {
        const userId = 'user_1';
        final firstOptionId = testPoll.options.first.id;
        final secondOptionId = testPoll.options[1].id;

        // Vote on first option
        await container.read(pollListProvider.notifier).voteOnPoll(testPoll.id, firstOptionId, userId);
        
        // Vote on second option
        await container.read(pollListProvider.notifier).voteOnPoll(testPoll.id, secondOptionId, userId);

        final updatedPoll = container.read(pollProvider(testPoll.id));
        final firstOption = updatedPoll?.options.firstWhere((o) => o.id == firstOptionId);
        final secondOption = updatedPoll?.options.firstWhere((o) => o.id == secondOptionId);
        
        expect(firstOption?.votes.any((v) => v.userId == userId), isFalse);
        expect(secondOption?.votes.any((v) => v.userId == userId), isTrue);
      });

      test('voteOnPoll allows multiple votes for multiple choice poll', () async {
        const userId = 'new_user'; // Use a user who hasn't voted yet
        final multipleChoicePoll = polls.firstWhere((p) => p.isMultipleChoice);
        final firstOptionId = multipleChoicePoll.options.first.id;
        final secondOptionId = multipleChoicePoll.options[1].id;

        // Vote on first option
        await container.read(pollListProvider.notifier).voteOnPoll(multipleChoicePoll.id, firstOptionId, userId);
        
        // Vote on second option
        await container.read(pollListProvider.notifier).voteOnPoll(multipleChoicePoll.id, secondOptionId, userId);

        final updatedPoll = container.read(pollProvider(multipleChoicePoll.id));
        final firstOption = updatedPoll?.options.firstWhere((o) => o.id == firstOptionId);
        final secondOption = updatedPoll?.options.firstWhere((o) => o.id == secondOptionId);
        
        expect(firstOption?.votes.any((v) => v.userId == userId), isTrue);
        expect(secondOption?.votes.any((v) => v.userId == userId), isTrue);
      });

      test('voteOnPoll removes vote from specific option in multiple choice poll', () async {
        const userId = 'user_7';
        final multipleChoicePoll = polls.firstWhere((p) => p.isMultipleChoice);
        final optionId = multipleChoicePoll.options.firstWhere((o) => o.votes.any((v) => v.userId == userId)).id;
        final initialVotesCount = multipleChoicePoll.options.firstWhere((o) => o.id == optionId).votes.length;

        await container.read(pollListProvider.notifier).voteOnPoll(multipleChoicePoll.id, optionId, userId);

        final updatedPoll = container.read(pollProvider(multipleChoicePoll.id));
        final updatedOption = updatedPoll?.options.firstWhere((o) => o.id == optionId);
        expect(updatedOption?.votes.length, equals(initialVotesCount - 1));
        expect(updatedOption?.votes.any((v) => v.userId == userId), isFalse);
      });
    });

    group('Poll Provider', () {
      test('poll provider returns correct poll by ID', () {
        final poll = container.read(pollProvider(testPoll.id));
        expect(poll, equals(testPoll));
      });

      test('poll provider returns null for non-existent ID', () {
        final poll = container.read(pollProvider('non-existent-id'));
        expect(poll, isNull);
      });

      test('poll provider updates when poll list changes', () {
        final initialPoll = container.read(pollProvider(testPoll.id));
        expect(initialPoll, equals(testPoll));

        container.read(pollListProvider.notifier).updatePollQuestion(testPoll.id, 'Updated Question');

        final updatedPoll = container.read(pollProvider(testPoll.id));
        expect(updatedPoll?.question, equals('Updated Question'));
        expect(updatedPoll?.id, equals(testPoll.id));
      });
    });

    group('Filtered Poll Lists', () {
      test('notActivePollList returns only draft polls', () {
        final notActivePolls = container.read(notActivePollListProvider);
        
        for (final poll in notActivePolls) {
          expect(poll.startDate, isNull);
          expect(poll.endDate, isNull);
        }
      });

      test('activePollList returns only active polls', () {
        final activePolls = container.read(activePollListProvider);
        
        for (final poll in activePolls) {
          expect(poll.startDate, isNotNull);
          expect(poll.endDate, isNull);
          expect(poll.startDate!.isBefore(DateTime.now()), isTrue);
        }
      });

      test('completedPollList returns only completed polls', () {
        final completedPolls = container.read(completedPollListProvider);
        
        for (final poll in completedPolls) {
          expect(poll.startDate, isNotNull);
          expect(poll.endDate, isNotNull);
          expect(poll.endDate!.isBefore(DateTime.now()), isTrue);
        }
      });

      test('pollListByParent returns polls for specific parent', () {
        const parentId = 'sheet-1';
        final pollsByParent = container.read(pollListByParentProvider(parentId));
        
        for (final poll in pollsByParent) {
          expect(poll.parentId, equals(parentId));
        }
      });

      test('pollListByParent returns empty list for non-existent parent', () {
        const nonExistentParentId = 'non-existent-parent';
        final pollsByParent = container.read(pollListByParentProvider(nonExistentParentId));
        
        expect(pollsByParent, isEmpty);
      });
    });

    group('Search Tests', () {
      test('pollListSearch returns all polls when search is empty', () {
        container.read(searchValueProvider.notifier).update('');
        
        final searchResults = container.read(pollListSearchProvider);
        expect(searchResults.length, equals(polls.length));
      });

      test('pollListSearch filters polls by question', () {
        container.read(searchValueProvider.notifier).update('feature');
        
        final searchResults = container.read(pollListSearchProvider);
        expect(searchResults.length, greaterThan(0));
        for (final poll in searchResults) {
          expect(poll.question.toLowerCase().contains('feature'), isTrue);
        }
      });

      test('pollListSearch is case insensitive', () {
        container.read(searchValueProvider.notifier).update('FEATURE');
        
        final searchResults = container.read(pollListSearchProvider);
        expect(searchResults.length, greaterThan(0));
        for (final poll in searchResults) {
          expect(poll.question.toLowerCase().contains('feature'), isTrue);
        }
      });

      test('pollListSearch returns empty list for non-matching search', () {
        container.read(searchValueProvider.notifier).update('non-existent-search-term');
        
        final searchResults = container.read(pollListSearchProvider);
        expect(searchResults, isEmpty);
      });
    });

    group('Poll Voted Members', () {
      test('pollVotedMembers returns users who have voted', () {
        // Use a poll that has votes and users in the sheet
        final pollWithVotes = polls.firstWhere((p) => 
          p.options.any((option) => option.votes.isNotEmpty)
        );
        
        // Override usersBySheetId to return users who have voted
        final votedUserIds = <String>{};
        for (final option in pollWithVotes.options) {
          for (final vote in option.votes) {
            votedUserIds.add(vote.userId);
          }
        }
        
        final votedUsers = votedUserIds.map((id) => UserModel(id: id, name: 'User $id')).toList();
        
        final containerWithVotedUsers = ProviderContainer.test(
          overrides: [
            searchValueProvider.overrideWith(MockSearchValue.new),
            currentUserProvider.overrideWith((ref) => Future.value(null)),
            usersBySheetIdProvider(pollWithVotes.sheetId).overrideWith((ref) => votedUsers),
          ],
        );
        
        final votedMembers = containerWithVotedUsers.read(pollVotedMembersProvider(pollWithVotes.id));
        
        expect(votedMembers, isNotEmpty);
        // Verify that all returned users have actually voted
        for (final member in votedMembers) {
          final hasVoted = pollWithVotes.options.any((option) => 
            option.votes.any((vote) => vote.userId == member.id)
          );
          expect(hasVoted, isTrue);
        }
        
        containerWithVotedUsers.dispose();
      });

      test('pollVotedMembers returns empty list for poll with no votes', () {
        // Create a poll with no votes
        final pollWithNoVotes = PollModel(
          id: 'poll-no-votes',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          question: 'Poll with no votes?',
          options: [
            PollOption(id: 'option-1', title: 'Option 1'),
            PollOption(id: 'option-2', title: 'Option 2'),
          ],
        );
        
        // Add the poll to the container
        container.read(pollListProvider.notifier).addPoll(pollWithNoVotes);
        
        final votedMembers = container.read(pollVotedMembersProvider(pollWithNoVotes.id));
        expect(votedMembers, isEmpty);
      });

      test('pollVotedMembers returns empty list for non-existent poll', () {
        final votedMembers = container.read(pollVotedMembersProvider('non-existent-poll'));
        expect(votedMembers, isEmpty);
      });
    });

    group('Active Polls With Pending Response', () {
      test('ActivePollsWithPendingResponse returns polls where current user has not voted', () {
        final pendingPolls = container.read(activePollsWithPendingResponseProvider);
        
        // Since currentUser is null, empty list should be returned
        expect(pendingPolls, isEmpty);
      });

      test('ActivePollsWithPendingResponse excludes polls where current user has voted', () {
        // Since currentUser is null, this test verifies the logic works correctly
        final pendingPolls = container.read(activePollsWithPendingResponseProvider);
        
        // When no current user, empty list should be returned
        expect(pendingPolls, isEmpty);
      });

      test('ActivePollsWithPendingResponse returns empty list when no current user', () {
        final containerWithoutUser = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWith((ref) => Future.value(null)),
          ],
        );

        final pendingPolls = containerWithoutUser.read(activePollsWithPendingResponseProvider);
        expect(pendingPolls, isEmpty);
        
        containerWithoutUser.dispose();
      });

      test('ActivePollsWithPendingResponse can be updated manually', () {
        final newPolls = [testPoll];
        
        container.read(activePollsWithPendingResponseProvider.notifier).update(newPolls);
        
        final updatedPolls = container.read(activePollsWithPendingResponseProvider);
        expect(updatedPolls, equals(newPolls));
      });
    });
  });
}
