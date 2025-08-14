import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/shimmer_overlay_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ZoePrimaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? primaryColor;
  final Color? secondaryColor;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final bool showShimmer;
  final bool showHighlight;
  final Duration shimmerDuration;
  final double height;
  final double? width;

  const ZoePrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.primaryColor,
    this.secondaryColor,
    this.contentPadding,
    this.borderRadius,
    this.showShimmer = true,
    this.showHighlight = true,
    this.shimmerDuration = const Duration(seconds: 3),
    this.height = 56,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectivePrimaryColor = primaryColor ?? theme.colorScheme.primary;
    final effectiveSecondaryColor =
        secondaryColor ?? theme.colorScheme.secondary;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final effectiveContentPadding =
        contentPadding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    Widget buttonWidget = Container(
      width: width,
      height: height,
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
          // Subtle elevation shadow
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          // Very subtle depth
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: effectiveBorderRadius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: effectiveBorderRadius,
          child: Container(
            width: width,
            height: height,
            padding: effectiveContentPadding,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    text ?? L10n.of(context).primaryButton,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
