import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/shimmer_overlay_widget.dart';

class AppIconWidget extends StatelessWidget {
  final double size;
  const AppIconWidget({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final borderRadius = BorderRadius.circular(size * 0.25);

    return ShimmerOverlay(
      borderRadius: borderRadius,
      shimmerColors: [
        Colors.transparent,
        Colors.white.withValues(alpha: 0.08),
        Colors.white.withValues(alpha: 0.2),
        Colors.white.withValues(alpha: 0.08),
        Colors.transparent,
      ],
      duration: const Duration(seconds: 2),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor,
              primaryColor.withValues(alpha: 0.8),
              secondaryColor.withValues(alpha: 0.6),
              secondaryColor,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: size * 0.15,
              offset: Offset(0, size * 0.05),
              spreadRadius: size * 0.01,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: size * 0.2,
              offset: Offset(0, size * 0.1),
            ),
          ],
        ),
        child: Icon(
          Icons.auto_stories_rounded,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}
