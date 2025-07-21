import 'package:uuid/uuid.dart';
import 'package:zoey/features/block/model/block_model.dart';

class TodosContentModel extends BlockModel {
  final List<TodoItem> items;

  TodosContentModel({
    super.id,
    required super.sheetId,
    required super.title,
    required this.items,
    super.createdAt,
    super.updatedAt,
  }) : super(type: BlockType.todo);

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
      sheetId: sheetId,
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
  final List<String> contentList;

  TodoItem({
    String? id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    this.assignees = const [],
    this.contentList = const [],
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'assignees': assignees,
      'contentList': contentList,
    };
  }

  TodoItem copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    List<String>? assignees,
    List<String>? contentList,
  }) {
    return TodoItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      assignees: assignees ?? this.assignees,
      contentList: contentList ?? this.contentList,
    );
  }
}
