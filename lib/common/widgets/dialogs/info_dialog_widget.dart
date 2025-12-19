import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/utils/validation_utils.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class InfoDialogWidget extends StatefulWidget {
  final double iconSize;
  final IconData? icon;
  final String title;
  final String description;
  final bool isShowTextField;
  final bool isFieldRequired;
  final String? labelText;
  final String? hintText;
  final String? primaryButtonText;
  final Function(String) onPrimary;
  final String? secondaryButtonText;
  final VoidCallback? onSecondary;

  const InfoDialogWidget({
    super.key,
    required this.iconSize,
    this.icon,
    required this.title,
    required this.description,
    required this.isShowTextField,
    required this.isFieldRequired,
    this.labelText,
    this.hintText,
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
    bool isShowTextField = false,
    bool isFieldRequired = false,
    String? labelText,
    String? hintText,
    String? primaryButtonText,
    required Function(String) onPrimary,
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
        isShowTextField: isShowTextField,
        isFieldRequired: isFieldRequired,
        labelText: labelText,
        hintText: hintText,
        primaryButtonText: primaryButtonText,
        onPrimary: onPrimary,
        secondaryButtonText: secondaryButtonText,
        onSecondary: onSecondary,
      ),
    );
  }

  @override
  State<InfoDialogWidget> createState() => _InfoDialogWidgetState();
}

class _InfoDialogWidgetState extends State<InfoDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
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
              if (widget.icon != null) ...[
                _iconWithGlow(theme),
                SizedBox(height: 24),
              ],
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge,
              ),
              SizedBox(height: 24),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 30),
              if (widget.isShowTextField) ...[
                Form(
                  key: _formKey,
                  child: AnimatedTextField(
                    controller: _valueController,
                    labelText: widget.labelText,
                    hintText: widget.hintText ?? L10n.of(context).typeSomething,
                    obscureText: _obscureText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (value) =>
                        ValidationUtils.validatePassword(context, value),
                  ),
                ),
                SizedBox(height: 20),
              ],
              ZoePrimaryButton(
                onPressed: () {
                  if (widget.isShowTextField && widget.isFieldRequired) {
                    if (_formKey.currentState?.validate() == false) return;
                    context.pop();
                    widget.onPrimary(_valueController.text);
                  } else {
                    context.pop();
                    widget.onPrimary(_valueController.text);
                  }
                },
                text: widget.primaryButtonText ?? L10n.of(context).confirm,
              ),
              if (widget.onSecondary != null) ...[
                SizedBox(height: 20),
                ZoeSecondaryButton(
                  borderWidth: 2,
                  onPressed: widget.onSecondary!,
                  text: widget.secondaryButtonText ?? L10n.of(context).cancel,
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
      width: widget.iconSize,
      height: widget.iconSize,
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
      child: Icon(
        widget.icon,
        size: widget.iconSize / 2,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
