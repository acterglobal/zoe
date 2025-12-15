import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class InfoDialogWidget extends StatelessWidget {
  final double iconSize;
  final IconData? icon;
  final String title;
  final String description;
  final String? primaryButtonText;
  final VoidCallback onPrimary;
  final String? secondaryButtonText;
  final VoidCallback? onSecondary;

  const InfoDialogWidget({
    super.key,
    required this.iconSize,
    this.icon,
    required this.title,
    required this.description,
    this.primaryButtonText,
    required this.onPrimary,
    this.secondaryButtonText,
    this.onSecondary,
  });

  static Future<void> show(
    BuildContext context, {
    double iconSize = 130,
    IconData? icon,
    required String title,
    required String description,
    bool barrierDismissible = true,
    String? primaryButtonText,
    required VoidCallback onPrimary,
    String? secondaryButtonText,
    VoidCallback? onSecondary,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => InfoDialogWidget(
        iconSize: iconSize,
        icon: icon,
        title: title,
        description: description,
        primaryButtonText: primaryButtonText,
        onPrimary: onPrimary,
        secondaryButtonText: secondaryButtonText,
        onSecondary: onSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaxWidthWidget(
      child: Dialog(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[_iconWithGlow(theme), SizedBox(height: 24)],
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge,
              ),
              SizedBox(height: 24),
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 30),
              ZoePrimaryButton(
                onPressed: () {
                  context.pop();
                  onPrimary.call();
                },
                text: primaryButtonText ?? L10n.of(context).confirm,
              ),
              if (onSecondary != null) ...[
                SizedBox(height: 20),
                ZoeSecondaryButton(
                  borderWidth: 2,
                  onPressed: onSecondary!,
                  text: secondaryButtonText ?? L10n.of(context).cancel,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconWithGlow(ThemeData theme) {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary.withValues(alpha: 0.15),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Icon(icon, size: iconSize / 2, color: theme.colorScheme.primary),
    );
  }
}
