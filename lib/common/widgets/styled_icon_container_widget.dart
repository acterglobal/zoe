import 'package:flutter/material.dart';

class StyledIconContainer extends StatelessWidget {
  final IconData icon;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double size;
  final double iconSize;
  final BorderRadius? borderRadius;
  final bool showHighlight;
  final double backgroundOpacity;
  final double borderOpacity;
  final double shadowOpacity;

  const StyledIconContainer({
    super.key,
    required this.icon,
    this.primaryColor,
    this.secondaryColor,
    this.size = 64,
    this.iconSize = 32,
    this.borderRadius,
    this.showHighlight = true,
    this.backgroundOpacity = 0.12,
    this.borderOpacity = 0.2,
    this.shadowOpacity = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final effectivePrimaryColor = primaryColor ?? colorScheme.primary;
    final effectiveSecondaryColor = secondaryColor ?? colorScheme.secondary;
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(size * 0.28);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            effectivePrimaryColor.withValues(alpha: backgroundOpacity),
            effectivePrimaryColor.withValues(alpha: backgroundOpacity * 0.67),
            effectiveSecondaryColor.withValues(alpha: backgroundOpacity * 0.5),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        border: Border.all(
          color: effectivePrimaryColor.withValues(alpha: borderOpacity),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: effectivePrimaryColor.withValues(alpha: shadowOpacity),
            blurRadius: size * 0.125,
            offset: Offset(0, size * 0.03),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: effectivePrimaryColor.withValues(
              alpha: shadowOpacity * 0.53,
            ),
            blurRadius: size * 0.25,
            offset: Offset(0, size * 0.06),
            spreadRadius: size * 0.015,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background highlight for depth
          if (showHighlight)
            Positioned(
              top: size * 0.125,
              left: size * 0.125,
              right: size * 0.25,
              child: Container(
                height: size * 0.19,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size * 0.125),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: isDark ? 0.15 : 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          // Icon
          Center(
            child: Icon(icon, color: effectivePrimaryColor, size: iconSize),
          ),
        ],
      ),
    );
  }
}
