import 'package:uuid/uuid.dart';

enum ContentType { todo, event, bullet, text }

abstract class ContentBlockModel {
  final String id;
  final ContentType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContentBlockModel({
    String? id,
    required this.type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson();
  ContentBlockModel copyWith({DateTime? updatedAt});
}
