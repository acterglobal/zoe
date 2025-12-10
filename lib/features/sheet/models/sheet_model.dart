import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';

/// Description with both plain text and HTML support
typedef Description = ({String? plainText, String? htmlText});

/// Theme class with primary and secondary colors
class SheetTheme {
  final Color primary;
  final Color secondary;

  const SheetTheme({required this.primary, required this.secondary});

  SheetTheme copyWith({Color? primary, Color? secondary}) {
    return SheetTheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  Map<String, dynamic> toJson() => {
    'primary': CommonUtils.clrToHex(primary),
    'secondary': CommonUtils.clrToHex(secondary),
  };

  factory SheetTheme.fromJson(Map<String, dynamic> json) => SheetTheme(
    primary: CommonUtils.clrFromHex(json['primary'] as String),
    secondary: CommonUtils.clrFromHex(json['secondary'] as String),
  );
}

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
  final String? sharedBy;
  final String? message;

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
    this.sharedBy,
    this.message,
  }) : id = id ?? CommonUtils.generateRandomId(),
       sheetAvatar = sheetAvatar ?? SheetAvatar(),
       title = title ?? 'Untitled',
       createdBy = createdBy ?? '', // Will be set by addSheet method
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
    String? sharedBy,
    String? message,
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
      sharedBy: sharedBy ?? this.sharedBy,
      message: message ?? this.message,
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
      sharedBy: sharedBy,
      message: message,
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sheetAvatar': sheetAvatar.toJson(),
      'title': title,
      if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
      if (description != null)
        'description': {
          if (description!.plainText != null)
            'plainText': description!.plainText,
          if (description!.htmlText != null) 'htmlText': description!.htmlText,
        },
      if (color != null) 'color': CommonUtils.clrToHex(color!),
      if (theme != null) 'theme': theme!.toJson(),
      'createdBy': createdBy,
      'users': users,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (sharedBy != null) 'sharedBy': sharedBy,
      if (message != null) 'message': message,
    };
  }

  /// Create from JSON from Firestore
  factory SheetModel.fromJson(Map<String, dynamic> json) {
    return SheetModel(
      id: json['id'] as String,
      sheetAvatar: json['sheetAvatar'] != null
          ? SheetAvatar.fromJson(json['sheetAvatar'] as Map<String, dynamic>)
          : null,
      title: json['title'] as String? ?? 'Untitled',
      coverImageUrl: json['coverImageUrl'] as String?,
      description: json['description'] != null
          ? (
              plainText:
                  (json['description'] as Map<String, dynamic>)['plainText']
                      as String?,
              htmlText:
                  (json['description'] as Map<String, dynamic>)['htmlText']
                      as String?,
            )
          : null,
      color: json['color'] != null
          ? CommonUtils.clrFromHex(json['color'])
          : null,
      theme: json['theme'] != null ? SheetTheme.fromJson(json['theme']) : null,
      createdBy: json['createdBy'] as String? ?? '',
      users: List<String>.from(json['users'] ?? []),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      sharedBy: json['sharedBy'] as String?,
      message: json['message'] as String?,
    );
  }
}
