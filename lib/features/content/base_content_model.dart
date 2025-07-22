import 'package:uuid/uuid.dart';

enum ContentType { text, event, list }

abstract class BaseContentModel {
  final String id;
  final ContentType type;
  final String sheetId;
  final String title;
  final String? parentId;
  final String? emoji;
  final String? plainTextDescription;
  final String? htmlDescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  BaseContentModel({
    String? id,
    required this.type,
    required this.sheetId,
    required this.title,
    this.parentId,
    this.emoji,
    this.plainTextDescription,
    this.htmlDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson();
  BaseContentModel copyWith({DateTime? updatedAt});
}
