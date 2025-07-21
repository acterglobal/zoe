import 'package:zoey/features/sheet/models/sheet_content_model.dart';

class ListBlockModel extends SheetContentModel {
  final String parentId;
  final String title;

  ListBlockModel({
    super.id,
    required this.parentId,
    required this.title,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentType.bullet);

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
      parentId: parentId,
      title: title ?? this.title,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
