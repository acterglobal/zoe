import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

enum PollStatus {
  draft,
  active,
  completed;

  String get name => switch (this) {
    draft => 'Draft',
    active => 'Active',
    completed => 'Completed',
  };
}

class PollUtils {
  static PollStatus getPollStatus(PollModel poll) {
    final now = DateTime.now();

    if (poll.startDate == null && poll.endDate == null) {
      return PollStatus.draft;
    } else if (poll.startDate != null && poll.endDate == null) {
      return now.isAfter(poll.startDate!)
          ? PollStatus.active
          : PollStatus.draft;
    } else if (poll.startDate != null && poll.endDate != null) {
      if (now.isBefore(poll.startDate!)) {
        return PollStatus.draft;
      } else if (now.isAfter(poll.endDate!)) {
        return PollStatus.completed;
      } else {
        return PollStatus.active;
      }
    }
    return PollStatus.draft;
  }

  /// Checks if a poll has started
  static bool isActive(PollModel poll) {
    return getPollStatus(poll) == PollStatus.active;
  }

  /// Checks if a poll has not started yet
  static bool isDraft(PollModel poll) {
    return getPollStatus(poll) == PollStatus.draft;
  }

  /// Checks if a poll has ended
  static bool isCompleted(PollModel poll) {
    return getPollStatus(poll) == PollStatus.completed;
  }

  /// Get a color from option index
  static Color getColorFromOptionIndex(int optionIndex) {
    final colors = [
      Colors.pink,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.indigo,
      Colors.teal,
      Colors.amber,
      Colors.deepPurple,
      Colors.brown,
      Colors.cyan,
      Colors.deepOrange,
      Colors.lightBlue,
      Colors.lightGreen,
    ];

    // Color based on option index
    return colors[optionIndex % colors.length];
  }

  /// Get a color from option ID
  static Color getColorFromOptionId(String optionId, PollModel poll) {
    final optionIndex = poll.options.indexWhere((option) => option.id == optionId);
    return optionIndex >= 0 ? getColorFromOptionIndex(optionIndex) : Colors.grey;
  }

  /// Get the maximum number of votes from all poll options
  static int getMaxVotes(PollModel poll) {
    int maxVotes = 0;
    for (final option in poll.options) {
      if (option.votes.length > maxVotes) {
        maxVotes = option.votes.length;
      }
    }
    return maxVotes;
  }

  /// Check if a poll option has the maximum votes
  static bool hasMaxVotes(PollOption pollOption, PollModel poll) {
    return pollOption.votes.length == getMaxVotes(poll);
  }

  /// Calculate the percentage of votes for a poll option
  static double calculateVotePercentage(PollOption pollOption, PollModel poll) {
    final totalVotes = poll.totalVotes;
    if (totalVotes > 0) {
      return (pollOption.votes.length / totalVotes) * 100;
    }
    return 0.0;
  }

  /// Check if a user has voted on a poll option
  static bool isUserVoted(PollModel poll, PollOption pollOption, WidgetRef ref) {
    final currentUserId = ref.watch(loggedInUserProvider).value;
    final isVoted =
        currentUserId != null &&
        pollOption.votes.any((vote) => vote.userId == currentUserId); 
    return isVoted;
  }
}
