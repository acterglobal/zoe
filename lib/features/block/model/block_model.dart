import 'package:uuid/uuid.dart';

enum BlockType { todo, event, list, text }

abstract class BlockModel {
  final String id;
  final BlockType type;
  final String parentId;
  final String title;
  final String? emoji;
  final String? plainTextDescription;
  final String? htmlDescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  BlockModel({
    String? id,
    required this.type,
    required this.parentId,
    required this.title,
    this.emoji,
    this.plainTextDescription,
    this.htmlDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson();
  BlockModel copyWith({DateTime? updatedAt});
}
