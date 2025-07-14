import 'package:uuid/uuid.dart';
import 'content_block.dart';

class ZoePage {
  final String id;
  final String title;
  final String description;
  final List<ContentBlock> contentBlocks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? emoji;
  final String? coverImage;

  ZoePage({
    String? id,
    required this.title,
    this.description = '',
    List<ContentBlock>? contentBlocks,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.emoji,
    this.coverImage,
  }) : id = id ?? const Uuid().v4(),
       contentBlocks = contentBlocks ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'contentBlocks': contentBlocks.map((block) => block.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'emoji': emoji,
      'coverImage': coverImage,
    };
  }

  ZoePage copyWith({
    String? title,
    String? description,
    List<ContentBlock>? contentBlocks,
    DateTime? updatedAt,
    String? emoji,
    String? coverImage,
  }) {
    return ZoePage(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      contentBlocks: contentBlocks ?? this.contentBlocks,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      emoji: emoji ?? this.emoji,
      coverImage: coverImage ?? this.coverImage,
    );
  }

  // Helper methods for content blocks
  void addContentBlock(ContentBlock block) {
    contentBlocks.add(block);
  }

  void removeContentBlock(String blockId) {
    contentBlocks.removeWhere((block) => block.id == blockId);
  }

  void updateContentBlock(String blockId, ContentBlock updatedBlock) {
    final index = contentBlocks.indexWhere((block) => block.id == blockId);
    if (index != -1) {
      contentBlocks[index] = updatedBlock;
    }
  }

  void reorderContentBlocks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ContentBlock item = contentBlocks.removeAt(oldIndex);
    contentBlocks.insert(newIndex, item);
  }

  // Get specific types of content blocks
  List<TodoBlock> get todoBlocks =>
      contentBlocks.whereType<TodoBlock>().toList();

  List<EventBlock> get eventBlocks =>
      contentBlocks.whereType<EventBlock>().toList();

  List<ListBlock> get listBlocks =>
      contentBlocks.whereType<ListBlock>().toList();

  List<TextBlock> get textBlocks =>
      contentBlocks.whereType<TextBlock>().toList();
}
