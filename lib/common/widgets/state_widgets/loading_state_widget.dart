import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? backgroundColor;

  const LoadingStateWidget({
    super.key,
    this.height = 120,
    this.width = double.infinity,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor ?? theme.colorScheme.surface,
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
