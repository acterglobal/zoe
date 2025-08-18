import 'package:zoe/features/content/models/content_model.dart';

class PollOption {
  final String id;
  final String title;
  final List<String> voters;

  const PollOption({
    required this.id,
    required this.title,
    this.voters = const [],
  });

  PollOption copyWith({
    String? id,
    String? title,
    List<String>? voters,
  }) {
    return PollOption(
      id: id ?? this.id,
      title: title ?? this.title,
      voters: voters ?? this.voters,
    );
  }
}

enum PollStatus { notStarted, started, ended }

class PollModel extends ContentModel {
  final String question;
  final List<PollOption> options;
  final DateTime startDate;
  final DateTime? endDate;
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

  int get totalVotes => options.fold(0, (sum, option) => sum + option.voters.length);

  bool get isStarted => status == PollStatus.started;

  bool get isNotStarted => status == PollStatus.notStarted;

  bool get isEnded => status == PollStatus.ended;
}
