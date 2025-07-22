import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class TextModel extends ContentModel {
  TextModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    super.listId,
    required super.description,
    super.emoji,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,
  }) : super(type: ContentType.text);

  TextModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    String? listId,
    String? title,
    Description? description,
    String? emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,
  }) {
    return TextModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
