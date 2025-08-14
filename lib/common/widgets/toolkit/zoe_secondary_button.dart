import 'package:flutter/material.dart';
import 'package:Zoe/common/widgets/shimmer_overlay_widget.dart';
import 'package:Zoe/l10n/generated/l10n.dart';

class ZoeSecondaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? primaryColor;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final bool showShimmer;
  final bool showHighlight;
  final Duration shimmerDuration;
  final double height;
  final double? width;
  final double borderWidth;

  const ZoeSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.primaryColor,
    this.contentPadding,
    this.borderRadius,
    this.showShimmer = false,
    this.showHighlight = true,
    this.shimmerDuration = const Duration(seconds: 3),
    this.height = 56,
    this.width,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectivePrimaryColor = primaryColor ?? theme.colorScheme.primary;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final effectiveContentPadding =
        contentPadding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    Widget buttonWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        color: isDark ? Colors.transparent : theme.colorScheme.surface,
        border: Border.all(
          color: effectivePrimaryColor.withValues(alpha: 0.8),
          width: borderWidth,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: effectiveBorderRadius,
        child: Container(
          width: width,
          height: height,
          padding: effectiveContentPadding,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: effectivePrimaryColor,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
              ],
              Text(
                text ?? L10n.of(context).cancel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: effectivePrimaryColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
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
          effectivePrimaryColor.withValues(alpha: 0.02),
          effectivePrimaryColor.withValues(alpha: 0.04),
          effectivePrimaryColor.withValues(alpha: 0.02),
          Colors.transparent,
        ],
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
