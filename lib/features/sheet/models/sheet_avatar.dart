import 'package:flutter/material.dart';
import 'package:zoe/common/utils/color_extensions.dart';

enum AvatarType { icon, image, emoji }

class SheetAvatar {
  final AvatarType type;
  final String data;
  final Color? color;

  SheetAvatar({this.type = AvatarType.icon, this.data = 'file', this.color});

  SheetAvatar copyWith({AvatarType? type, String? data, Color? color}) {
    return SheetAvatar(
      type: type ?? this.type,
      data: data ?? this.data,
      color: color,
    );
  }

  bool isNetworkImage() => type == AvatarType.image && data.startsWith('http');

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'data': data,
      if (color != null) 'color': color!.toHex(),
    };
  }

  /// Create from JSON from Firestore
  factory SheetAvatar.fromJson(Map<String, dynamic> json) {
    return SheetAvatar(
      type: AvatarType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AvatarType.icon,
      ),
      data: json['data'] as String? ?? 'file',
      color: (json['color'] as String?)?.toColor(),
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
