import 'package:flutter/material.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class AnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String?) onErrorChanged;
  final VoidCallback onSubmitted;

  const AnimatedTextField({
    super.key,
    required this.controller,
    this.errorText,
    required this.onErrorChanged,
    required this.onSubmitted,
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
              hintText: L10n.of(context).pleaseEnterAValidURL,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  width: 1,
                ),
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              errorText: widget.errorText,
            ),
            keyboardType: TextInputType.url,
            autofocus: true,
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
