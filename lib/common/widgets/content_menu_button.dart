import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';

class ContentMenuButton extends StatelessWidget {
  final Function(BuildContext context) onTap;
  const ContentMenuButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return StyledIconContainer(
      icon: Icons.more_vert_rounded,
      onTap: () => onTap(context),
      size: 40,
      iconSize: 20,
      primaryColor: colorScheme.onSurface,
      secondaryColor: colorScheme.onSurface.withValues(alpha: 0.4),
      backgroundOpacity: 0.08,
      borderOpacity: 0.15,
      shadowOpacity: 0.1,
    );
  }
}
