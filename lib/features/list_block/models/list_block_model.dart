import 'package:uuid/uuid.dart';
import 'package:zoey/features/sheet/models/sheet_content_model.dart';

class ListBlockModel extends SheetContentModel {
  final String parentId;
  final String title;
  final List<ListItem> listItems;

  ListBlockModel({
    super.id,
    required this.parentId,
    required this.title,
    required this.listItems,
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
      'listItems': listItems,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  ListBlockModel copyWith({
    String? title,
    List<ListItem>? listItems,
    DateTime? updatedAt,
  }) {
    return ListBlockModel(
      id: id,
      parentId: parentId,
      title: title ?? this.title,
      listItems: listItems ?? this.listItems,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class ListItem {
  final String id;
  final String title;
  final String? description;
  final List<String> contentList;

  ListItem({
    String? id,
    required this.title,
    this.description,
    this.contentList = const [],
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'contentList': contentList,
    };
  }

  ListItem copyWith({
    String? title,
    String? description,
    List<String>? contentList,
  }) {
    return ListItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      contentList: contentList ?? this.contentList,
    );
  }
}
