import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/shimmer_overlay_widget.dart';

class ZoeFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;
  final IconData? icon;
  final double size;
  final Color? primaryColor;
  final Color? secondaryColor;
  final BorderRadius? borderRadius;
  final Duration shimmerDuration;
  final bool showShimmer;
  final bool showHighlight;
  final double iconSize;

  const ZoeFloatingActionButton({
    super.key,
    required this.onPressed,
    this.child,
    this.icon,
    this.size = 56,
    this.primaryColor,
    this.secondaryColor,
    this.borderRadius,
    this.shimmerDuration = const Duration(seconds: 3),
    this.showShimmer = true,
    this.showHighlight = false,
    this.iconSize = 32,
  }) : assert(
         child != null || icon != null,
         'Either child or icon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectivePrimaryColor = primaryColor ?? theme.colorScheme.primary;
    final effectiveSecondaryColor =
        secondaryColor ?? theme.colorScheme.secondary;
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(size * 0.36);

    Widget fabWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            effectivePrimaryColor,
            effectivePrimaryColor.withValues(alpha: 0.85),
            effectiveSecondaryColor.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.2 : 0.3),
          width: 1.5,
        ),
        boxShadow: [
          // Primary colored shadow
          BoxShadow(
            color: effectivePrimaryColor.withValues(alpha: 0.4),
            blurRadius: size * 0.36,
            offset: Offset(0, size * 0.14),
            spreadRadius: 0,
          ),
          // Depth shadow
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.6)
                : Colors.black.withValues(alpha: 0.15),
            blurRadius: size * 0.45,
            offset: Offset(0, size * 0.21),
            spreadRadius: size * 0.036,
          ),
          // Glow effect
          BoxShadow(
            color: effectivePrimaryColor.withValues(alpha: 0.2),
            blurRadius: size * 0.625,
            offset: const Offset(0, 0),
            spreadRadius: size * 0.089,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: effectiveBorderRadius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: effectiveBorderRadius,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                // Highlight effect for depth (non-interactive)
                if (showHighlight)
                  Positioned(
                    top: size * 0.14,
                    left: size * 0.14,
                    right: size * 0.29,
                    child: IgnorePointer(
                      child: Container(
                        height: size * 0.21,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(size * 0.14),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(
                                alpha: isDark ? 0.2 : 0.4,
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                // FloatingActionButton content
                Center(
                  child:
                      child ??
                      Icon(
                        icon!,
                        color: Colors.white,
                        size: iconSize,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (showShimmer) {
      return ShimmerOverlay(
        borderRadius: effectiveBorderRadius,
        duration: shimmerDuration,
        shimmerColors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.04),
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        child: fabWidget,
      );
    }

    return fabWidget;
  }
}
