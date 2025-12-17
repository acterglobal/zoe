import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';

void main() {
  group('PollList Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    tearDown(() {
      container.dispose();
    });

    group('addPoll', () {
      test('should add a new poll to the state', () async {
        final newPoll = PollModel(
          id: 'new-poll-id',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          question: 'What is your favorite color?',
          options: [
            PollOption(id: 'option-1', title: 'Red'),
            PollOption(id: 'option-2', title: 'Blue'),
          ],
          createdBy: 'test-user',
        );

        final initialLength = container.read(pollListProvider).length;
        await container.read(pollListProvider.notifier).addPoll(newPoll);

        final updatedList = container.read(pollListProvider);
        expect(updatedList.length, equals(initialLength + 1));
        expect(updatedList.last.id, equals('new-poll-id'));
        expect(
          updatedList.last.question,
          equals('What is your favorite color?'),
        );
      });

      test('should maintain existing polls when adding new poll', () async {
        final existingPollIds = container
            .read(pollListProvider)
            .map((p) => p.id)
            .toList();
        final newPoll = PollModel(
          id: 'another-new-poll',
          sheetId: 'sheet-1',
          parentId: 'sheet-1',
          question: 'Test question',
          options: [PollOption(id: 'option-1', title: 'Test option')],
          createdBy: 'test-user',
        );

        await container.read(pollListProvider.notifier).addPoll(newPoll);

        final updatedList = container.read(pollListProvider);
        for (final id in existingPollIds) {
          expect(updatedList.any((p) => p.id == id), isTrue);
        }
        expect(updatedList.any((p) => p.id == 'another-new-poll'), isTrue);
      });
    });

    group('deletePoll', () {
      test('should remove poll with given id', () {
        final pollToDelete = container.read(pollListProvider).first;
        final initialLength = container.read(pollListProvider).length;

        container.read(pollListProvider.notifier).deletePoll(pollToDelete.id);

        final updatedList = container.read(pollListProvider);
        expect(updatedList.length, equals(initialLength - 1));
        expect(updatedList.any((p) => p.id == pollToDelete.id), isFalse);
      });

      test('should not affect other polls when deleting', () {
        final pollToDelete = container.read(pollListProvider).first;
        final otherPollIds = container
            .read(pollListProvider)
            .where((p) => p.id != pollToDelete.id)
            .map((p) => p.id)
            .toList();

        container.read(pollListProvider.notifier).deletePoll(pollToDelete.id);

        final updatedList = container.read(pollListProvider);
        for (final id in otherPollIds) {
          expect(updatedList.any((p) => p.id == id), isTrue);
        }
      });
    });

    group('updatePollQuestion', () {
      test('should update question for specific poll', () {
        final pollToUpdate = container.read(pollListProvider).first;
        const newQuestion = 'Updated question text';

        container
            .read(pollListProvider.notifier)
            .updatePollQuestion(pollToUpdate.id, newQuestion);

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == pollToUpdate.id,
        );
        expect(updatedPoll.question, equals(newQuestion));
      });

      test('should not affect other polls when updating question', () {
        final pollToUpdate = container.read(pollListProvider).first;
        final otherPolls = container
            .read(pollListProvider)
            .where((p) => p.id != pollToUpdate.id)
            .toList();

        container
            .read(pollListProvider.notifier)
            .updatePollQuestion(pollToUpdate.id, 'New question');

        final updatedList = container.read(pollListProvider);
        for (final poll in otherPolls) {
          final unchangedPoll = updatedList.firstWhere((p) => p.id == poll.id);
          expect(unchangedPoll.question, equals(poll.question));
        }
      });
    });

    group('updatePollOrderIndex', () {
      test('should update order index for specific poll', () {
        final pollToUpdate = container.read(pollListProvider).first;
        const newOrderIndex = 999;

        container
            .read(pollListProvider.notifier)
            .updatePollOrderIndex(pollToUpdate.id, newOrderIndex);

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == pollToUpdate.id,
        );
        expect(updatedPoll.orderIndex, equals(newOrderIndex));
      });

      test('should not affect other polls when updating order index', () {
        final pollToUpdate = container.read(pollListProvider).first;
        final otherPolls = container
            .read(pollListProvider)
            .where((p) => p.id != pollToUpdate.id)
            .toList();

        container
            .read(pollListProvider.notifier)
            .updatePollOrderIndex(pollToUpdate.id, 999);

        final updatedList = container.read(pollListProvider);
        for (final poll in otherPolls) {
          final unchangedPoll = updatedList.firstWhere((p) => p.id == poll.id);
          expect(unchangedPoll.orderIndex, equals(poll.orderIndex));
        }
      });
    });

    group('addPollOption', () {
      test('should add new option to specific poll', () {
        final pollToUpdate = container.read(pollListProvider).first;
        const newOptionText = 'New option';
        final initialOptionCount = pollToUpdate.options.length;

        container
            .read(pollListProvider.notifier)
            .addPollOption(pollToUpdate.id, newOptionText);

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == pollToUpdate.id,
        );
        expect(updatedPoll.options.length, equals(initialOptionCount + 1));
        expect(updatedPoll.options.last.title, equals(newOptionText));
        expect(updatedPoll.options.last.id, isA<String>());
      });

      test('should handle empty option text', () {
        final pollToUpdate = container.read(pollListProvider).first;
        final initialOptionCount = pollToUpdate.options.length;

        container
            .read(pollListProvider.notifier)
            .addPollOption(pollToUpdate.id, '');

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == pollToUpdate.id,
        );
        expect(updatedPoll.options.length, equals(initialOptionCount + 1));
        expect(updatedPoll.options.last.title, equals(''));
      });

      test('should not affect other polls when adding option', () {
        final pollToUpdate = container.read(pollListProvider).first;
        final otherPolls = container
            .read(pollListProvider)
            .where((p) => p.id != pollToUpdate.id)
            .toList();

        container
            .read(pollListProvider.notifier)
            .addPollOption(pollToUpdate.id, 'New option');

        final updatedList = container.read(pollListProvider);
        for (final poll in otherPolls) {
          final unchangedPoll = updatedList.firstWhere((p) => p.id == poll.id);
          expect(unchangedPoll.options.length, equals(poll.options.length));
        }
      });
    });

    group('updatePollOptionText', () {
      test('should update option text for specific poll and option', () {
        final pollToUpdate = container.read(pollListProvider).first;
        final optionToUpdate = pollToUpdate.options.first;
        const newTitle = 'Updated option text';

        container
            .read(pollListProvider.notifier)
            .updatePollOptionText(pollToUpdate.id, optionToUpdate.id, newTitle);

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == pollToUpdate.id,
        );
        final updatedOption = updatedPoll.options.firstWhere(
          (o) => o.id == optionToUpdate.id,
        );
        expect(updatedOption.title, equals(newTitle));
      });

      test('should not affect other options when updating one', () {
        final pollToUpdate = container.read(pollListProvider).first;
        final optionToUpdate = pollToUpdate.options.first;
        final otherOptions = pollToUpdate.options
            .where((o) => o.id != optionToUpdate.id)
            .toList();

        container
            .read(pollListProvider.notifier)
            .updatePollOptionText(
              pollToUpdate.id,
              optionToUpdate.id,
              'New title',
            );

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == pollToUpdate.id,
        );
        for (final option in otherOptions) {
          final unchangedOption = updatedPoll.options.firstWhere(
            (o) => o.id == option.id,
          );
          expect(unchangedOption.title, equals(option.title));
        }
      });
    });

    group('deletePollOption', () {
      test('should remove option from specific poll', () {
        final pollToUpdate = container.read(pollListProvider).first;
        final optionToDelete = pollToUpdate.options.first;
        final initialOptionCount = pollToUpdate.options.length;

        container
            .read(pollListProvider.notifier)
            .deletePollOption(pollToUpdate.id, optionToDelete.id);

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == pollToUpdate.id,
        );
        expect(updatedPoll.options.length, equals(initialOptionCount - 1));
        expect(
          updatedPoll.options.any((o) => o.id == optionToDelete.id),
          isFalse,
        );
      });

      test('should not affect other options when deleting one', () {
        final pollToUpdate = container.read(pollListProvider).first;
        final optionToDelete = pollToUpdate.options.first;
        final otherOptions = pollToUpdate.options
            .where((o) => o.id != optionToDelete.id)
            .toList();

        container
            .read(pollListProvider.notifier)
            .deletePollOption(pollToUpdate.id, optionToDelete.id);

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == pollToUpdate.id,
        );
        for (final option in otherOptions) {
          expect(updatedPoll.options.any((o) => o.id == option.id), isTrue);
        }
      });
    });

    group('voteOnPoll', () {
      test('should add vote to option for single choice poll', () async {
        final singleChoicePoll = container
            .read(pollListProvider)
            .firstWhere((p) => !p.isMultipleChoice);
        final optionToVote = singleChoicePoll.options.first;
        const userId = 'test-user';

        await container
            .read(pollListProvider.notifier)
            .voteOnPoll(singleChoicePoll.id, optionToVote.id, userId);

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == singleChoicePoll.id,
        );
        final votedOption = updatedPoll.options.firstWhere(
          (o) => o.id == optionToVote.id,
        );
        expect(votedOption.votes.any((v) => v.userId == userId), isTrue);
      });

      test(
        'should remove existing vote when voting again on same option',
        () async {
          final pollWithVotes = container
              .read(pollListProvider)
              .firstWhere((p) => p.options.any((o) => o.votes.isNotEmpty));
          final optionWithVotes = pollWithVotes.options.firstWhere(
            (o) => o.votes.isNotEmpty,
          );
          final existingVote = optionWithVotes.votes.first;

          await container
              .read(pollListProvider.notifier)
              .voteOnPoll(
                pollWithVotes.id,
                optionWithVotes.id,
                existingVote.userId,
              );

          final updatedList = container.read(pollListProvider);
          final updatedPoll = updatedList.firstWhere(
            (p) => p.id == pollWithVotes.id,
          );
          final updatedOption = updatedPoll.options.firstWhere(
            (o) => o.id == optionWithVotes.id,
          );
          expect(
            updatedOption.votes.any((v) => v.userId == existingVote.userId),
            isFalse,
          );
        },
      );

      test(
        'should remove previous votes when voting on different option in single choice poll',
        () async {
          final singleChoicePoll = container
              .read(pollListProvider)
              .firstWhere((p) => !p.isMultipleChoice);
          final firstOption = singleChoicePoll.options.first;
          final secondOption = singleChoicePoll.options[1];
          const userId = 'test-user';

          // Vote on first option
          await container
              .read(pollListProvider.notifier)
              .voteOnPoll(singleChoicePoll.id, firstOption.id, userId);

          // Vote on second option
          await container
              .read(pollListProvider.notifier)
              .voteOnPoll(singleChoicePoll.id, secondOption.id, userId);

          final updatedList = container.read(pollListProvider);
          final updatedPoll = updatedList.firstWhere(
            (p) => p.id == singleChoicePoll.id,
          );
          final updatedFirstOption = updatedPoll.options.firstWhere(
            (o) => o.id == firstOption.id,
          );
          final updatedSecondOption = updatedPoll.options.firstWhere(
            (o) => o.id == secondOption.id,
          );

          expect(
            updatedFirstOption.votes.any((v) => v.userId == userId),
            isFalse,
          );
          expect(
            updatedSecondOption.votes.any((v) => v.userId == userId),
            isTrue,
          );
        },
      );

      test(
        'should allow multiple votes on different options in multiple choice poll',
        () async {
          final multipleChoicePoll = container
              .read(pollListProvider)
              .firstWhere((p) => p.isMultipleChoice);
          final firstOption = multipleChoicePoll.options.first;
          final secondOption = multipleChoicePoll.options[1];
          const userId = 'test-user';

          // Vote on first option
          await container
              .read(pollListProvider.notifier)
              .voteOnPoll(multipleChoicePoll.id, firstOption.id, userId);

          // Vote on second option
          await container
              .read(pollListProvider.notifier)
              .voteOnPoll(multipleChoicePoll.id, secondOption.id, userId);

          final updatedList = container.read(pollListProvider);
          final updatedPoll = updatedList.firstWhere(
            (p) => p.id == multipleChoicePoll.id,
          );
          final updatedFirstOption = updatedPoll.options.firstWhere(
            (o) => o.id == firstOption.id,
          );
          final updatedSecondOption = updatedPoll.options.firstWhere(
            (o) => o.id == secondOption.id,
          );

          expect(
            updatedFirstOption.votes.any((v) => v.userId == userId),
            isTrue,
          );
          expect(
            updatedSecondOption.votes.any((v) => v.userId == userId),
            isTrue,
          );
        },
      );
    });

    group('togglePollMultipleChoice', () {
      test('should toggle multiple choice setting for specific poll', () {
        final pollToToggle = container.read(pollListProvider).first;
        final initialMultipleChoice = pollToToggle.isMultipleChoice;

        container
            .read(pollListProvider.notifier)
            .togglePollMultipleChoice(pollToToggle.id);

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == pollToToggle.id,
        );
        expect(updatedPoll.isMultipleChoice, equals(!initialMultipleChoice));
      });

      test('should not affect other polls when toggling multiple choice', () {
        final pollToToggle = container.read(pollListProvider).first;
        final otherPolls = container
            .read(pollListProvider)
            .where((p) => p.id != pollToToggle.id)
            .toList();

        container
            .read(pollListProvider.notifier)
            .togglePollMultipleChoice(pollToToggle.id);

        final updatedList = container.read(pollListProvider);
        for (final poll in otherPolls) {
          final unchangedPoll = updatedList.firstWhere((p) => p.id == poll.id);
          expect(unchangedPoll.isMultipleChoice, equals(poll.isMultipleChoice));
        }
      });
    });

    group('endPoll', () {
      test('should set end date for specific poll', () {
        final pollToEnd = container.read(pollListProvider).first;
        final beforeEnd = DateTime.now();

        container.read(pollListProvider.notifier).endPoll(pollToEnd.id);

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere((p) => p.id == pollToEnd.id);
        expect(updatedPoll.endDate, isNotNull);
        expect(
          updatedPoll.endDate!.isAfter(beforeEnd) ||
              updatedPoll.endDate!.isAtSameMomentAs(beforeEnd),
          isTrue,
        );
      });

      test('should not affect other polls when ending one', () {
        final pollToEnd = container.read(pollListProvider).first;
        final otherPolls = container
            .read(pollListProvider)
            .where((p) => p.id != pollToEnd.id)
            .toList();

        container.read(pollListProvider.notifier).endPoll(pollToEnd.id);

        final updatedList = container.read(pollListProvider);
        for (final poll in otherPolls) {
          final unchangedPoll = updatedList.firstWhere((p) => p.id == poll.id);
          expect(unchangedPoll.endDate, equals(poll.endDate));
        }
      });
    });

    /*group('startPoll', () {
      test('should set start date for specific poll', () {
        final pollToStart = container.read(pollListProvider).first;
        final beforeStart = DateTime.now();

        container.read(pollListProvider.notifier).startPoll(pollToStart);

        final updatedList = container.read(pollListProvider);
        final updatedPoll = updatedList.firstWhere(
          (p) => p.id == pollToStart.id,
        );
        expect(updatedPoll.startDate, isNotNull);
        expect(
          updatedPoll.startDate!.isAfter(beforeStart) ||
              updatedPoll.startDate!.isAtSameMomentAs(beforeStart),
          isTrue,
        );
      });

      test('should not affect other polls when starting one', () {
        final pollToStart = container.read(pollListProvider).first;
        final otherPolls = container
            .read(pollListProvider)
            .where((p) => p.id != pollToStart.id)
            .toList();

        container.read(pollListProvider.notifier).startPoll(pollToStart);

        final updatedList = container.read(pollListProvider);
        for (final poll in otherPolls) {
          final unchangedPoll = updatedList.firstWhere((p) => p.id == poll.id);
          expect(unchangedPoll.startDate, equals(poll.startDate));
        }
      });
    });*/

    group('Vote Management Complex Scenarios', () {
      test(
        'should handle vote removal correctly in single choice poll',
        () async {
          final singleChoicePoll = container
              .read(pollListProvider)
              .firstWhere((p) => !p.isMultipleChoice);
          final option = singleChoicePoll.options.first;
          const userId = 'test-user';

          // Add vote
          await container
              .read(pollListProvider.notifier)
              .voteOnPoll(singleChoicePoll.id, option.id, userId);

          // Remove vote by voting again
          await container
              .read(pollListProvider.notifier)
              .voteOnPoll(singleChoicePoll.id, option.id, userId);

          final updatedList = container.read(pollListProvider);
          final updatedPoll = updatedList.firstWhere(
            (p) => p.id == singleChoicePoll.id,
          );
          final updatedOption = updatedPoll.options.firstWhere(
            (o) => o.id == option.id,
          );
          expect(updatedOption.votes.any((v) => v.userId == userId), isFalse);
        },
      );

      test(
        'should handle vote removal correctly in multiple choice poll',
        () async {
          final multipleChoicePoll = container
              .read(pollListProvider)
              .firstWhere((p) => p.isMultipleChoice);
          final option = multipleChoicePoll.options.first;
          const userId = 'test-user';

          // Add vote
          await container
              .read(pollListProvider.notifier)
              .voteOnPoll(multipleChoicePoll.id, option.id, userId);

          // Remove vote by voting again
          await container
              .read(pollListProvider.notifier)
              .voteOnPoll(multipleChoicePoll.id, option.id, userId);

          final updatedList = container.read(pollListProvider);
          final updatedPoll = updatedList.firstWhere(
            (p) => p.id == multipleChoicePoll.id,
          );
          final updatedOption = updatedPoll.options.firstWhere(
            (o) => o.id == option.id,
          );
          expect(updatedOption.votes.any((v) => v.userId == userId), isFalse);
        },
      );
    });
  });
}
