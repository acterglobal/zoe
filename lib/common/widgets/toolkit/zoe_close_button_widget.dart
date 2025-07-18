import 'package:flutter/material.dart';

class ZoeCloseButtonWidget extends StatelessWidget {
  final double? size;
  final Color? color;
  final VoidCallback onTap;

  const ZoeCloseButtonWidget({
    super.key,
    this.size = 16,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.close,
        size: size,
        color:
            color ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }
}
