import 'package:flutter/material.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';

class GlassyContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? shadowColor;
  final double shadowOpacity;
  final double blurRadius;
  final Offset shadowOffset;
  final double borderOpacity;
  final double surfaceOpacity;
  final List<Color>? customGradientColors;

  const GlassyContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.shadowColor,
    this.shadowOpacity = 0.05, // Reduced for subtlety
    this.blurRadius = 12, // Reduced for cleaner look
    this.shadowOffset = const Offset(0, 4), // Reduced offset
    this.borderOpacity = 0.15, // Slightly increased for definition
    this.surfaceOpacity = 0.85, // Slightly increased for better visibility
    this.customGradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(20);

    final defaultGradientColors = isDark
        ? [
            colorScheme.surface.withValues(alpha: surfaceOpacity),
            colorScheme.surface.withValues(alpha: surfaceOpacity * 0.75),
            colorScheme.surface.withValues(alpha: surfaceOpacity * 0.5),
          ]
        : [
            AppColors.getWarmSurfaceWithAlpha(context, surfaceOpacity + 0.1),
            AppColors.getWarmSurfaceWithAlpha(context, surfaceOpacity - 0.1),
            AppColors.getWarmSurfaceWithAlpha(context, surfaceOpacity - 0.2),
          ];

    return Container(
      margin: margin,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: customGradientColors ?? defaultGradientColors,
            stops: const [0.0, 0.5, 1.0],
          ),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: borderOpacity)
                : AppColors.getWarmSurfaceWithAlpha(
                    context,
                    borderOpacity + 0.7,
                  ),
            width: 1.5,
          ),
          boxShadow: [
            // Subtle inner glow effect for glassmorphism
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
            // Very subtle depth shadow
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
