import 'package:flutter/material.dart';

enum AvatarType { icon, image, emoji }

class SheetAvatar {
  final AvatarType type;
  final String data;
  final Color? color;

  SheetAvatar({
    this.type = AvatarType.icon,
    this.data = 'file',
    this.color,
  });

  SheetAvatar copyWith({AvatarType? type, String? data, Color? color}) {
    return SheetAvatar(
      type: type ?? this.type,
      data: data ?? this.data,
      color: color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SheetAvatar &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          data == other.data &&
          color == other.color;

  @override
  int get hashCode => type.hashCode ^ data.hashCode ^ color.hashCode;
}
