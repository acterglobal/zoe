import 'package:flutter/material.dart';

class ComingSoonBadge extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const ComingSoonBadge({
    super.key,
    this.text = '',
    this.margin,
    this.padding,
    this.fontSize,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        // color: backgroundColor ?? theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        border: Border(
          left: BorderSide(
            color: borderColor ?? theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 0.8,
          ),
          bottom: BorderSide(
            color: borderColor ?? theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 0.8,
          ),
        
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: fontSize ?? 8,
          fontWeight: FontWeight.w500,
          color: textColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
