import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';

PollModel getPollByIndex(ProviderContainer container, {int index = 0}) {
  final pollList = container.read(pollListProvider);
  if (pollList.isEmpty) fail('Poll list is empty');
  if (index < 0 || index >= pollList.length) {
    fail('Poll index is out of bounds');
  }
  return pollList[index];
}

