import 'package:cloud_firestore/cloud_firestore.dart';
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

  PollOption copyWith({String? id, String? title, List<Vote>? votes}) {
    return PollOption(
      id: id ?? this.id,
      title: title ?? this.title,
      votes: votes ?? this.votes,
    );
  }

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      votes: (json['votes'] as List<dynamic>? ?? [])
          .map((vote) => Vote.fromJson(vote as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'votes': votes.map((vote) => vote.toJson()).toList(),
    };
  }
}

class Vote {
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Vote({required this.userId, this.createdAt, this.updatedAt});

  Vote copyWith({String? userId, DateTime? createdAt, DateTime? updatedAt}) {
    return Vote(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      userId: json['userId'],
      createdAt: json['createdAt'] == null
          ? null
          : (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] == null
          ? null
          : (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
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
    required super.createdBy,

    /// PollModel properties
    required this.question,
    required this.options,
    this.startDate,
    this.endDate,
    this.isMultipleChoice = false,
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

  factory PollModel.fromJson(Map<String, dynamic> json) {
    return PollModel(
      // ContentModel properties
      id: json['id'],
      sheetId: json['sheetId'],
      parentId: json['parentId'],
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] == null
          ? DateTime.now()
          : (json['updatedAt'] as Timestamp).toDate(),
      orderIndex: json['orderIndex'] ?? 0,
      createdBy: json['createdBy'],
      // PollModel properties
      question: json['question'] ?? '',
      options: (json['options'] as List<dynamic>? ?? [])
          .map((option) => PollOption.fromJson(option as Map<String, dynamic>))
          .toList(),
      startDate: json['startDate'] == null
          ? null
          : (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] == null
          ? null
          : (json['endDate'] as Timestamp).toDate(),
      isMultipleChoice: json['isMultipleChoice'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // ContentModel properties
      'id': id,
      'sheetId': sheetId,
      'parentId': parentId,
      'title': title,
      'emoji': emoji,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'orderIndex': orderIndex,
      // PollModel properties
      'question': question,
      'options': options.map((option) => option.toJson()).toList(),
      'startDate': startDate == null ? null : Timestamp.fromDate(startDate!),
      'endDate': endDate == null ? null : Timestamp.fromDate(endDate!),
      'isMultipleChoice': isMultipleChoice,
    };
  }

  int get totalVotes =>
      options.fold(0, (sum, option) => sum + option.votes.length);
}
