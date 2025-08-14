import 'package:zoe/features/content/models/content_model.dart';

class DocumentModel extends ContentModel {
  final String filePath;

  DocumentModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,

    /// DocumentModel properties
    required this.filePath,
  }) : super(type: ContentType.document, emoji: null);

  DocumentModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    String? title,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,

    /// DocumentModel properties
    String? filePath,
  }) {
    return DocumentModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      orderIndex: orderIndex ?? this.orderIndex,

      /// DocumentModel properties
      filePath: filePath ?? this.filePath,
    );
  }
}
