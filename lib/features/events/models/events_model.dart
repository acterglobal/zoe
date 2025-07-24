import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class EventModel extends ContentModel {
  /// EventModel properties
  final DateTime startDate;
  final DateTime endDate;

  EventModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    super.description,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,

    /// EventModel properties
    required this.startDate,
    required this.endDate,
  }) : super(type: ContentType.event, emoji: '📅');

  EventModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    String? title,
    Description? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,

    /// EventModel properties
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return EventModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      orderIndex: orderIndex ?? this.orderIndex,

      /// EventModel properties
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
