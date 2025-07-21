import 'package:zoey/features/sheet/models/sheet_content_model.dart';

class TextBlockModel extends SheetContentModel {
  final String parentId;
  final String title;
  final String description;

  TextBlockModel({
    super.id,
    required this.parentId,
    required this.title,
    required this.description,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentType.text);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  TextBlockModel copyWith({
    String? title,
    String? description,
    DateTime? updatedAt,
  }) {
    return TextBlockModel(
      id: id,
      parentId: parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
