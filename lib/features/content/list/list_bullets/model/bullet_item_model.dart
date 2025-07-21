import 'package:uuid/uuid.dart';

class BulletItem {
  final String id;
  final String listId;
  final String title;
  final String? description;

  BulletItem({
    String? id,
    required this.listId,
    required this.title,
    this.description,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listId': listId,
      'title': title,
      'description': description,
    };
  }

  BulletItem copyWith({
    String? title,
    String? description,
    List<String>? contentList,
  }) {
    return BulletItem(
      id: id,
      listId: listId,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
