import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

class BulletModel extends ContentModel {
  BulletModel({
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
  }) : super(type: ContentType.bullet, emoji: null);

  BulletModel copyWith({
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
  }) {
    return BulletModel(
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
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'orderIndex': orderIndex,
    };
  }

  /// Create from JSON from Firestore
  factory BulletModel.fromJson(Map<String, dynamic> json) {
    return BulletModel(
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
