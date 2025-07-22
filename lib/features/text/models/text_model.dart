import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class TextModel extends ContentModel {
  TextModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    required super.description,
    super.emoji,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentType.text);

  TextModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    String? title,
    Description? description,
    String? emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TextModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
