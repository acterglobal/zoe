import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/core/preference_service/preferences_service.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';

class PollNotifier extends StateNotifier<List<PollModel>> {
  Ref ref;

  PollNotifier(this.ref) : super(polls);

  Future<void> addPoll({
    required String question,
    required String parentId,
    required String sheetId,
    List<PollOption> options = const [],
    bool isMultipleChoice = false,
    DateTime? endDate,
    int? orderIndex,
  }) async {
    final createdBy = await PreferencesService().getLoginUserId();

    // Create the new poll
    final newPoll = PollModel(
      parentId: parentId,
      question: question,
      sheetId: sheetId,
      orderIndex: orderIndex,
      startDate: DateTime.now(),
      endDate: endDate,
      options: options.isEmpty
          ? [
              PollOption(id: CommonUtils.generateRandomId(), title: ''),
              PollOption(id: CommonUtils.generateRandomId(), title: ''),
            ]
          : options,
      isMultipleChoice: isMultipleChoice,
      createdBy: createdBy,
    );

    state = [...state, newPoll];
  }

  void deletePoll(String pollId) {
    state = state.where((p) => p.id != pollId).toList();
  }

  void updatePollQuestion(String pollId, String question) {
    state = [
      for (final poll in state)
        if (poll.id == pollId) poll.copyWith(question: question) else poll,
    ];
  }

  void updatePollOrderIndex(String pollId, int orderIndex) {
    state = [
      for (final poll in state)
        if (poll.id == pollId) poll.copyWith(orderIndex: orderIndex) else poll,
    ];
  }

  void addPollOption(String pollId, String optionText) {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          poll.copyWith(
            options: [
              ...poll.options,
              PollOption(
                id: CommonUtils.generateRandomId(),
                title: optionText.isEmpty ? '' : optionText,
              ),
            ],
          )
        else
          poll,
    ];
  }

  void updatePollOptionText(String pollId, String optionId, String newTitle) {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          poll.copyWith(
            options: poll.options.map((option) {
              if (option.id == optionId) {
                return option.copyWith(title: newTitle);
              }
              return option;
            }).toList(),
          )
        else
          poll,
    ];
  }

  void deletePollOption(String pollId, String optionId) {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          poll.copyWith(
            options: poll.options
                .where((option) => option.id != optionId)
                .toList(),
          )
        else
          poll,
    ];
  }

  Future<void> voteOnPoll(String pollId, String optionId, String userId) async {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          _updatePollVotes(poll, optionId, userId)
        else
          poll,
    ];
  }

  PollModel _updatePollVotes(PollModel poll, String optionId, String userId) {
    // Check if user has already voted on this option
    final hasVotedOnOption = poll.options.any(
      (option) => option.id == optionId && option.votes.any((vote) => vote.userId == userId),
    );

    if (hasVotedOnOption) {
      // Remove vote if already voted
      return poll.copyWith(
        options: poll.options.map((option) {
          if (option.id == optionId) {
            return option.copyWith(
              votes: option.votes.where((voter) => voter.userId != userId).toList(),
            );
          }
          return option;
        }).toList(),
      );
    } else {
      // Add vote
      if (!poll.isMultipleChoice) {
        // For single choice, remove all previous votes from this user
        final updatedOptions = poll.options.map((option) {
          if (option.votes.any((vote) => vote.userId == userId)) {
            return option.copyWith(
              votes: option.votes.where((vote) => vote.userId != userId).toList(),
            );
          }
          return option;
        }).toList();

        // Add new vote
        final finalOptions = updatedOptions.map((option) {
          if (option.id == optionId) {
            return option.copyWith(
              votes: [...option.votes, Vote(userId: userId)],
            );
          }
          return option;
        }).toList();

        return poll.copyWith(options: finalOptions);
      } else {
        // For multiple choice, just add the vote
        return poll.copyWith(
          options: poll.options.map((option) {
            if (option.id == optionId) {
              return option.copyWith(
                votes: [...option.votes, Vote(userId: userId)],
              );
            }
            return option;
          }).toList(),
        );
      }
    }
  }

  void togglePollMultipleChoice(String pollId) {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          poll.copyWith(isMultipleChoice: !poll.isMultipleChoice)
        else
          poll,
    ];
  }

  void endPoll(String pollId) {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          poll.copyWith(endDate: DateTime.now())
        else
          poll,
    ];
  }

  void startPoll(String pollId) {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          poll.copyWith(startDate: DateTime.now())
        else
          poll,
    ];
  }
}
