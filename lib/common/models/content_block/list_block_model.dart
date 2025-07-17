import 'package:zoey/common/models/content_block/content_block.dart';

class ListBlockModel extends ContentBlockModel {
  final String title;
  final List<String> items;

  ListBlockModel({
    super.id,
    required this.title,
    required this.items,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentBlockType.list);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'items': items,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  ListBlockModel copyWith({
    String? title,
    List<String>? items,
    DateTime? updatedAt,
  }) {
    return ListBlockModel(
      id: id,
      title: title ?? this.title,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
