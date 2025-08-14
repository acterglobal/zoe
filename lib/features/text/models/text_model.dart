import 'package:Zoe/features/content/models/content_model.dart';
import 'package:Zoe/features/sheet/models/sheet_model.dart';

class TextModel extends ContentModel {
  TextModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    required super.description,
    super.emoji,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,
  }) : super(type: ContentType.text);

  TextModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    String? title,
    Description? description,
    String? emoji,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,
  }) {
    return TextModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
