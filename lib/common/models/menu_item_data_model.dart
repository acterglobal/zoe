import 'package:flutter/material.dart';

enum ContentMenuAction { connect, edit, share, delete }

class MenuItemDataModel {
  final ContentMenuAction action;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;

  const MenuItemDataModel({
    required this.action,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isDestructive = false,
  });
}