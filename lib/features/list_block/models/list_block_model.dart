import 'package:zoey/features/block/model/block_model.dart';

class ListBlockModel extends BlockModel {
  ListBlockModel({
    super.id,
    required super.sheetId,
    required super.title,
    super.createdAt,
    super.updatedAt,
  }) : super(type: BlockType.list);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'type': type.name,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  ListBlockModel copyWith({
    String? title,
    List<String>? bullets,
    DateTime? updatedAt,
  }) {
    return ListBlockModel(
      id: id,
      sheetId: sheetId,
      title: title ?? this.title,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
