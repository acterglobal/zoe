import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

class TextModel extends ContentModel {
  TextModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    required super.description,
    super.emoji,
    required super.createdBy,
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

  factory TextModel.fromJson(Map<String, dynamic> json) {
    return TextModel(
      /// ContentModel properties
      id: json['id'],
      sheetId: json['sheetId'] ?? '',
      parentId: json['parentId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] != null
          ? (
              plainText: json['description']['plainText'] ?? '',
              htmlText: json['description']['htmlText'] ?? '',
            )
          : null,
      emoji: json['emoji'],
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] == null
          ? DateTime.now()
          : (json['updatedAt'] as Timestamp).toDate(),
      orderIndex: json['orderIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      /// ContentModel properties
      'id': id,
      'sheetId': sheetId,
      'parentId': parentId,
      'title': title,
      'description': {
        'plainText': description?.plainText,
        'htmlText': description?.htmlText,
      },
      'emoji': emoji,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'orderIndex': orderIndex,
    };
  }
}
