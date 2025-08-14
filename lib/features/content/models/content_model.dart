import 'package:Zoe/common/utils/common_utils.dart';
import 'package:Zoe/features/sheet/models/sheet_model.dart';

enum ContentType { text, event, list, task, bullet, link, document }

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
  final String createdBy;

  ContentModel({
    required this.type,
    String? id,
    required this.sheetId,
    required this.parentId,
    required this.title,
    this.emoji,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,
    String? createdBy,
  }) : id = id ?? CommonUtils.generateRandomId(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       orderIndex = orderIndex ?? 0,
       createdBy = createdBy ?? CommonUtils.generateRandomId();
}
