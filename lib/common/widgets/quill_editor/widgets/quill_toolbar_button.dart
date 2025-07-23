import 'package:flutter/material.dart';

/// Build a custom toolbar button with consistent styling
Widget buildToolbarButton({
  required BuildContext context,
  required IconData icon,
  required bool isActive,
  required VoidCallback onPressed,
}) {
  final theme = Theme.of(context);
  final borderRadius = BorderRadius.circular(8);
  
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: isActive
          ? theme.colorScheme.primary.withValues(alpha: 0.1)
          : theme.colorScheme.surface,
      borderRadius: borderRadius,
      border: Border.all(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withValues(alpha: 0.2),
        width: 1,
      ),
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onPressed,
        child: Icon(
          icon,
          size: 18,
          color: isActive 
              ? theme.colorScheme.primary 
              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    ),
  );
}