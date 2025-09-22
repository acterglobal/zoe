import 'package:flutter/material.dart';
import 'dart:math' show pi;

/// A widget that displays the animated search character
class EmptyStateMagnifierWidget extends StatelessWidget {
  final Color color;
  final Animation<double> mouthAnimation;

  const EmptyStateMagnifierWidget({
    super.key,
    required this.color,
    required this.mouthAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [_buildFace(context), _buildMagnifyingHandle(context)],
      ),
    );
  }

  Widget _buildFace(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: Stack(children: [_buildEyes(context), _buildMouth()]),
    );
  }

  Widget _buildEyes(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 25, left: 20, child: _Eye(color: color)),
        Positioned(top: 25, right: 20, child: _Eye(color: color)),
      ],
    );
  }

  Widget _buildMouth() {
    return Positioned(
      bottom: 15,
      left: 20,
      right: 20,
      height: 20,
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

  Widget _buildMagnifyingHandle(BuildContext context) {
    return Positioned(
      bottom: -8,
      right: -50,
      child: Transform.rotate(
        angle: -pi / 1.3,
        child: Container(
          width: 70,
          height: 15,
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
      width: 12,
      height: 12,
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
