import 'package:flutter/material.dart';

class ShimmerOverlay extends StatefulWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final Duration duration;
  final List<Color>? shimmerColors;
  final List<double>? shimmerStops;

  const ShimmerOverlay({
    super.key,
    required this.child,
    this.borderRadius,
    this.duration = const Duration(seconds: 2),
    this.shimmerColors,
    this.shimmerStops,
  });

  @override
  State<ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultShimmerColors = [
      Colors.transparent,
      Colors.white.withValues(alpha: 0.2),
      Colors.white.withValues(alpha: 0.5),
      Colors.white.withValues(alpha: 0.2),
      Colors.transparent,
    ];

    final defaultShimmerStops = [0.0, 0.3, 0.5, 0.7, 1.0];

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: widget.borderRadius ?? BorderRadius.zero,
              child: AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-1.0 + _shimmerAnimation.value, -1.0),
                        end: Alignment(1.0 + _shimmerAnimation.value, 1.0),
                        colors: widget.shimmerColors ?? defaultShimmerColors,
                        stops: widget.shimmerStops ?? defaultShimmerStops,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
