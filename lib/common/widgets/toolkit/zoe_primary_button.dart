import 'package:flutter/material.dart';

class ZoePrimaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final IconData? icon;
  final EdgeInsetsGeometry? contentPadding;

  const ZoePrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: contentPadding),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 8)],
          Text(
            text ?? 'Primary Button',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
