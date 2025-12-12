import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

class TaskModel extends ContentModel {
  /// TaskModel properties
  final DateTime dueDate;
  final bool isCompleted;
  final List<String> assignedUsers;

  TaskModel({
    /// ContentModel properties
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    super.description,
    super.createdAt,
    super.updatedAt,
    super.orderIndex,
    required super.createdBy,

    /// TaskModel properties
    required this.dueDate,
    required this.isCompleted,
    required this.assignedUsers,
  }) : super(type: ContentType.task, emoji: null);

  TaskModel copyWith({
    /// ContentModel properties
    String? id,
    String? sheetId,
    String? parentId,
    String? title,
    Description? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,
    String? createdBy,

    /// TaskModel properties
    DateTime? dueDate,
    bool? isCompleted,
    List<String>? assignedUsers,
  }) {
    return TaskModel(
      /// ContentModel properties
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      orderIndex: orderIndex ?? this.orderIndex,
      createdBy: createdBy ?? this.createdBy,

      /// TaskModel properties
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      assignedUsers: assignedUsers ?? this.assignedUsers,
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
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
      'assignedUsers': assignedUsers,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'orderIndex': orderIndex,
    };
  }

  /// Create from JSON from Firestore
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
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
      dueDate: json['dueDate'] != null
          ? (json['dueDate'] as Timestamp).toDate()
          : DateTime.now(),
      isCompleted: json['isCompleted'] ?? false,
      assignedUsers: List<String>.from(json['assignedUsers'] ?? []),
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
