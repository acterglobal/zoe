import 'package:Zoe/features/content/models/content_model.dart';
import 'package:Zoe/features/sheet/models/sheet_model.dart';

enum RsvpStatus {
  yes,
  no,
  maybe;

  String get name => switch (this) {
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
    super.createdBy,
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
}
