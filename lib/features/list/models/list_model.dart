import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

enum ListType { bulleted, task }

class ListModel extends ContentModel {
  /// ListModel properties
  final ListType listType;

  ListModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    super.description,
    super.emoji,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,

    /// ListModel properties
    required this.listType,
  }) : super(type: ContentType.list);

  ListModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    String? title,
    Description? description,
    String? emoji,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,

    /// ListModel properties
    ListType? listType,
  }) {
    return ListModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      orderIndex: orderIndex ?? this.orderIndex,

      /// ListModel properties
      listType: listType ?? this.listType,
    );
  }
}
