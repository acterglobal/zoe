import 'package:uuid/uuid.dart';

class ZoeSheetModel {
  final String id;
  final String title;
  final String description;
  final List<String> contentList;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? emoji;
  final String? coverImage;

  ZoeSheetModel({
    String? id,
    required this.title,
    this.description = '',
    List<String>? contentList,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.emoji,
    this.coverImage,
  }) : id = id ?? const Uuid().v4(),
       contentList = contentList ?? [], // Changed to contentList
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'contentList': contentList, // Changed to store IDs directly
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'emoji': emoji,
      'coverImage': coverImage,
    };
  }

  factory ZoeSheetModel.fromJson(Map<String, dynamic> json) {
    return ZoeSheetModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      contentList:
          (json['contentList']
                  as List<dynamic>?) // Changed to handle List<String>
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      emoji: json['emoji'] as String?,
      coverImage: json['coverImage'] as String?,
    );
  }

  ZoeSheetModel copyWith({
    String? title,
    String? description,
    List<String>? contentList, // Changed to List<String>
    DateTime? updatedAt,
    String? emoji,
    String? coverImage,
  }) {
    return ZoeSheetModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      contentList: contentList ?? this.contentList, // Changed to contentList
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      emoji: emoji ?? this.emoji,
      coverImage: coverImage ?? this.coverImage,
    );
  }

  // Utility method to add content ID
  void addContentId(String contentId) {
    contentList.add(contentId);
  }

  // Utility method to remove content ID
  void removeContentId(String contentId) {
    contentList.remove(contentId);
  }

  // Utility method to reorder content IDs
  void reorderContent(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = contentList.removeAt(oldIndex);
    contentList.insert(newIndex, item);
  }
}
