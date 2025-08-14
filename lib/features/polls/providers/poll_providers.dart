import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/polls/models/poll_model.dart';
import 'package:zoey/features/polls/notifiers/poll_notifier.dart';

final pollListProvider = StateNotifierProvider<PollNotifier, List<PollModel>>(
  (ref) => PollNotifier(ref),
);

final pollProvider = Provider.family<PollModel?, String>((ref, pollId) {
  final pollList = ref.watch(pollListProvider);
  return pollList.where((p) => p.id == pollId).firstOrNull;
});
