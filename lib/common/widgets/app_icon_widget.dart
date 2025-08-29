import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/shimmer_overlay_widget.dart';

class AppIconWidget extends StatelessWidget {
  final double size;
  const AppIconWidget({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
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
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset('assets/icon/app_icon.png', width: size, height: size),
      ),
    );
  }
}
