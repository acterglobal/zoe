import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';

class SheetAvatar {
  final ZoeIcon icon;
  final String? image;
  final String? emoji;
  final Color? color;

  SheetAvatar({this.icon = ZoeIcon.file, this.image, this.emoji, this.color});

  SheetAvatar copyWith({
    ZoeIcon? icon,
    String? image,
    String? emoji,
    Color? color,
  }) {
    return SheetAvatar(
      icon: icon ?? this.icon,
      image: image,
      emoji: emoji,
      color: color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SheetAvatar &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          image == other.image &&
          emoji == other.emoji &&
          color == other.color;

  @override
  int get hashCode =>
      icon.hashCode ^ image.hashCode ^ emoji.hashCode ^ color.hashCode;
}
