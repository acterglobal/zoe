import 'package:zoe/features/polls/models/poll_model.dart';

enum PollStatus {
  notStarted,
  started,
  ended;

  String get name => switch (this) {
    notStarted => 'Not Started',
    started => 'Started',
    ended => 'Ended',
  };
}

class PollUtils {
  static PollStatus getPollStatus(PollModel poll) {
    final now = DateTime.now();

    if (poll.startDate == null && poll.endDate == null) {
      return PollStatus.notStarted;
    } else if (poll.startDate != null && poll.endDate == null) {
      return now.isAfter(poll.startDate!)
          ? PollStatus.started
          : PollStatus.notStarted;
    } else if (poll.startDate != null && poll.endDate != null) {
      if (now.isBefore(poll.startDate!)) {
        return PollStatus.notStarted;
      } else if (now.isAfter(poll.endDate!)) {
        return PollStatus.ended;
      } else {
        return PollStatus.started;
      }
    }
    return PollStatus.notStarted;
  }

  /// Checks if a poll has started
  static bool isStarted(PollModel poll) {
    return getPollStatus(poll) == PollStatus.started;
  }

  /// Checks if a poll has not started yet
  static bool isNotStarted(PollModel poll) {
    return getPollStatus(poll) == PollStatus.notStarted;
  }

  /// Checks if a poll has ended
  static bool isEnded(PollModel poll) {
    return getPollStatus(poll) == PollStatus.ended;
  }
}
