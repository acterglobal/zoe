import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';

class ZoeAppBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        if (showBackButton) ...[
          _buildBackButton(context, ref),
          const SizedBox(width: 16),
        ],
        if (title != null) Expanded(child: _buildTitle(context)) else Spacer(),
        if (actions != null) ...[const SizedBox(width: 16), ...actions!],
      ],
    );
  }

  Widget _buildBackButton(BuildContext context, WidgetRef ref) {
    return ZoeIconButtonWidget(
      icon: Icons.arrow_back_rounded,
      onTap: () {
        ref.read(editContentIdProvider.notifier).state = null;
        if (!context.mounted) return;
        if (onBackPressed != null) {
          onBackPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
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
