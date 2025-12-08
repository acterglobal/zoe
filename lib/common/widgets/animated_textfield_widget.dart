import 'package:flutter/material.dart';

class AnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final String hintText;
  final String? labelText;
  final Function(String?)? onErrorChanged;
  final VoidCallback? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const AnimatedTextField({
    super.key,
    required this.controller,
    this.errorText,
    required this.hintText,
    this.labelText,
    this.onErrorChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.maxLines = 1,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  String? _validationError;

  @override
  void initState() {
    super.initState();

    // Initialize shake animation
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger shake animation for external error text changes
    if (widget.errorText != null && oldWidget.errorText == null) {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  String? _handleValidation(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      // Trigger shake on new internal error, if no external error is present.
      if (error != null &&
          _validationError == null &&
          widget.errorText == null) {
        _shakeController.forward().then((_) => _shakeController.reverse());
      }

      if (_validationError != error) {
        setState(() {
          _validationError = error;
        });
      }
      return error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayError = widget.errorText ?? _validationError;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final shakeOffset = 0.5 - (0.5 - _shakeAnimation.value).abs();
        return Transform.translate(
          offset: Offset(shakeOffset * 20, 0),
          child: child,
        );
      },
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: .4),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error, width: 1.5),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(
            alpha: widget.enabled ? 0.1 : 0.05,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: widget.maxLines != null && widget.maxLines! > 1 ? 12 : 16,
          ),
          errorText: displayError,
        ),
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        validator: widget.validator != null ? _handleValidation : null,
        onChanged: (value) {
          if (displayError != null) {
            if (widget.onErrorChanged != null) {
              widget.onErrorChanged!(null);
            }
            if (_validationError != null) {
              setState(() {
                _validationError = null;
              });
            }
          }
        },
        onFieldSubmitted: widget.onSubmitted != null
            ? (value) => widget.onSubmitted!()
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
}
