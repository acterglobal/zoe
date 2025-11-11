import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ZoeNetworkLocalImageView extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final double placeholderIconSize;

  const ZoeNetworkLocalImageView({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 15,
    this.placeholderIconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = imageUrl.startsWith('http');
    final double dynamicBorderRadius = _calculateBorderRadius();

    return ClipRRect(
      borderRadius: BorderRadius.circular(dynamicBorderRadius),
      child: isNetworkImage
          ? _buildNetworkImage(context, imageUrl)
          : _buildLocalImage(context, imageUrl),
    );
  }

  double _calculateBorderRadius() {
    // If both height and width are null, use the fixed border radius
    if (height == null || width == null) return borderRadius;
    // Use the smaller dimension to calculate dynamic radius
    final minDimension = height! < width! ? height! : width!;
    return minDimension * 0.2;
  }

  Widget _buildNetworkImage(BuildContext context, String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => _buildPlaceholderImage(context),
      errorWidget: (_, _, _) => _buildErrorImage(context),
    );
  }

  Widget _buildLocalImage(BuildContext context, String imageUrl) {
    return Image.file(
      File(imageUrl),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => _buildErrorImage(context),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Icon(
        Icons.image_outlined,
        color: colorScheme.onPrimary.withValues(alpha: .4),
        size: placeholderIconSize,
      ),
    );
  }

  Widget _buildErrorImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: placeholderIconSize,
        color: colorScheme.error,
      ),
    );
  }
}
