import 'package:uuid/uuid.dart';
import 'package:zoey/features/sheet/models/content_block/event_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/list_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/text_block_model.dart';
import 'package:zoey/features/sheet/models/content_block/todo_block_model.dart';
import 'content_block/content_block.dart';

class ZoeSheetModel {
  final String id;
  final String title;
  final String description;
  final List<ContentBlockModel> contentBlocks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? emoji;
  final String? coverImage;

  ZoeSheetModel({
    String? id,
    required this.title,
    this.description = '',
    List<ContentBlockModel>? contentBlocks,
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

  ZoeSheetModel copyWith({
    String? title,
    String? description,
    List<ContentBlockModel>? contentBlocks,
    DateTime? updatedAt,
    String? emoji,
    String? coverImage,
  }) {
    return ZoeSheetModel(
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
  void addContentBlock(ContentBlockModel block) {
    contentBlocks.add(block);
  }

  void removeContentBlock(String blockId) {
    contentBlocks.removeWhere((block) => block.id == blockId);
  }

  void updateContentBlock(String blockId, ContentBlockModel updatedBlock) {
    final index = contentBlocks.indexWhere((block) => block.id == blockId);
    if (index != -1) {
      contentBlocks[index] = updatedBlock;
    }
  }

  void reorderContentBlocks(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ContentBlockModel item = contentBlocks.removeAt(oldIndex);
    contentBlocks.insert(newIndex, item);
  }

  // Get specific types of content blocks
  List<TodoBlockModel> get todoBlocks =>
      contentBlocks.whereType<TodoBlockModel>().toList();

  List<EventBlockModel> get eventBlocks =>
      contentBlocks.whereType<EventBlockModel>().toList();

  List<ListBlockModel> get listBlocks =>
      contentBlocks.whereType<ListBlockModel>().toList();

  List<TextBlockModel> get textBlocks =>
      contentBlocks.whereType<TextBlockModel>().toList();
}
