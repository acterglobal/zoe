import 'package:zoey/features/sheet/models/content_block/content_block.dart';

class TextBlockModel extends ContentBlockModel {
  final String title;
  final String content;

  TextBlockModel({
    super.id,
    required this.title,
    required this.content,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentBlockType.text);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  TextBlockModel copyWith({
    String? title,
    String? content,
    DateTime? updatedAt,
  }) {
    return TextBlockModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
