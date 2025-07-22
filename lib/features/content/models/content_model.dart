import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

enum ContentType { text, event, list }

abstract class ContentModel {
  final ContentType type;
  final String id;
  final String sheetId;
  final String parentId;
  final String title;
  final String? emoji;
  final Description? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int orderIndex; // Order within parent

  ContentModel({
    String? id,
    required this.type,
    required this.sheetId,
    required this.title,
    required this.parentId,
    this.emoji,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,
  }) : id = id ?? CommonUtils.generateRandomId(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       orderIndex = orderIndex ?? 0;
}
