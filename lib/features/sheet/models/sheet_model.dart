import 'dart:ui';
import 'package:zoe/common/utils/common_utils.dart';

/// Description with both plain text and HTML support
typedef Description = ({String? plainText, String? htmlText});

class SheetModel {
  final String id;
  final String emoji;
  final String title;
  final String? coverImageUrl;
  final Description? description;
  final Color? color;
  final String createdBy;
  final List<String> users;
  final DateTime createdAt;
  final DateTime updatedAt;

  SheetModel({
    String? id,
    String? emoji,
    String? title,
    this.coverImageUrl,
    this.description,
    this.color,
    String? createdBy,
    List<String>? users,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? CommonUtils.generateRandomId(),
       emoji = emoji ?? '📄',
       title = title ?? 'Untitled',
       createdBy = createdBy ?? CommonUtils.generateRandomId(),
       users = users ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  SheetModel copyWith({
    String? id,
    String? emoji,
    String? title,
    String? coverImageUrl,
    Description? description,
    Color? color,
    String? createdBy,
    List<String>? users,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SheetModel(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      description: description ?? this.description,
      color: color ?? this.color,
      createdBy: createdBy ?? this.createdBy,
      users: users ?? this.users,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
