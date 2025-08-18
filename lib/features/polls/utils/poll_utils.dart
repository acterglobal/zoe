import 'package:zoe/features/polls/models/poll_model.dart';

enum PollStatus {
  drafted,
  active,
  completed;

  String get name => switch (this) {
    drafted => 'Drafted',
    active => 'Active',
    completed => 'Completed',
  };
}

class PollUtils {
  static PollStatus getPollStatus(PollModel poll) {
    final now = DateTime.now();

    if (poll.startDate == null && poll.endDate == null) {
      return PollStatus.drafted;
    } else if (poll.startDate != null && poll.endDate == null) {
      return now.isAfter(poll.startDate!)
          ? PollStatus.active
          : PollStatus.drafted;
    } else if (poll.startDate != null && poll.endDate != null) {
      if (now.isBefore(poll.startDate!)) {
        return PollStatus.drafted;
      } else if (now.isAfter(poll.endDate!)) {
        return PollStatus.completed;
      } else {
        return PollStatus.active;
      }
    }
    return PollStatus.drafted;
  }

  /// Checks if a poll has started
  static bool isStarted(PollModel poll) {
    return getPollStatus(poll) == PollStatus.active;
  }

  /// Checks if a poll has not started yet
  static bool isNotStarted(PollModel poll) {
    return getPollStatus(poll) == PollStatus.drafted;
  }

  /// Checks if a poll has ended
  static bool isEnded(PollModel poll) {
    return getPollStatus(poll) == PollStatus.completed;
  }
}
