import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';

class SheetAvatar {
  final ZoeIcon icon;
  final String? image;
  final String? emoji;
  final Color? color;

  SheetAvatar({
    this.icon = ZoeIcon.file,
    this.image,
    this.emoji,
    this.color,
  });

  SheetAvatar copyWith({
    ZoeIcon? icon,
    String? image,
    String? emoji,
    Color? color,
  }) {
    return SheetAvatar(
      icon: icon ?? this.icon,
      image: image ?? this.image,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
    );
  }
}
