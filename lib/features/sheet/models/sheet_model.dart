import 'package:uuid/uuid.dart';

class SheetModel {
  final String id;
  final String? emoji;
  final String? coverImage;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  SheetModel({
    String? id,
    this.emoji,
    this.coverImage,
    required this.title,
    this.description = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emoji': emoji,
      'coverImage': coverImage,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SheetModel.fromJson(Map<String, dynamic> json) {
    return SheetModel(
      id: json['id'] as String,
      emoji: json['emoji'] as String?,
      coverImage: json['coverImage'] as String?,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  SheetModel copyWith({
    String? emoji,
    String? coverImage,
    String? title,
    String? description,
    List<String>? contentList,
    DateTime? updatedAt,
  }) {
    return SheetModel(
      id: id,
      emoji: emoji ?? this.emoji,
      coverImage: coverImage ?? this.coverImage,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
