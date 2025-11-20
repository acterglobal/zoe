import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';

class ZoeAppBar extends StatelessWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final List<Widget>? actions;
  final TextStyle? titleStyle;

  const ZoeAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.showBackButton = true,
    this.actions,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton) ...[
          _buildBackButton(context),
          const SizedBox(width: 16),
        ],
        if (title != null) Expanded(child: _buildTitle(context)) else Spacer(),
        if (actions != null) ...[const SizedBox(width: 16), ...actions!],
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ZoeIconButtonWidget(
      icon: Icons.arrow_back_rounded,
      onTap: onBackPressed ?? () => _handleBackNavigation(context),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    // If we can't pop, navigate to home instead
    if (context.canPop()) {
      context.pop();
    } else {
      // If there's nothing to pop (e.g., opened from deep link),
      // navigate to home instead
      context.go(AppRoutes.home.route);
    }
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title!,
      style:
          titleStyle ??
          theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
    );
  }
}
