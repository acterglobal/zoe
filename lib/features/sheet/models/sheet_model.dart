import 'dart:ui';
import 'package:zoey/common/utils/common_utils.dart';

/// Description with both plain text and HTML support
typedef Description = ({String? plainText, String? htmlText});

class SheetModel {
  final String id;
  final String emoji;
  final String title;
  final Description? description;
  final Color? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  SheetModel({
    String? id,
    String? emoji,
    String? title,
    this.description,
    this.color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? CommonUtils.generateRandomId(),
       emoji = emoji ?? '📄',
       title = title ?? 'Untitled',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  SheetModel copyWith({
    String? id,
    String? emoji,
    String? title,
    Description? description,
    Color? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SheetModel(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
