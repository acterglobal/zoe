import 'package:flutter/material.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_search_face_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_sheet_widget.dart';
import 'package:zoe/core/constants/empty_state_constants.dart';
import 'package:zoe/features/content/models/content_model.dart';

/// A widget that displays an empty state with an animated character
class EmptyContentTypeWidget extends StatefulWidget {
  final String message;
  final Color color;
  final ContentType? contentType;

  const EmptyContentTypeWidget({
    super.key,
    required this.message,
    required this.color,
    this.contentType,
  });

  @override
  State<EmptyContentTypeWidget> createState() => _EmptyContentTypeWidgetState();
}

class _EmptyContentTypeWidgetState extends State<EmptyContentTypeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _mouthAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: EmptyContentTypeConstants.animationDuration,
      ),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3)),
    );

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
    final theme = Theme.of(context);
    return SizedBox.expand(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAnimatedArea(theme),
            const SizedBox(height: 24),
            _buildMessage(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedArea(ThemeData theme) {
    return SizedBox(
      height: EmptyContentTypeConstants.containerHeight,
      width: EmptyContentTypeConstants.containerWidth,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            EmptyStateSheetWidget(
              color: widget.color,
              contentType: widget.contentType,
            ),
            _buildCharacter(theme),
          ],
        ),
      ),
    );
  }
 
  Widget _buildCharacter(ThemeData theme) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: EmptyStateSearchFaceWidget(
        color: widget.color,
        mouthAnimation: _mouthAnimation,
      ),
    );
  }

  Widget _buildMessage(ThemeData theme) {
    return Text(
      widget.message,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }
}

