import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ZoeNetworkLocalImageView extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const ZoeNetworkLocalImageView({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = imageUrl.startsWith('http');
    final double dynamicBorderRadius = _calculateBorderRadius();

    return ClipRRect(
      borderRadius: BorderRadius.circular(dynamicBorderRadius),
      child: isNetworkImage
          ? _buildNetworkImage(imageUrl)
          : _buildLocalImage(imageUrl),
    );
  }

  double _calculateBorderRadius() {
    // If both height and width are null, use the fixed border radius
    if (height == null || width == null) return borderRadius;
    // Use the smaller dimension to calculate dynamic radius
    final minDimension = height! < width! ? height! : width!;
    return minDimension * 0.2;
  }

  Widget _buildNetworkImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => _buildPlaceholderImage(),
      errorWidget: (_, _, _) => _buildErrorImage(),
    );
  }

  Widget _buildLocalImage(String imageUrl) {
    return Image.file(
      File(imageUrl),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => _buildErrorImage(),
    );
  }

  double _calculatePadding() {
    // If both height and width are null, use fixed padding
    if (height == null || width == null) return 12;
    // Use the smaller dimension to calculate dynamic padding
    final minDimension = height! < width! ? height! : width!;
    return minDimension * 0.3;
  }

  Widget _buildPlaceholderImage() {
    final double padding = _calculatePadding();
    return Center(
      child: CircularProgressIndicator(
        padding: EdgeInsets.all(padding),
        strokeWidth: 2.5,
      ),
    );
  }

  double _calculateIconSize() {
    // If both height and width are null, use fixed padding
    if (height == null || width == null) return 28;
    // Use the smaller dimension to calculate dynamic padding
    return height! < width! ? height! : width!;
  }

  Widget _buildErrorImage() {
    final double iconSize = _calculateIconSize();
    return Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: iconSize,
        color: Colors.red,
      ),
    );
  }
}
