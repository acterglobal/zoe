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
