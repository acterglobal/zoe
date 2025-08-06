import 'package:flutter/material.dart';
import 'package:zoey/common/widgets/toolkit/zoe_icon_button_widget.dart';

class ZoeAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final List<Widget>? actions;
  final TextStyle? titleStyle;

  const ZoeAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = true,
    this.actions,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (showBackButton) ...[
          ZoeIconButtonWidget(
            icon: Icons.arrow_back_rounded,
            onTap: onBackPressed ?? () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Text(
            title,
            style:
                titleStyle ??
                theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
          ),
        ),
        if (actions != null) ...[const SizedBox(width: 16), ...actions!],
      ],
    );
  }
}
