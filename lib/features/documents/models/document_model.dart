import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

class DocumentModel extends ContentModel {
  final String filePath;

  DocumentModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    super.description,
    required super.createdBy,
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
    Description? description,

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
      description: description ?? this.description,

      /// DocumentModel properties
      filePath: filePath ?? this.filePath,
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sheetId': sheetId,
      'parentId': parentId,
      'title': title,
      'type': type.name,
      'description': {
        'plainText': description?.plainText,
        'htmlText': description?.htmlText,
      },
      'emoji': emoji,
      'filePath': filePath,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'orderIndex': orderIndex,
    };
  }

  /// Create from JSON from Firestore
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      sheetId: json['sheetId'],
      parentId: json['parentId'],
      title: json['title'],
      description:
          json['description'] != null &&
              json['description'] is Map<String, dynamic>
          ? (
              plainText: json['description']['plainText'],
              htmlText: json['description']['htmlText'],
            )
          : null,
      filePath: json['filePath'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      orderIndex: json['orderIndex'] ?? 0,
    );
  }
}
