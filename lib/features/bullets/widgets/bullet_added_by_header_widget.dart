import 'package:flutter/material.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class BulletAddedByHeaderWidget extends StatelessWidget {
  final double? iconSize;
  final double? textSize;
  const BulletAddedByHeaderWidget({super.key, this.iconSize = 20, this.textSize = 14});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.person_rounded, size: iconSize, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
        const SizedBox(width: 5),
        Text(
          L10n.of(context).addedBy,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: textSize,
          )
        ),
      ],
    );
  }
}