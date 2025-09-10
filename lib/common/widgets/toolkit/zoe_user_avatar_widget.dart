import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/users/models/user_model.dart';

class ZoeUserAvatarWidget extends StatelessWidget {
  final UserModel user;
  final double? size;
  final double? fontSize;
  final String? selectedImagePath;

  const ZoeUserAvatarWidget({
    super.key,
    required this.user,
    this.size,
    this.fontSize,
    this.selectedImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final randomColor = CommonUtils().getRandomColorFromName(user.name);

    final imagePath = selectedImagePath ?? user.avatar;
    if (imagePath != null) {
      ImageProvider imageProvider;
      
      if (imagePath.startsWith('http')) {
        // Handle http/https URLs
        imageProvider = NetworkImage(imagePath);
      } else if (imagePath.startsWith('file://')) {
        // Handle file:// URIs
        imageProvider = FileImage(File.fromUri(Uri.parse(imagePath)));
      } else if (Uri.tryParse(imagePath)?.hasScheme ?? false) {
        // Handle other URIs (like content:// on Android)
        imageProvider = NetworkImage(imagePath);
      } else {
        // Handle regular file paths
        imageProvider = FileImage(File(imagePath));
      }

      return Container(
        width: size ?? 100,
        height: size ?? 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: size ?? 24,
      height: size ?? 24,
      decoration: BoxDecoration(
        color: randomColor.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: randomColor, width: 0.3),
      ),
      child: Center(
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: randomColor,
            fontSize: fontSize ?? 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
