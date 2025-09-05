import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/notifiers/poll_notifier.dart';
import 'package:zoe/features/users/models/user_model.dart';
import '../../features/users/mock_user_providers.dart';

class MockPollNotifier extends PollNotifier {
  MockPollNotifier(super.ref);

  void setPolls(List<PollModel> polls) {
    state = polls;
  }

  @override
  void togglePollMultipleChoice(String pollId) {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          poll.copyWith(isMultipleChoice: !poll.isMultipleChoice)
        else
          poll,
    ];
  }

  @override
  void updatePollQuestion(String pollId, String question) {
    state = [
      for (final poll in state)
        if (poll.id == pollId) poll.copyWith(question: question) else poll,
    ];
  }

  @override
  void addPollOption(String pollId, String optionText) {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          poll.copyWith(
            options: [
              ...poll.options,
              PollOption(
                id: DateTime.now().toString(),
                title: optionText.isEmpty ? '' : optionText,
              ),
            ],
          )
        else
          poll,
    ];
  }

  @override
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

  @override
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

  @override
  Future<void> voteOnPoll(String pollId, String optionId, String userId) async {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          _updatePollVotes(poll, optionId, userId)
        else
          poll,
    ];
  }

  @override
  void startPoll(String pollId) {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          poll.copyWith(startDate: DateTime.now())
        else
          poll,
    ];
  }

  @override
  void endPoll(String pollId) {
    state = [
      for (final poll in state)
        if (poll.id == pollId)
          poll.copyWith(endDate: DateTime.now())
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
}

final mockPollListProvider = StateNotifierProvider<PollNotifier, List<PollModel>>(
  (ref) => MockPollNotifier(ref),
);

final mockPollProvider = Provider.family<PollModel?, String>((ref, pollId) {
  final pollList = ref.watch(mockPollListProvider);
  return pollList.where((p) => p.id == pollId).firstOrNull;
}, dependencies: [mockPollListProvider]);

final mockNotActivePollListProvider = Provider<List<PollModel>>((ref) {
  final pollList = ref.watch(mockPollListProvider);
  return pollList.where((p) => p.startDate == null || p.startDate!.isAfter(DateTime.now())).toList();
}, dependencies: [mockPollListProvider]);

final mockActivePollListProvider = Provider<List<PollModel>>((ref) {
  final pollList = ref.watch(mockPollListProvider);
  final now = DateTime.now();
  return pollList.where((p) {
    if (p.startDate == null || p.endDate == null) return false;
    return p.startDate!.isBefore(now) && p.endDate!.isAfter(now);
  }).toList();
}, dependencies: [mockPollListProvider]);

final mockCompletedPollListProvider = Provider<List<PollModel>>((ref) {
  final pollList = ref.watch(mockPollListProvider);
  return pollList.where((p) => p.endDate != null && p.endDate!.isBefore(DateTime.now())).toList();
}, dependencies: [mockPollListProvider]);

// Provider for members who have voted
final mockPollVotedMembersProvider = Provider.family<List<UserModel>, String>((ref, pollId) {
  final poll = ref.watch(mockPollProvider(pollId));
  if (poll == null) return [];
  
  final members = ref.watch(mockUsersBySheetIdProvider(poll.sheetId));
  
  return members.where((member) {
    return poll.options.any((option) => 
      option.votes.any((vote) => vote.userId == member.id)
    );
  }).toList();
}, dependencies: [mockPollProvider, mockUsersBySheetIdProvider]);
