import 'package:zoey/features/sheet/models/content_block.dart';

class TextContentModel extends ContentBlockModel {
  final String parentId;
  final String title;
  final String data;

  TextContentModel({
    super.id,
    required this.parentId,
    required this.title,
    required this.data,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentType.text);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  TextContentModel copyWith({
    String? title,
    String? data,
    DateTime? updatedAt,
  }) {
    return TextContentModel(
      id: id,
      parentId: parentId,
      title: title ?? this.title,
      data: data ?? this.data,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
