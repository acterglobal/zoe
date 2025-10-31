import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

part 'poll_providers.g.dart';

/// Main poll list provider with all poll management functionality
@Riverpod(keepAlive: true)
class PollList extends _$PollList {
  @override
  List<PollModel> build() => polls;

  Future<void> addPoll(PollModel newPoll) async {
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

/// Provider for a single poll by ID
@riverpod
PollModel? poll(Ref ref, String pollId) {
  final pollList = ref.watch(pollListProvider);
  return pollList.where((p) => p.id == pollId).firstOrNull;
}

/// Provider for polls filtered by membership (current user must be a member of the sheet)
@riverpod
List<PollModel> memberPolls(Ref ref) {
  final allPolls = ref.watch(pollListProvider);
  final currentUserId = ref.watch(loggedInUserProvider).value;

  // If no user, show nothing
  if (currentUserId == null || currentUserId.isEmpty) return [];

  // Filter polls by membership of current user in the poll's sheet
  return allPolls.where((p) {
    final sheet = ref.watch(sheetProvider(p.sheetId));
    return sheet?.users.contains(currentUserId) == true;
  }).toList();
}

/// Provider for not active polls (drafts) (filtered by membership)
@riverpod
List<PollModel> notActivePollList(Ref ref) {
  final memberPolls = ref.watch(memberPollsProvider);
  return memberPolls.where((p) => PollUtils.isDraft(p)).toList();
}

/// Provider for active polls (filtered by membership)
@riverpod
List<PollModel> activePollList(Ref ref) {
  final memberPolls = ref.watch(memberPollsProvider);
  return memberPolls.where((p) => PollUtils.isActive(p)).toList();
}

/// Provider for completed polls (filtered by membership)
@riverpod
List<PollModel> completedPollList(Ref ref) {
  final memberPolls = ref.watch(memberPollsProvider);
  return memberPolls.where((p) => PollUtils.isCompleted(p)).toList();
}

/// Provider for searching polls
@riverpod
List<PollModel> pollListSearch(Ref ref) {
  final searchValue = ref.watch(searchValueProvider);
  final memberPolls = ref.watch(memberPollsProvider);

  if (searchValue.isEmpty) return memberPolls;
  return memberPolls
      .where((poll) =>
          poll.question.toLowerCase().contains(searchValue.toLowerCase()))
      .toList();
}

/// Provider for polls filtered by parent ID
@riverpod
List<PollModel> pollListByParent(Ref ref, String parentId) {
  final pollList = ref.watch(pollListProvider);
  return pollList.where((p) => p.parentId == parentId).toList();
}

/// Provider for members who have voted
@riverpod
List<UserModel> pollVotedMembers(Ref ref, String pollId) {
  final poll = ref.watch(pollProvider(pollId));
  if (poll == null) return [];
  
  final members = ref.watch(usersBySheetIdProvider(poll.sheetId));
  
  return members.where((member) {
    return poll.options.any((option) => 
      option.votes.any((vote) => vote.userId == member.id)
    );
  }).toList();
}

/// Provider for active polls with pending response from current user (filtered by membership)
@riverpod
class ActivePollsWithPendingResponse extends _$ActivePollsWithPendingResponse {
  @override
  List<PollModel> build() {
    final activePollList = ref.watch(activePollListProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    
    if (currentUserAsync.value == null) return [];
    final currentUserId = currentUserAsync.value!.id;
    
    return activePollList.where((poll) {
      // Check if user hasn't voted in any option
      final hasVoted = poll.options.any(
        (option) => option.votes.any((vote) => vote.userId == currentUserId)
      );
    
      return !hasVoted;
    }).toList();
  }

  void update(List<PollModel> value) => state = value;
}