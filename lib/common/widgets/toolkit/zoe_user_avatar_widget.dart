import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/features/users/models/user_model.dart';

/// A widget that displays a user's avatar.
/// If user has an avatar image, it shows that.
/// Otherwise shows a circle with the first letter of user's name.
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
      return _buildImageAvatar(imagePath, context);
    }

    return _buildPlaceholderAvatar(randomColor);
  }

  Widget _buildImageAvatar(String path, BuildContext context) {
    final randomColor = CommonUtils().getRandomColorFromName(user.name);
    return Container(
      width: size ?? 24,
      height: size ?? 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ClipOval(
        child: path.startsWith('http')
            ? Image.network(
                path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderAvatar(
                    randomColor,
                    showError: true,
                  );
                },
              )
            : Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderAvatar(
                    randomColor,
                    showError: true,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar(Color color, {bool showError = false}) {
    return Container(
      width: size ?? 24,
      height: size ?? 24,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 0.3),
      ),
      child: Center(
        child: showError
            ? Icon(
                Icons.error_outline,
                color: color,
                size: (fontSize ?? 12) * 1.2,
              )
            : Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: color,
                  fontSize: fontSize ?? 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}