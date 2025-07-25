import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:zoey/common/widgets/animated_background_widget.dart';
import 'package:zoey/core/theme/colors/app_colors.dart';

class PaperSheetBackgroundWidget extends StatelessWidget {
  final Widget child;
  final bool showRuledLines;
  final bool showMargin;
  final Color? paperColor;
  final double opacity;
  final double backgroundOpacity;

  const PaperSheetBackgroundWidget({
    super.key,
    required this.child,
    this.showRuledLines = true,
    this.showMargin = true,
    this.paperColor,
    this.opacity = 1.0,
    this.backgroundOpacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated background layer (consistent with other screens)
        _buildAnimatedBackground(context),
        // Paper background
        _buildPaperBackground(context),
        // Paper texture overlay
        _buildPaperTextureOverlay(context),
        // Child content
        child,
      ],
    );
  }

  Widget _buildAnimatedBackground(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBackgroundWidget(
        backgroundOpacity: backgroundOpacity,
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildPaperBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        // Use centralized warm paper gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.getWarmPaperGradient(context),
          stops: const [0.0, 0.5, 1.0],
        ),
        // Enhanced shadow for more depth
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
    );
  }

  Widget _buildPaperTextureOverlay(BuildContext context) {
    return CustomPaint(
      painter: PaperTexturePainter(
        colorScheme: Theme.of(context).colorScheme,
        isDark: Theme.of(context).brightness == Brightness.dark,
        showRuledLines: showRuledLines,
        showMargin: showMargin,
        opacity: opacity,
      ),
      size: Size.infinite,
    );
  }
}

class PaperTexturePainter extends CustomPainter {
  final ColorScheme colorScheme;
  final bool isDark;
  final bool showRuledLines;
  final bool showMargin;
  final double opacity;

  PaperTexturePainter({
    required this.colorScheme,
    required this.isDark,
    required this.showRuledLines,
    required this.showMargin,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showRuledLines) {
      _drawRuledLines(canvas, size);
    }

    if (showMargin) {
      _drawMarginLine(canvas, size);
      _drawPaperHoles(canvas, size);
    }

    _drawPaperGrain(canvas, size);
    _drawPaperCreases(canvas, size);
    _drawPaperEdgeWear(canvas, size);

    // Add extra contrast elements for dark mode
    if (isDark) {
      _drawDarkModeEnhancements(canvas, size);
    }
  }

  /// Helper method to apply opacity to alpha values
  double _applyOpacity(double baseAlpha) {
    return (baseAlpha * opacity).clamp(0.0, 1.0);
  }

  void _drawRuledLines(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = AppColors.primaryColor.withValues(alpha: _applyOpacity(0.15));

    // Draw horizontal ruled lines like notebook paper
    const lineSpacing = 32.0; // Space between lines
    const startY = 80.0; // Start below header area

    for (double y = startY; y < size.height; y += lineSpacing) {
      canvas.drawLine(
        Offset(24, y), // Always start from left edge (no margin consideration)
        Offset(size.width - 24, y),
        linePaint,
      );
    }
  }

  void _drawMarginLine(Canvas canvas, Size size) {
    final marginPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = isDark
          ? Colors.red.withValues(alpha: _applyOpacity(0.3))
          : const Color(0xFFE91E63).withValues(alpha: _applyOpacity(0.4));

    // Draw left margin line like notebook paper
    const marginX = 80.0;
    canvas.drawLine(
      const Offset(marginX, 60),
      Offset(marginX, size.height - 24),
      marginPaint,
    );
  }

  void _drawPaperGrain(Canvas canvas, Size size) {
    final grainPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = isDark
          ? Colors.white.withValues(alpha: _applyOpacity(0.12))
          : Colors.black.withValues(alpha: _applyOpacity(0.06));

    final random = math.Random(42); // Fixed seed for consistent pattern

    // Draw enhanced paper grain texture
    for (int i = 0; i < (size.width * size.height / 1500).round(); i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.2 + 0.3;

      canvas.drawCircle(Offset(x, y), radius, grainPaint);
    }

    // Add some fiber-like strokes for more realistic paper texture
    final fiberPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = isDark
          ? Colors.white.withValues(alpha: _applyOpacity(0.08))
          : Colors.black.withValues(alpha: _applyOpacity(0.04));

    for (int i = 0; i < (size.width * size.height / 8000).round(); i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final endX = startX + (random.nextDouble() - 0.5) * 20;
      final endY = startY + (random.nextDouble() - 0.5) * 4;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), fiberPaint);
    }
  }

  void _drawPaperHoles(Canvas canvas, Size size) {
    final holePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = isDark
          ? Colors.black.withValues(alpha: _applyOpacity(0.4))
          : Colors.black.withValues(alpha: _applyOpacity(0.15));

    final holeStrokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = isDark
          ? Colors.black.withValues(alpha: _applyOpacity(0.6))
          : Colors.black.withValues(alpha: _applyOpacity(0.25));

    // Draw 3-hole punch pattern
    const holeRadius = 4.0;
    const holeX = 40.0;
    final holePositions = [
      size.height * 0.15,
      size.height * 0.5,
      size.height * 0.85,
    ];

    for (final y in holePositions) {
      canvas.drawCircle(Offset(holeX, y), holeRadius, holePaint);
      canvas.drawCircle(Offset(holeX, y), holeRadius, holeStrokePaint);
    }
  }

  void _drawPaperCreases(Canvas canvas, Size size) {
    final creasePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isDark
          ? 1.0
          : 0.8 // Thicker lines in dark mode
      ..color = isDark
          ? Colors.white.withValues(alpha: _applyOpacity(0.15))
          : Colors.black.withValues(alpha: _applyOpacity(0.06));

    final creaseShadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isDark
          ? 1.5
          : 1.2 // Thicker shadows in dark mode
      ..color = isDark
          ? Colors.black.withValues(alpha: _applyOpacity(0.25))
          : Colors.black.withValues(alpha: _applyOpacity(0.03));

    // Draw diagonal creases - like paper that's been folded
    _drawDiagonalCrease(
      canvas,
      size,
      creasePaint,
      creaseShadowPaint,
      0.2,
      0.1,
      0.4,
      0.3,
    );
    _drawDiagonalCrease(
      canvas,
      size,
      creasePaint,
      creaseShadowPaint,
      0.6,
      0.2,
      0.8,
      0.4,
    );
    _drawDiagonalCrease(
      canvas,
      size,
      creasePaint,
      creaseShadowPaint,
      0.1,
      0.6,
      0.3,
      0.8,
    );
    _drawDiagonalCrease(
      canvas,
      size,
      creasePaint,
      creaseShadowPaint,
      0.7,
      0.6,
      0.9,
      0.8,
    );

    // Draw horizontal creases - like paper that's been bent
    _drawHorizontalCrease(canvas, size, creasePaint, creaseShadowPaint, 0.25);
    _drawHorizontalCrease(canvas, size, creasePaint, creaseShadowPaint, 0.75);

    // Draw corner creases - like page corners that have been folded
    _drawCornerCrease(
      canvas,
      size,
      creasePaint,
      creaseShadowPaint,
      true,
      true,
    ); // top-right
    _drawCornerCrease(
      canvas,
      size,
      creasePaint,
      creaseShadowPaint,
      false,
      false,
    ); // bottom-left
  }

  void _drawDiagonalCrease(
    Canvas canvas,
    Size size,
    Paint creasePaint,
    Paint shadowPaint,
    double startXRatio,
    double startYRatio,
    double endXRatio,
    double endYRatio,
  ) {
    final startX = startXRatio * size.width;
    final startY = startYRatio * size.height;
    final endX = endXRatio * size.width;
    final endY = endYRatio * size.height;

    // Draw shadow first (slightly offset)
    canvas.drawLine(
      Offset(startX + 1, startY + 1),
      Offset(endX + 1, endY + 1),
      shadowPaint,
    );

    // Draw main crease line
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), creasePaint);
  }

  void _drawHorizontalCrease(
    Canvas canvas,
    Size size,
    Paint creasePaint,
    Paint shadowPaint,
    double yRatio,
  ) {
    final y = yRatio * size.height;
    final startX = size.width * 0.1;
    final endX = size.width * 0.9;

    // Create a slightly wavy horizontal crease
    final path = Path();
    final shadowPath = Path();

    path.moveTo(startX, y);
    shadowPath.moveTo(startX + 1, y + 1);

    for (double x = startX; x <= endX; x += 10) {
      final waveY = y + math.sin((x - startX) * 0.02) * 1.5;
      path.lineTo(x, waveY);
      shadowPath.lineTo(x + 1, waveY + 1);
    }

    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(path, creasePaint);
  }

  void _drawCornerCrease(
    Canvas canvas,
    Size size,
    Paint creasePaint,
    Paint shadowPaint,
    bool isTopRight,
    bool isBottomLeft,
  ) {
    if (isTopRight) {
      // Top-right corner crease
      final startX = size.width * 0.85;
      final startY = size.height * 0.05;
      final endX = size.width * 0.95;
      final endY = size.height * 0.15;

      canvas.drawLine(
        Offset(startX + 1, startY + 1),
        Offset(endX + 1, endY + 1),
        shadowPaint,
      );
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), creasePaint);
    }

    if (isBottomLeft) {
      // Bottom-left corner crease
      final startX = size.width * 0.05;
      final startY = size.height * 0.85;
      final endX = size.width * 0.15;
      final endY = size.height * 0.95;

      canvas.drawLine(
        Offset(startX + 1, startY + 1),
        Offset(endX + 1, endY + 1),
        shadowPaint,
      );
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), creasePaint);
    }
  }

  void _drawDarkModeEnhancements(Canvas canvas, Size size) {
    // Add subtle highlight lines for better visibility in dark mode
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3
      ..color = Colors.white.withValues(alpha: _applyOpacity(0.08));

    final random = math.Random(456); // Different seed for highlights

    // Add some subtle highlight streaks
    for (int i = 0; i < 8; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final endX = startX + (random.nextDouble() - 0.5) * 40;
      final endY = startY + (random.nextDouble() - 0.5) * 8;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        highlightPaint,
      );
    }

    // Add some paper texture spots for more visibility
    final spotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: _applyOpacity(0.06));

    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;

      canvas.drawCircle(Offset(x, y), radius, spotPaint);
    }
  }

  void _drawPaperEdgeWear(Canvas canvas, Size size) {
    final wearPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = isDark
          ? 0.5
          : 0.3 // Thicker wear marks in dark mode
      ..color = isDark
          ? Colors.white.withValues(alpha: _applyOpacity(0.12))
          : Colors.black.withValues(alpha: _applyOpacity(0.08));

    final random = math.Random(123); // Fixed seed for consistent wear pattern

    // Add only horizontal wear marks along top and bottom edges
    for (int i = 0; i < 15; i++) {
      // Top edge wear (horizontal)
      final topX = random.nextDouble() * size.width;
      final topWear = random.nextDouble() * 2 + 1;
      canvas.drawLine(
        Offset(topX, 0),
        Offset(topX + (random.nextDouble() - 0.5) * 6, topWear),
        wearPaint,
      );

      // Bottom edge wear (horizontal)
      final bottomX = random.nextDouble() * size.width;
      final bottomWear = random.nextDouble() * 2 + 1;
      canvas.drawLine(
        Offset(bottomX, size.height),
        Offset(
          bottomX + (random.nextDouble() - 0.5) * 6,
          size.height - bottomWear,
        ),
        wearPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Specialized variant for different paper types
class NotebookPaperBackgroundWidget extends PaperSheetBackgroundWidget {
  const NotebookPaperBackgroundWidget({
    super.key,
    required super.child,
    super.opacity = 1.0,
    super.backgroundOpacity = 0.3, // Subtle background by default for notebook
  }) : super(showRuledLines: true, showMargin: false);
}

class BlankPaperBackgroundWidget extends PaperSheetBackgroundWidget {
  const BlankPaperBackgroundWidget({
    super.key,
    required super.child,
    super.opacity = 1.0,
    super.backgroundOpacity = 0.2, // Very subtle background for blank paper
  }) : super(showRuledLines: false, showMargin: false);
}

class GridPaperBackgroundWidget extends StatelessWidget {
  final Widget child;
  final double opacity;

  const GridPaperBackgroundWidget({
    super.key,
    required this.child,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Paper background
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: opacity),
          ),
        ),
        // Grid overlay
        CustomPaint(
          painter: GridPaperPainter(
            colorScheme: colorScheme,
            isDark: Theme.of(context).brightness == Brightness.dark,
            opacity: opacity,
          ),
          size: Size.infinite,
        ),
        child,
      ],
    );
  }
}

class GridPaperPainter extends CustomPainter {
  final ColorScheme colorScheme;
  final bool isDark;
  final double opacity;

  GridPaperPainter({
    required this.colorScheme,
    required this.isDark,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.08 * opacity)
          : Colors.black.withValues(alpha: 0.12 * opacity);

    const gridSize = 20.0;

    // Draw vertical grid lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw horizontal grid lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
