import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/loading_indicator_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';

/// A widget that displays a user's avatar.
/// If user has an avatar image, it shows that.
/// Otherwise shows a circle with the first letter of user's name.
class ZoeUserAvatarWidget extends StatelessWidget {
  final UserModel user;
  final bool isLoading;
  final double? size;
  final double? fontSize;
  final String? selectedImagePath;
  final double borderRadius;
  final BoxShape shape;

  const ZoeUserAvatarWidget({
    super.key,
    required this.user,
    this.isLoading = false,
    this.size,
    this.fontSize,
    this.selectedImagePath,
    this.borderRadius = 10,
    this.shape = BoxShape.circle,
  });

  @override
  Widget build(BuildContext context) {
    final randomColor = CommonUtils().getRandomColorFromName(user.name);
    final url = selectedImagePath ?? user.avatar;

    if (isLoading) {
      return _buildLoadingAvatar(context);
    } else if (url != null) {
      return _buildImageAvatar(url, context);
    } else {
      return _buildPlaceholderAvatar(randomColor);
    }
  }

  Widget _buildLoadingAvatar(BuildContext context) {
    return Container(
      width: size ?? 24,
      height: size ?? 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
      ),
      child: LoadingIndicatorWidget(type: LoadingIndicatorType.circular),
    );
  }

  Widget _buildImageAvatar(String url, BuildContext context) {
    final isCircle = shape == BoxShape.circle;
    final borderRadius = isCircle ? 0.0 : this.borderRadius;

    return Container(
      width: size ?? 24,
      height: size ?? 24,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: isCircle
          ? ClipOval(child: _buildImageView(url))
          : ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: _buildImageView(url),
            ),
    );
  }

  Widget _buildImageView(String url) {
    final randomColor = CommonUtils().getRandomColorFromName(user.name);
    return url.startsWith('http')
        ? CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (_, _) => _buildPlaceholderAvatar(randomColor),
            errorWidget: (_, _, _) =>
                _buildPlaceholderAvatar(randomColor, showError: true),
          )
        : Image.file(
            File(url),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                _buildPlaceholderAvatar(randomColor, showError: true),
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
