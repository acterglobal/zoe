import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_custom_bg_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_magnifier_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';

/// A widget that displays an empty state with an animated character and optional content sheet
class EmptyStateListWidget extends StatefulWidget {
  final String message;
  final Color color;
  final ContentType? contentType;

  const EmptyStateListWidget({
    super.key,
    required this.message,
    required this.color,
    this.contentType,
  });

  @override
  State<EmptyStateListWidget> createState() => _EmptyContentTypeWidgetState();
}

class _EmptyContentTypeWidgetState extends State<EmptyStateListWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _mouthAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _mouthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAnimatedArea(context),
            const SizedBox(height: 24),
            _buildMessage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedArea(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 260,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            EmptyStateCustomBgWidget(
              color: widget.color,
              contentType: widget.contentType,
            ),
            EmptyStateMagnifierWidget(
              color: widget.color,
              mouthAnimation: _mouthAnimation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      widget.message,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }
}
