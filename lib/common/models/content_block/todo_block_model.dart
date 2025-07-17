import 'package:uuid/uuid.dart';
import 'package:zoey/common/models/content_block/content_block.dart';

class TodoBlockModel extends ContentBlockModel {
  final String title;
  final List<TodoItem> items;

  TodoBlockModel({
    super.id,
    required this.title,
    required this.items,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentBlockType.todo);

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
  TodoBlockModel copyWith({
    String? title,
    List<TodoItem>? items,
    DateTime? updatedAt,
  }) {
    return TodoBlockModel(
      id: id,
      title: title ?? this.title,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

enum TodoPriority { low, medium, high, urgent }

class TodoItem {
  final String id;
  final String text;
  final bool isCompleted;
  final DateTime? dueDate;
  final List<String> assignees;
  final TodoPriority priority;
  final String? description;
  final List<String> tags;

  TodoItem({
    String? id,
    required this.text,
    this.isCompleted = false,
    this.dueDate,
    this.assignees = const [],
    this.priority = TodoPriority.medium,
    this.description,
    this.tags = const [],
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'assignees': assignees,
      'priority': priority.name,
      'description': description,
      'tags': tags,
    };
  }

  TodoItem copyWith({
    String? text,
    bool? isCompleted,
    DateTime? dueDate,
    List<String>? assignees,
    TodoPriority? priority,
    String? description,
    List<String>? tags,
  }) {
    return TodoItem(
      id: id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      assignees: assignees ?? this.assignees,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }
}
