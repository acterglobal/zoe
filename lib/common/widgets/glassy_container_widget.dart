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
    this.shadowOpacity = 0.1,
    this.blurRadius = 20,
    this.shadowOffset = const Offset(0, 8),
    this.borderOpacity = 0.1,
    this.surfaceOpacity = 0.8,
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
            BoxShadow(
              color: (shadowColor ?? colorScheme.primary).withValues(
                alpha: shadowOpacity + 0.05,
              ),
              blurRadius: blurRadius,
              offset: shadowOffset,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: blurRadius * 2,
              offset: Offset(shadowOffset.dx, shadowOffset.dy * 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
