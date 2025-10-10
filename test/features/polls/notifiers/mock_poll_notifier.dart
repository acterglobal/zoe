import 'package:zoe/features/polls/data/polls.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/providers/poll_providers.dart';

class MockPollListNotifier extends PollList {
  final List<String> methodCalls = [];
  final List<Map<String, dynamic>> methodArguments = [];

  @override
  List<PollModel> build() => polls;

  @override
  void updatePollQuestion(String pollId, String question) {
    methodCalls.add('updatePollQuestion');
    methodArguments.add({'pollId': pollId, 'question': question});
  }

  @override
  void deletePoll(String pollId) {
    methodCalls.add('deletePoll');
    methodArguments.add({'pollId': pollId});
  }

  @override
  Future<void> voteOnPoll(String pollId, String optionId, String userId) async {
    methodCalls.add('voteOnPoll');
    methodArguments.add({'pollId': pollId, 'optionId': optionId, 'userId': userId});
  }

  @override
  void updatePollOptionText(String pollId, String optionId, String newTitle) {
    methodCalls.add('updatePollOptionText');
    methodArguments.add({'pollId': pollId, 'optionId': optionId, 'newTitle': newTitle});
  }

  @override
  void deletePollOption(String pollId, String optionId) {
    methodCalls.add('deletePollOption');
    methodArguments.add({'pollId': pollId, 'optionId': optionId});
  }

  @override
  void addPollOption(String pollId, String optionText) {
    methodCalls.add('addPollOption');
    methodArguments.add({'pollId': pollId, 'optionText': optionText});
  }

  @override
  void startPoll(String pollId) {
    methodCalls.add('startPoll');
    methodArguments.add({'pollId': pollId});
  }

  @override
  void endPoll(String pollId) {
    methodCalls.add('endPoll');
    methodArguments.add({'pollId': pollId});
  }

  @override
  void togglePollMultipleChoice(String pollId) {
    methodCalls.add('togglePollMultipleChoice');
    methodArguments.add({'pollId': pollId});
  }

  void reset() {
    methodCalls.clear();
    methodArguments.clear();
  }
}
