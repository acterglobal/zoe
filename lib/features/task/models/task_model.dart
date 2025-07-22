import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class TaskModel {
  final String id;
  final String sheetId;
  final String listId;
  final String title;
  final Description? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final int orderIndex; // Order within list

  TaskModel({
    String? id,
    required this.sheetId,
    required this.listId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    int? orderIndex,
  }) : id = id ?? CommonUtils.generateRandomId(),
       orderIndex = orderIndex ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listId': listId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'orderIndex': orderIndex,
    };
  }

  TaskModel copyWith({
    String? id,
    String? sheetId,
    String? listId,
    String? title,
    Description? description,
    bool? isCompleted,
    DateTime? dueDate,
    int? orderIndex,
  }) {
    return TaskModel(
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
