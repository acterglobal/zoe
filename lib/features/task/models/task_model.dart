import 'package:uuid/uuid.dart';

class TaskModel {
  final String id;
  final String listId;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final List<String> assignees;

  TaskModel({
    String? id,
    required this.listId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    this.assignees = const [],
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listId': listId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'assignees': assignees,
    };
  }

  TaskModel copyWith({
    String? listId,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    List<String>? assignees,
    List<String>? contentList,
  }) {
    return TaskModel(
      id: id,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      assignees: assignees ?? this.assignees,
    );
  }
}
