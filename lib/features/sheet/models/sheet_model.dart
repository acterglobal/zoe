import 'package:zoey/common/utils/common_utils.dart';

class SheetModel {
  final String id;
  final String emoji;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  SheetModel({
    String? id,
    String? emoji,
    String? title,
    this.description,
    DateTime? updatedAt,
  }) : id = id ?? CommonUtils.generateRandomId(),
       emoji = emoji ?? '📄',
       title = title ?? 'Untitled',
       createdAt = DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  SheetModel copyWith({String? emoji, String? title, String? description}) {
    return SheetModel(
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      description: description ?? this.description,
      updatedAt: DateTime.now(),
    );
  }
}
