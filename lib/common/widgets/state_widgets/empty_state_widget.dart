import 'dart:math';
import 'package:flutter/material.dart';

/// Constants for the empty state widget
class _EmptyStateConstants {
  static const double containerHeight = 220;
  static const double containerWidth = 260;
  static const double sheetWidth = 200;
  static const double sheetHeight = 220;
  static const double headerHeight = 40;
  static const double taskLineSpacing = 10;
  static const double taskLineHeight = 10;
  static const double checkboxSize = 16;
  static const double checkboxSpacing = 12;
  static const double characterSize = 120;
  static const double faceSize = 80;
  static const double eyeSize = 12;
  static const double eyeTopPosition = 25;
  static const double eyeSidePosition = 20;
  static const double mouthHeight = 20;
  static const double mouthBottomPosition = 15;
  static const double handleWidth = 70;
  static const double handleHeight = 15;
  static const double handleBottomPosition = -8;
  static const double handleRightPosition = -50;
  static const double handleRotation = -pi / 1.3;
  static const int animationDuration = 3000;
  static const int taskLines = 4;
}

/// A widget that displays an empty state with an animated character
/// and customizable message.
class EmptyStateWidget extends StatefulWidget {
  /// The main message to display
  final String message;

  /// Optional subtitle text
  final String? subtitle;

  /// Icon to display (currently not used in the animation)
  final IconData icon;

  /// Custom color for the widget (falls back to theme primary)
  final Color? color;

  /// Optional height constraint
  final double? height;

  /// Optional width constraint
  final double? width;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.event_busy,
    this.color,
    this.height,
    this.width,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
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
      duration: const Duration(milliseconds: _EmptyStateConstants.animationDuration),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3)),
    );

    _mouthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      height: _EmptyStateConstants.containerHeight,
      width: _EmptyStateConstants.containerWidth,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            _buildBackgroundSheet(theme),
            _buildCharacter(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundSheet(ThemeData theme) {
    return Container(
      width: _EmptyStateConstants.sheetWidth,
      height: _EmptyStateConstants.sheetHeight,
      decoration: _getSheetDecoration(theme),
      child: Column(
        children: [
          _buildSheetHeader(theme),
          ..._buildTaskLines(theme),
        ],
      ),
    );
  }

  BoxDecoration _getSheetDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: (widget.color ?? theme.colorScheme.primary).withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildSheetHeader(ThemeData theme) {
    return Container(
      height: _EmptyStateConstants.headerHeight,
      decoration: BoxDecoration(
        color: (widget.color ?? theme.colorScheme.primary).withValues(alpha: 0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: (widget.color ?? theme.colorScheme.primary).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTaskLines(ThemeData theme) {
    return List.generate(
      _EmptyStateConstants.taskLines,
      (index) => _TaskLineItem(color: widget.color ?? theme.colorScheme.primary),
    );
  }

  Widget _buildCharacter(ThemeData theme) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: _SearchCharacter(
        color: widget.color ?? theme.colorScheme.primary,
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

/// A widget that represents a single task line item in the background sheet
class _TaskLineItem extends StatelessWidget {
  final Color color;

  const _TaskLineItem({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: _EmptyStateConstants.taskLineSpacing,
      ),
      child: Row(
        children: [
          _buildCheckbox(),
          const SizedBox(width: _EmptyStateConstants.checkboxSpacing),
          _buildLine(),
        ],
      ),
    );
  }

  Widget _buildCheckbox() {
    return Container(
      width: _EmptyStateConstants.checkboxSize,
      height: _EmptyStateConstants.checkboxSize,
      decoration: BoxDecoration(
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildLine() {
    return Expanded(
      child: Container(
        height: _EmptyStateConstants.taskLineHeight,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

/// A widget that displays the animated search character
class _SearchCharacter extends StatelessWidget {
  final Color color;
  final Animation<double> mouthAnimation;

  const _SearchCharacter({
    required this.color,
    required this.mouthAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: _EmptyStateConstants.characterSize,
      height: _EmptyStateConstants.characterSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          _buildFace(theme),
          _buildMagnifyingHandle(theme),
        ],
      ),
    );
  }

  Widget _buildFace(ThemeData theme) {
    return Container(
      width: _EmptyStateConstants.faceSize,
      height: _EmptyStateConstants.faceSize,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          _buildEyes(theme),
          _buildMouth(),
        ],
      ),
    );
  }

  Widget _buildEyes(ThemeData theme) {
    return Stack(
      children: [
        Positioned(
          top: _EmptyStateConstants.eyeTopPosition,
          left: _EmptyStateConstants.eyeSidePosition,
          child: _Eye(color: color),
        ),
        Positioned(
          top: _EmptyStateConstants.eyeTopPosition,
          right: _EmptyStateConstants.eyeSidePosition,
          child: _Eye(color: color),
        ),
      ],
    );
  }

  Widget _buildMouth() {
    return Positioned(
      bottom: _EmptyStateConstants.mouthBottomPosition,
      left: _EmptyStateConstants.eyeSidePosition,
      right: _EmptyStateConstants.eyeSidePosition,
      height: _EmptyStateConstants.mouthHeight,
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
      bottom: _EmptyStateConstants.handleBottomPosition,
      right: _EmptyStateConstants.handleRightPosition,
      child: Transform.rotate(
        angle: _EmptyStateConstants.handleRotation,
        child: Container(
          width: _EmptyStateConstants.handleWidth,
          height: _EmptyStateConstants.handleHeight,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
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
      width: _EmptyStateConstants.eyeSize,
      height: _EmptyStateConstants.eyeSize,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: 0.8),
          width: 2,
        ),
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
    final control = Offset(
      size.width / 2,
      size.height / 2 + (mood * 20),
    );

    path.moveTo(start.dx, start.dy);
    path.quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MouthPainter oldDelegate) {
    return oldDelegate.mood != mood;
  }
}
