import 'package:flutter/material.dart';

class AnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final String hintText;
  final Function(String?) onErrorChanged;
  final VoidCallback onSubmitted;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType keyboardType;
  final int? maxLines;

  const AnimatedTextField({
    super.key,
    required this.controller,
    this.errorText,
    required this.hintText,
    required this.onErrorChanged,
    required this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = true,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

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

    // Trigger shake animation when error text changes
    if (oldWidget.errorText == null && widget.errorText != null) {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value * 10 * (widget.errorText != null ? 1 : 0),
            0,
          ),
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.4),
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
                borderSide: BorderSide(color: colorScheme.error, width: 1),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: widget.enabled ? 0.1 : 0.05,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: widget.maxLines != null && widget.maxLines! > 1
                    ? 12
                    : 16,
              ),
              errorText: widget.errorText,
            ),
            keyboardType: widget.keyboardType,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            onChanged: (value) {
              if (widget.errorText != null) {
                widget.onErrorChanged(null);
              }
            },
            onSubmitted: (value) => widget.onSubmitted(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
}
