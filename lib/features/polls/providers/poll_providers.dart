import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/notifiers/poll_notifier.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/users/models/user_model.dart';

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

// Provider for sheet members of a poll
final pollSheetMembersProvider = Provider.family<List<UserModel>, String>((ref, pollId) {
  final poll = ref.watch(pollProvider(pollId));
  if (poll == null) return [];
  
  return ref.watch(usersBySheetIdProvider(poll.sheetId));
});

// Provider for members who have voted
final pollVotedMembersProvider = Provider.family<List<UserModel>, String>((ref, pollId) {
  final poll = ref.watch(pollProvider(pollId));
  final members = ref.watch(pollSheetMembersProvider(pollId));
  
  if (poll == null) return [];
  
  return members.where((member) {
    return poll.options.any((option) => 
      option.votes.any((vote) => vote.userId == member.id)
    );
  }).toList();
});

// Provider for poll sheet member IDs
final pollSheetMemberIdsProvider = Provider.family<List<String>, String>((ref, pollId) {
  final members = ref.watch(pollSheetMembersProvider(pollId));
  final List<String> memberIds = [];
  
  for (final member in members) {
    memberIds.add(member.id);
  }
  
  return memberIds;
});

// Provider for poll sheet member IDs who have voted
final pollVotedMemberIdsProvider = Provider.family<List<String>, String>((ref, pollId) {
  final votedMembers = ref.watch(pollVotedMembersProvider(pollId));
  final List<String> votedMemberIds = [];
  
  for (final member in votedMembers) {
    votedMemberIds.add(member.id);
  }
  
  return votedMemberIds;
});




