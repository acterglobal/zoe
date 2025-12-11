import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

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
    required super.createdBy,
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

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sheetId': sheetId,
      'parentId': parentId,
      'title': title,
      'listType': listType.name,
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
  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'],
      sheetId: json['sheetId'],
      parentId: json['parentId'],
      title: json['title'],
      listType: ContentType.values.firstWhere(
        (type) => type.name == json['listType'],
        orElse: () => ContentType.list,
      ),
      description:
          json['description'] != null &&
              json['description'] is Map<String, dynamic>
          ? (
              plainText: json['description']['plainText'],
              htmlText: json['description']['htmlText'],
            )
          : null,
      emoji: json['emoji'],
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
