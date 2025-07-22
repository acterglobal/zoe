import 'package:zoey/features/content/base_content_model.dart';

class EventModel extends BaseContentModel {
  final DateTime startDate;
  final DateTime endDate;

  EventModel({
    super.id,
    required super.sheetId,
    required super.title,
    required this.startDate,
    required this.endDate,
    super.parentId,
    super.plainTextDescription,
    super.htmlDescription,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentType.event);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'plainTextDescription': plainTextDescription,
      'htmlDescription': htmlDescription,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  EventModel copyWith({
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id,
      sheetId: sheetId,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
