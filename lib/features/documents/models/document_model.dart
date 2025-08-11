import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class DocumentModel extends ContentModel {
  final String fileName;
  final String fileType;
  final String filePath;

  DocumentModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    super.description,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,

    /// DocumentModel properties
    required this.fileName,
    required this.fileType,
    required this.filePath,
  }) : super(type: ContentType.document, emoji: null);

  DocumentModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    String? title,
    Description? description,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,

    /// DocumentModel properties
    String? fileName,
    String? fileType,
    String? filePath,
  }) {
    return DocumentModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      orderIndex: orderIndex ?? this.orderIndex,

      /// DocumentModel properties
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      filePath: filePath ?? this.filePath,
    );
  }
}
