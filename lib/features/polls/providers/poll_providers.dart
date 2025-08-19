import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/notifiers/poll_notifier.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

final pollListProvider = StateNotifierProvider<PollNotifier, List<PollModel>>(
  (ref) => PollNotifier(ref),
);

final pollProvider = Provider.family<PollModel?, String>((ref, pollId) {
  final pollList = ref.watch(pollListProvider);
  return pollList.where((p) => p.id == pollId).firstOrNull;
});

final notActivePollListProvider = Provider<List<PollModel>>((ref) {
  final pollList = ref.watch(pollListProvider);
  return pollList.where((p) => PollUtils.isDraft(p)).toList();
});

final activePollListProvider = Provider<List<PollModel>>((ref) {
  final pollList = ref.watch(pollListProvider);
  return pollList.where((p) => PollUtils.isActive(p)).toList();
});

final completedPollListProvider = Provider<List<PollModel>>((ref) {
  final pollList = ref.watch(pollListProvider);
  return pollList.where((p) => PollUtils.isCompleted(p)).toList();
});

final pollListSearchProvider = Provider<List<PollModel>>((ref) {
  final pollList = ref.watch(pollListProvider);
  final searchValue = ref.watch(searchValueProvider);
  if (searchValue.isEmpty) return pollList;
  return pollList.where((poll) {
    return poll.question.toLowerCase().contains(searchValue.toLowerCase());
  }).toList();
});

final pollTotalVotesBySheetIdProvider = Provider.family<int, String>((
  ref,
  sheetId,
) {
  final pollList = ref.watch(pollListProvider);
  return pollList
      .where((p) => p.sheetId == sheetId)
      .fold(0, (sum, poll) => sum + poll.totalVotes);
});

final pollVotingDataProvider = Provider.family<Map<String, dynamic>, String>((
  ref,
  pollId,
) {
  final poll = ref.watch(pollProvider(pollId));
  if (poll == null) return {};

  final sheetMembers = ref.watch(usersBySheetIdProvider(poll.sheetId));

  // count how many members voted
  int membersVoted = 0;
  final Map<String, List<String>> memberVotes = {};
  
  for (final member in sheetMembers) {
    memberVotes[member.id] = [];
    bool hasVoted = false;
    for (final option in poll.options) {
      if (option.votes.any((vote) => vote.userId == member.id)) {
        hasVoted = true;
        memberVotes[member.id]?.add(option.title);
      }
    }
    if (hasVoted) membersVoted++;
  }

  return {
    'totalMembers': sheetMembers.length,
    'membersVoted': membersVoted,
    'participationRate': sheetMembers.isNotEmpty
        ? (membersVoted / sheetMembers.length * 100)
        : 0.0,
    'memberVotingStatus': sheetMembers.map((member) {
      final votes = memberVotes[member.id] ?? [];
      return MapEntry(member.id, votes);
    }).toList(),
  };
});
