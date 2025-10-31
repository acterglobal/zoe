import 'package:flutter/material.dart';

class SheetAvatar {
  final IconData icon;
  final String? image;
  final String? emoji;
  final Color? color;

  SheetAvatar({
    this.icon = Icons.description_outlined,
    this.image,
    this.emoji,
    this.color,
  });

  SheetAvatar copyWith({
    IconData? icon,
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
