import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

class LinkModel extends ContentModel {

   /// LinkModel properties
  final String url;
 
  LinkModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    super.emoji,
    super.description,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,

    /// LinkModel properties
    required this.url,
  }) : super(type: ContentType.link);

  LinkModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    String? title,
    String? emoji,
    Description? description,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,

    /// LinkModel properties
    String? url,
  }) {
    return LinkModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      orderIndex: orderIndex ?? this.orderIndex,

      /// LinkModel properties
      url: url ?? this.url,
    );
  }
}
 