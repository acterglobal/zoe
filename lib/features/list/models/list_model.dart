import 'package:zoey/features/content/models/base_content_model.dart';

enum ListType { bulleted, task }

class ListModel extends BaseContentModel {
  final ListType listType;

  ListModel({
    super.id,
    required super.sheetId,
    required super.title,
    required this.listType,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentType.list);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'parentId': parentId,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  ListModel copyWith({
    String? title,
    List<String>? bullets,
    DateTime? updatedAt,
  }) {
    return ListModel(
      id: id,
      sheetId: sheetId,
      title: title ?? this.title,
      listType: listType,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
