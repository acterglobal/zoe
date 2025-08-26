import 'package:zoe/features/content/models/content_model.dart';

class PollOption {
  final String id;
  final String title;
  final List<Vote> votes;

  const PollOption({
    required this.id,
    required this.title,
    this.votes = const [],
  });

  PollOption copyWith({
    String? id,
    String? title,
    List<Vote>? votes,
  }) {
    return PollOption(
      id: id ?? this.id,
      title: title ?? this.title,
      votes: votes ?? this.votes,
    );
  }
}

class Vote{
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Vote({
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Vote copyWith({ 
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vote(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PollModel extends ContentModel {
  final String question;
  final List<PollOption> options;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isMultipleChoice;

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
    this.startDate,
    this.endDate,
    this.isMultipleChoice = false,
  }) : super(type: ContentType.poll, emoji: '📊', title: '');

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
    );
  }

  int get totalVotes => options.fold(0, (sum, option) => sum + option.votes.length);
}
