import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeAnimationWidget extends ConsumerStatefulWidget {
  const WelcomeAnimationWidget({super.key});

  @override
  ConsumerState<WelcomeAnimationWidget> createState() =>
      _WelcomeAnimationWidgetState();
}

class _WelcomeAnimationWidgetState extends ConsumerState<WelcomeAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Floating animation
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Rotation animation
    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _floatController.repeat(reverse: true);
    _rotateController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _floatAnimation,
        _rotateAnimation,
        _pulseAnimation,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background particles/effects
              ..._buildBackgroundParticles(),
              // Main Zoe persona
              Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.rocket_launch_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              // Orbiting elements
              ..._buildOrbitingElements(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBackgroundParticles() {
    return List.generate(6, (index) {
      final angle = (index * 60.0) * (math.pi / 180);
      final radius = 40.0 + (index * 8.0);

      return Transform.rotate(
        angle: _rotateAnimation.value + angle,
        child: Transform.translate(
          offset: Offset(
            radius * math.cos(_rotateAnimation.value + angle),
            radius * math.sin(_rotateAnimation.value + angle),
          ),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.4),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.6),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildOrbitingElements() {
    final elements = [
      Icons.star_rounded,
      Icons.favorite_rounded,
      Icons.bolt_rounded,
    ];

    return List.generate(elements.length, (index) {
      final angle = (index * 120.0) * (math.pi / 180);
      final radius = 60.0;

      return Transform.rotate(
        angle: _rotateAnimation.value * 0.5,
        child: Transform.translate(
          offset: Offset(
            radius * math.cos(_rotateAnimation.value * 0.5 + angle),
            radius * math.sin(_rotateAnimation.value * 0.5 + angle),
          ),
          child: Transform.scale(
            scale: _pulseAnimation.value * 0.8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Icon(
                elements[index],
                size: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      );
    });
  }
}
