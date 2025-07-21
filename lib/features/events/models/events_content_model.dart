import 'package:zoey/features/block/model/block_model.dart';

class EventBlockModel extends BlockModel {
  final DateTime startDate;
  final DateTime endDate;

  EventBlockModel({
    super.id,
    required super.parentId,
    required super.title,
    required this.startDate,
    required this.endDate,
    super.createdAt,
    super.updatedAt,
  }) : super(type: BlockType.event);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  EventBlockModel copyWith({
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? updatedAt,
  }) {
    return EventBlockModel(
      id: id,
      parentId: parentId,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
