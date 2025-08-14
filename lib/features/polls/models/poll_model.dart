import 'package:zoey/features/content/models/content_model.dart';

class PollOption {
  final String id;
  final String title;
  final int votes;
  final List<String> voters;

  const PollOption({
    required this.id,
    required this.title,
    this.votes = 0,
    this.voters = const [],
  });

  PollOption copyWith({
    String? id,
    String? title,
    int? votes,
    List<String>? voters,
  }) {
    return PollOption(
      id: id ?? this.id,
      title: title ?? this.title,
      votes: votes ?? this.votes,
      voters: voters ?? this.voters,
    );
  }
}

enum PollStatus { notStarted, started, ended }

class PollModel extends ContentModel {
  /// PollModel properties
  final String question; // The main poll question
  final List<PollOption> options;
  final DateTime startDate; // When the poll becomes active
  final DateTime? endDate; // When the poll expires
  final bool isMultipleChoice;
  final List<String> participants;
  final PollStatus status;

  PollModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,
    super.createdBy,

    /// PollModel properties
    required this.question,
    required this.options,
    required this.startDate,
    this.endDate,
    this.isMultipleChoice = false,
    this.participants = const [],
    this.status = PollStatus.notStarted,
  }) : super(type: ContentType.poll, emoji: '📊', title: question);

  PollModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,
    String? createdBy,

    /// PollModel properties
    String? question,
    List<PollOption>? options,
    DateTime? startDate,
    DateTime? endDate,
    bool? isMultipleChoice,
    List<String>? participants,
    PollStatus? status,
  }) {
    return PollModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      orderIndex: orderIndex ?? this.orderIndex,
      createdBy: createdBy ?? this.createdBy,

      /// PollModel properties
      question: question ?? this.question,
      options: options ?? this.options,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isMultipleChoice: isMultipleChoice ?? this.isMultipleChoice,
      participants: participants ?? this.participants,
      status: status ?? this.status,
    );
  }

  /// Get total votes across all options
  int get totalVotes => options.fold(0, (sum, option) => sum + option.votes);

  /// Check if poll has expired
  bool get hasExpired => endDate != null && DateTime.now().isAfter(endDate!);

  /// Check if poll is started
  bool get isStarted => status == PollStatus.started && !hasExpired;

  /// Check if poll is not started
  bool get isNotStarted => status == PollStatus.notStarted;

  /// Check if poll is ended
  bool get isEnded => status == PollStatus.ended;

  /// Get percentage for an option
  double getOptionPercentage(String optionId) {
    if (totalVotes == 0) return 0.0;
    final option = options.firstWhere((opt) => opt.id == optionId);
    return (option.votes / totalVotes) * 100;
  }

  /// Check if a user has voted
  bool hasUserVoted(String userId) {
    return options.any((option) => option.voters.contains(userId));
  }

  /// Get user's votes
  List<String> getUserVotes(String userId) {
    return options
        .where((option) => option.voters.contains(userId))
        .map((option) => option.id)
        .toList();
  }
}
