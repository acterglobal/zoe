import 'package:flutter/material.dart';
import 'package:zoe/core/constants/empty_state_constants.dart';

/// A widget that displays the animated search character
class EmptyStateSearchFaceWidget extends StatelessWidget {
  final Color color;
  final Animation<double> mouthAnimation;

   const EmptyStateSearchFaceWidget({super.key, required this.color, required this.mouthAnimation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: EmptyContentTypeConstants.characterSize,
      height: EmptyContentTypeConstants.characterSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [_buildFace(theme), _buildMagnifyingHandle(theme)],
      ),
    );
  }

  Widget _buildFace(ThemeData theme) {
    return Container(
      width: EmptyContentTypeConstants.faceSize,
      height: EmptyContentTypeConstants.faceSize,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: Stack(children: [_buildEyes(theme), _buildMouth()]),
    );
  }

  Widget _buildEyes(ThemeData theme) {
    return Stack(
      children: [
        Positioned(
          top: EmptyContentTypeConstants.eyeTopPosition,
          left: EmptyContentTypeConstants.eyeSidePosition,
          child: _Eye(color: color),
        ),
        Positioned(
          top: EmptyContentTypeConstants.eyeTopPosition,
          right: EmptyContentTypeConstants.eyeSidePosition,
          child: _Eye(color: color),
        ),
      ],
    );
  }

  Widget _buildMouth() {
    return Positioned(
      bottom: EmptyContentTypeConstants.mouthBottomPosition,
      left: EmptyContentTypeConstants.eyeSidePosition,
      right: EmptyContentTypeConstants.eyeSidePosition,
      height: EmptyContentTypeConstants.mouthHeight,
      child: AnimatedBuilder(
        animation: mouthAnimation,
        builder: (context, child) => CustomPaint(
          painter: _MouthPainter(
            mouthAnimation.value,
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildMagnifyingHandle(ThemeData theme) {
    return Positioned(
      bottom: EmptyContentTypeConstants.handleBottomPosition,
      right: EmptyContentTypeConstants.handleRightPosition,
      child: Transform.rotate(
        angle: EmptyContentTypeConstants.handleRotation,
        child: Container(
          width: EmptyContentTypeConstants.handleWidth,
          height: EmptyContentTypeConstants.handleHeight,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
        ),
      ),
    );
  }
}

/// A widget that represents an eye in the character's face
class _Eye extends StatelessWidget {
  final Color color;

  const _Eye({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: EmptyContentTypeConstants.eyeSize,
      height: EmptyContentTypeConstants.eyeSize,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.8), width: 2),
      ),
    );
  }
}

/// Custom painter for the animated mouth
class _MouthPainter extends CustomPainter {
  final double mood;
  final Color color;

  const _MouthPainter(this.mood, {required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final start = Offset(0, size.height / 2);
    final end = Offset(size.width, size.height / 2);
    final control = Offset(size.width / 2, size.height / 2 + (mood * 20));

    path.moveTo(start.dx, start.dy);
    path.quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MouthPainter oldDelegate) {
    return oldDelegate.mood != mood;
  }
}
