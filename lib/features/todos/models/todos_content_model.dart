import 'package:uuid/uuid.dart';
import 'package:zoey/features/sheet/models/sheet_content_model.dart';

class TodosContentModel extends SheetContentModel {
  final String parentId;
  final String title;
  final List<TodoItem> items;

  TodosContentModel({
    super.id,
    required this.parentId,
    required this.title,
    required this.items,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentType.todo);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  TodosContentModel copyWith({
    String? title,
    List<TodoItem>? items,
    DateTime? updatedAt,
  }) {
    return TodosContentModel(
      id: id,
      parentId: parentId,
      title: title ?? this.title,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class TodoItem {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final List<String> assignees;

  TodoItem({
    String? id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    this.assignees = const [],
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'assignees': assignees,
    };
  }

  TodoItem copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    List<String>? assignees,
  }) {
    return TodoItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      assignees: assignees ?? this.assignees,
    );
  }
}
