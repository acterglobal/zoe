import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class TaskModel {
  final String id;
  final String listId;
  final String title;
  final Description? description;
  final bool isCompleted;
  final DateTime? dueDate;

  TaskModel({
    String? id,
    required this.listId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
  }) : id = id ?? CommonUtils.generateRandomId();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listId': listId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  TaskModel copyWith({
    String? id,
    String? listId,
    String? title,
    Description? description,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
