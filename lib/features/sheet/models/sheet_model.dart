import 'dart:ui';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';

/// Description with both plain text and HTML support
typedef Description = ({String? plainText, String? htmlText});

/// Theme object with primary and secondary colors
typedef SheetTheme = ({Color primary, Color secondary});

class SheetModel {
  final String id;
  final SheetAvatar sheetAvatar;
  final String title;
  final String? coverImageUrl;
  final Description? description;
  final Color? color;
  final SheetTheme? theme;
  final String createdBy;
  final List<String> users;
  final DateTime createdAt;
  final DateTime updatedAt;

  SheetModel({
    String? id,
    SheetAvatar? sheetAvatar,
    String? title,
    this.coverImageUrl,
    this.description,
    this.color,
    this.theme,
    String? createdBy,
    List<String>? users,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? CommonUtils.generateRandomId(),
       sheetAvatar = sheetAvatar ?? SheetAvatar(),
       title = title ?? 'Untitled',
       createdBy = createdBy ?? CommonUtils.generateRandomId(),
       users = users ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  SheetModel copyWith({
    String? id,
    SheetAvatar? sheetAvatar,
    String? title,
    String? coverImageUrl,
    Description? description,
    Color? color,
    SheetTheme? theme,
    String? createdBy,
    List<String>? users,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SheetModel(
      id: id ?? this.id,
      sheetAvatar: sheetAvatar ?? this.sheetAvatar,
      title: title ?? this.title,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      description: description ?? this.description,
      color: color ?? this.color,
      theme: theme ?? this.theme,
      createdBy: createdBy ?? this.createdBy,
      users: users ?? this.users,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  SheetModel removeCoverImage() {
    return SheetModel(
      id: id,
      sheetAvatar: sheetAvatar,
      title: title,
      coverImageUrl: null,
      description: description,
      color: color,
      theme: theme,
      createdBy: createdBy,
      users: users,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
