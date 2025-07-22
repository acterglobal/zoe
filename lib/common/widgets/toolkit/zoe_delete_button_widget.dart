import 'package:flutter/material.dart';

class ZoeDeleteButtonWidget extends StatelessWidget {
  final double? size;
  final Color? color;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;

  const ZoeDeleteButtonWidget({
    super.key,
    this.size = 18,
    this.color,
    required this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        child: Icon(
          Icons.delete_outlined,
          size: size,
          color:
              color ??
              Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
