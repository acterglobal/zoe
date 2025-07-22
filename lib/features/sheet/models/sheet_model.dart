import 'package:uuid/uuid.dart';

class SheetModel {
  final String id;
  final String? emoji;
  final String? coverImage;
  final String title;
  final String description;
  final String? descriptionHtml;
  final List<String> contentList;
  final DateTime createdAt;
  final DateTime updatedAt;

  SheetModel({
    String? id,
    this.emoji,
    this.coverImage,
    required this.title,
    this.description = '',
    this.descriptionHtml,
    List<String>? contentList,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       contentList = contentList ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emoji': emoji,
      'coverImage': coverImage,
      'title': title,
      'description': description,
      'descriptionHtml': descriptionHtml,
      'contentList': contentList, // Changed to store IDs directly
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
      descriptionHtml: json['descriptionHtml'] as String?,
      contentList:
          (json['contentList']
                  as List<dynamic>?) // Changed to handle List<String>
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  SheetModel copyWith({
    String? emoji,
    String? coverImage,
    String? title,
    String? description,
    String? descriptionHtml,
    List<String>? contentList,
    DateTime? updatedAt,
  }) {
    return SheetModel(
      id: id,
      emoji: emoji ?? this.emoji,
      coverImage: coverImage ?? this.coverImage,
      title: title ?? this.title,
      description: description ?? this.description,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      contentList: contentList ?? this.contentList, // Changed to contentList
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  void addContentId(String contentId) {
    contentList.add(contentId);
  }

  void removeContentId(String contentId) {
    contentList.remove(contentId);
  }

  void reorderContent(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = contentList.removeAt(oldIndex);
    contentList.insert(newIndex, item);
  }
}
