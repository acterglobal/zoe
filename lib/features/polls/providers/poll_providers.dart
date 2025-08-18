import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/notifiers/poll_notifier.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';

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

final pollVotersProvider = Provider.family<List<String>, String>((ref, pollId) {
  final poll = ref.watch(pollProvider(pollId));
  return poll?.participants ?? [];
});