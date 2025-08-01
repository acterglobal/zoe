import 'package:zoey/features/content/models/content_model.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class TaskModel extends ContentModel {
  /// TaskModel properties
  final DateTime dueDate;
  final bool isCompleted;

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
    super.createdBy,

    /// TaskModel properties
    required this.dueDate,
    required this.isCompleted,
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

    /// EventModel properties
    DateTime? dueDate,
    bool? isCompleted,
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

      /// EventModel properties
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
