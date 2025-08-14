import 'package:Zoe/features/content/models/content_model.dart';
import 'package:Zoe/features/sheet/models/sheet_model.dart';

class ListModel extends ContentModel {
  /// ListModel properties
  final ContentType listType;

  ListModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    super.description,
    super.emoji,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,

    /// ListModel specific properties
    required this.listType,
  }) : super(type: ContentType.list);

  ListModel copyWith({
    /// ContentModel properties
    String? id,
    ContentType? type,
    String? sheetId,
    String? parentId,
    String? title,
    Description? description,
    String? emoji,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,

    /// ListModel specific properties
    ContentType? listType,
  }) {
    return ListModel(
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

      /// ListModel specific properties
      listType: listType ?? this.listType,
    );
  }
}
