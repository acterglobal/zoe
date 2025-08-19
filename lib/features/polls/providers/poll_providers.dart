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

final pollVotesBySheetMembersProvider = Provider.family<Map<String, List<String>>, String>((ref, pollId) {
  final poll = ref.watch(pollProvider(pollId));
  if (poll == null) return {};
  
  final sheetMembers = ref.watch(usersBySheetIdProvider(poll.sheetId));
  final Map<String, List<String>> memberVotes = {};
  
  for (final member in sheetMembers) {
    memberVotes[member.id] = [];
  }
  
  for (final option in poll.options) {
    for (final vote in option.votes) {
      if (memberVotes.containsKey(vote.userId)) {
        memberVotes[vote.userId]?.add(option.title);
      }
    }
  }
  
  return memberVotes;
});

// Provider to get voting status for each sheet member is voted or not
final pollMemberVotingStatusProvider = Provider.family<List<MapEntry<String, List<String>>>, String>((ref, pollId) {
  final memberVotes = ref.watch(pollVotesBySheetMembersProvider(pollId));
  final sheetMembers = ref.watch(usersBySheetIdProvider(ref.watch(pollProvider(pollId))?.sheetId ?? ''));
  
  return sheetMembers.map((member) {
    final votes = memberVotes[member.id] ?? [];
    return MapEntry(member.id, votes);
  }).toList();
});
