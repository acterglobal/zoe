import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

enum RsvpStatus {
  yes,
  no,
  maybe;

  String get displayName => switch (this) {
    yes => 'Yes',
    no => 'No',
    maybe => 'Maybe',
  };
}

class EventModel extends ContentModel {
  /// EventModel properties
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, RsvpStatus> rsvpResponses;

  EventModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    super.description,
    required super.createdBy,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,

    /// EventModel properties
    required this.startDate,
    required this.endDate,
    this.rsvpResponses = const {},
  }) : super(type: ContentType.event, emoji: '📅');

  EventModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    String? title,
    Description? description,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,

    /// EventModel properties
    DateTime? startDate,
    DateTime? endDate,
    Map<String, RsvpStatus>? rsvpResponses,
  }) {
    return EventModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      orderIndex: orderIndex ?? this.orderIndex,

      /// EventModel properties
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rsvpResponses: rsvpResponses ?? this.rsvpResponses,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final rsvpMap = json['rsvpResponses'] as Map<String, dynamic>? ?? {};
    final rsvpResponses = rsvpMap.map((key, value) {
      return MapEntry(
        key,
        RsvpStatus.values.firstWhere(
          (e) => e.name == value,
          orElse: () =>
              RsvpStatus.maybe, // Default value if string doesn't match
        ),
      );
    });

    return EventModel(
      /// ContentModel properties
      id: json['id'],
      sheetId: json['sheetId'] ?? '',
      parentId: json['parentId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] != null
          ? (
              plainText: json['description']['plainText'] ?? '',
              htmlText: json['description']['htmlText'] ?? '',
            )
          : null,
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] == null
          ? DateTime.now()
          : (json['updatedAt'] as Timestamp).toDate(),
      orderIndex: json['orderIndex'] ?? 0,

      /// EventModel properties
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      rsvpResponses: rsvpResponses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      /// ContentModel properties
      'id': id,
      'sheetId': sheetId,
      'parentId': parentId,
      'title': title,
      'description': {
        'plainText': description?.plainText,
        'htmlText': description?.htmlText,
      },
      'emoji': emoji,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'orderIndex': orderIndex,

      /// EventModel properties
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'rsvpResponses': rsvpResponses.map(
        (key, value) => MapEntry(key, value.name),
      ),
    };
  }
}
