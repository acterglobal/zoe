import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackgroundWidget extends StatefulWidget {
  final Widget child;
  final double backgroundOpacity;

  const AnimatedBackgroundWidget({
    super.key,
    required this.child,
    this.backgroundOpacity = 1.0,
  });

  @override
  State<AnimatedBackgroundWidget> createState() =>
      _AnimatedBackgroundWidgetState();
}

class _AnimatedBackgroundWidgetState extends State<AnimatedBackgroundWidget>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late AnimationController _conceptualController;

  @override
  void initState() {
    super.initState();
    // Multiple animation controllers for layered effects
    _primaryController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _secondaryController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);

    _conceptualController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    _conceptualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Modern gradient background
        // _buildModernGradientBackground(),
        // Conceptual elements layer
        _buildConceptualElementsLayer(),
        // Glassmorphism overlay
        // _buildGlassmorphismOverlay(),
        // Child content
        widget.child,
      ],
    );
  }

  Widget _buildConceptualElementsLayer() {
    return AnimatedBuilder(
      animation: _conceptualController,
      builder: (context, child) {
        return CustomPaint(
          painter: ConceptualElementsPainter(
            animation: _conceptualController,
            colorScheme: Theme.of(context).colorScheme,
            isDark: Theme.of(context).brightness == Brightness.dark,
            backgroundOpacity: widget.backgroundOpacity,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class ConceptualElementsPainter extends CustomPainter {
  final Animation<double> animation;
  final ColorScheme colorScheme;
  final bool isDark;
  final double backgroundOpacity;

  ConceptualElementsPainter({
    required this.animation,
    required this.colorScheme,
    required this.isDark,
    required this.backgroundOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw floating conceptual elements
    _drawFloatingPaperSheets(canvas, size);
    _drawFloatingEvents(canvas, size);
    _drawFloatingTasks(canvas, size);
    _drawFloatingMessagingApps(canvas, size);
    _drawFloatingNotes(canvas, size);
  }

  /// Helper method to apply background opacity to alpha values
  double _applyOpacity(double baseAlpha) {
    return (baseAlpha * backgroundOpacity).clamp(0.0, 1.0);
  }

  void _drawFloatingPaperSheets(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = isDark
          ? Colors.white.withValues(alpha: _applyOpacity(0.03))
          : colorScheme.primary.withValues(alpha: _applyOpacity(0.04));

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = isDark
          ? Colors.white.withValues(alpha: _applyOpacity(0.06))
          : colorScheme.primary.withValues(alpha: _applyOpacity(0.08));

    // Draw multiple floating paper sheets - balanced distribution including center
    final sheetPositions = [
      (0.08, 0.15, 0.8), // top left
      (0.85, 0.12, 1.2), // top right
      (0.15, 0.55, 1.1), // middle left
      (0.85, 0.65, 0.7), // middle right
      (0.45, 0.35, 1.3), // center
      (0.25, 0.85, 1.0), // bottom left
    ];

    for (int i = 0; i < sheetPositions.length; i++) {
      final pos = sheetPositions[i];
      final x =
          pos.$1 * size.width +
          math.sin(animation.value * 2 * math.pi + i * 0.5) * 8;
      final y =
          pos.$2 * size.height +
          math.cos(animation.value * 1.5 * math.pi + i * 0.3) * 6;
      final rotation = math.sin(animation.value * pos.$3 * math.pi) * 0.1;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      // Draw paper sheet
      final sheetRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-25, -35, 50, 70),
        const Radius.circular(4),
      );
      canvas.drawRRect(sheetRect, paint);
      canvas.drawRRect(sheetRect, strokePaint);

      // Draw content lines on paper
      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = isDark
            ? Colors.white.withValues(alpha: _applyOpacity(0.04))
            : colorScheme.onSurface.withValues(alpha: _applyOpacity(0.06));

      for (int j = 0; j < 4; j++) {
        final lineY = -20 + (j * 10);
        canvas.drawLine(
          Offset(-18, lineY.toDouble()),
          Offset(18, lineY.toDouble()),
          linePaint,
        );
      }

      canvas.restore();
    }
  }

  void _drawFloatingEvents(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.orange.withValues(alpha: _applyOpacity(0.05));

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.orange.withValues(alpha: _applyOpacity(0.1));

    // Draw floating calendar/event elements - balanced with center coverage
    final eventPositions = [
      (0.25, 0.25), // top left area
      (0.75, 0.45), // middle right
      (0.55, 0.65), // center-bottom
      (0.15, 0.75), // bottom left
    ];

    for (int i = 0; i < eventPositions.length; i++) {
      final pos = eventPositions[i];
      final x =
          pos.$1 * size.width +
          math.cos(animation.value * 2 * math.pi + i) * 10;
      final y =
          pos.$2 * size.height +
          math.sin(animation.value * 1.8 * math.pi + i) * 8;

      canvas.save();
      canvas.translate(x, y);

      // Draw calendar base
      final calendarRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-20, -15, 40, 30),
        const Radius.circular(3),
      );
      canvas.drawRRect(calendarRect, paint);
      canvas.drawRRect(calendarRect, strokePaint);

      // Draw calendar header
      final headerRect = const Rect.fromLTWH(-20, -15, 40, 8);
      canvas.drawRect(
        headerRect,
        Paint()..color = Colors.orange.withValues(alpha: _applyOpacity(0.08)),
      );

      // Draw calendar grid
      final gridPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = Colors.orange.withValues(alpha: _applyOpacity(0.06));

      // Vertical lines
      for (int j = 1; j < 7; j++) {
        final lineX = -20 + (j * 40 / 7);
        canvas.drawLine(Offset(lineX, -7), Offset(lineX, 15), gridPaint);
      }

      // Horizontal lines
      for (int j = 1; j < 4; j++) {
        final lineY = -7 + (j * 22 / 4);
        canvas.drawLine(Offset(-20, lineY), Offset(20, lineY), gridPaint);
      }

      canvas.restore();
    }
  }

  void _drawFloatingTasks(Canvas canvas, Size size) {
    final taskPositions = [
      (0.65, 0.15), // top right area
      (0.05, 0.45), // middle left edge
      (0.35, 0.55), // center-left
      (0.65, 0.85), // bottom right
      (0.85, 0.25), // top right edge
    ];

    for (int i = 0; i < taskPositions.length; i++) {
      final pos = taskPositions[i];
      final x =
          pos.$1 * size.width +
          math.sin(animation.value * 2.5 * math.pi + i * 0.7) * 8;
      final y =
          pos.$2 * size.height +
          math.cos(animation.value * 2 * math.pi + i * 0.5) * 6;

      canvas.save();
      canvas.translate(x, y);

      // Draw task item background
      final taskRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-30, -8, 60, 16),
        const Radius.circular(8),
      );

      final taskPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.green.withValues(alpha: _applyOpacity(0.04));

      canvas.drawRRect(taskRect, taskPaint);

      canvas.drawRRect(
        taskRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = Colors.green.withValues(alpha: _applyOpacity(0.08)),
      );

      // Draw checkbox
      final checkboxRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-25, -5, 10, 10),
        const Radius.circular(2),
      );

      canvas.drawRRect(
        checkboxRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = Colors.green.withValues(alpha: _applyOpacity(0.12)),
      );

      // Draw checkmark (animated)
      if (math.sin(animation.value * 3 * math.pi + i) > 0.5) {
        final checkPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = Colors.green.withValues(alpha: _applyOpacity(0.15));

        final checkPath = Path();
        checkPath.moveTo(-23, -2);
        checkPath.lineTo(-21, 0);
        checkPath.lineTo(-17, -4);
        canvas.drawPath(checkPath, checkPaint);
      }

      // Draw task text lines
      final textPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = Colors.green.withValues(alpha: _applyOpacity(0.06));

      canvas.drawLine(const Offset(-10, -2), const Offset(25, -2), textPaint);
      canvas.drawLine(const Offset(-10, 2), const Offset(15, 2), textPaint);

      canvas.restore();
    }
  }

  void _drawFloatingMessagingApps(Canvas canvas, Size size) {
    // Draw floating messaging app chat bubbles - center-focused distribution
    final messagingPositions = [
      (0.35, 0.25, 'whatsapp'), // top center-left
      (0.65, 0.35, 'signal'), // center-right
      (0.25, 0.65, 'messages'), // bottom left
      (0.75, 0.75, 'whatsapp'), // bottom right
    ];

    for (int i = 0; i < messagingPositions.length; i++) {
      final pos = messagingPositions[i];
      final x =
          pos.$1 * size.width +
          math.sin(animation.value * 1.8 * math.pi + i * 0.6) * 10;
      final y =
          pos.$2 * size.height +
          math.cos(animation.value * 2.2 * math.pi + i * 0.4) * 8;
      final appType = pos.$3;

      canvas.save();
      canvas.translate(x, y);

      // Choose colors based on app type
      Color appColor;
      switch (appType) {
        case 'whatsapp':
          appColor = const Color(0xFF25D366); // WhatsApp green
          break;
        case 'signal':
          appColor = const Color(0xFF3A76F0); // Signal blue
          break;
        case 'messages':
          appColor = const Color(0xFF007AFF); // Messages blue
          break;
        default:
          appColor = colorScheme.primary;
      }

      // Draw chat bubble
      final bubblePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = appColor.withValues(alpha: _applyOpacity(0.05));

      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = appColor.withValues(alpha: _applyOpacity(0.1));

      // Main chat bubble
      final bubblePath = Path();
      bubblePath.addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-25, -12, 50, 24),
          const Radius.circular(12),
        ),
      );

      // Chat bubble tail
      bubblePath.moveTo(-25, 8);
      bubblePath.lineTo(-30, 15);
      bubblePath.lineTo(-20, 12);
      bubblePath.close();

      canvas.drawPath(bubblePath, bubblePaint);
      canvas.drawPath(bubblePath, strokePaint);

      // Draw chat message lines
      final messagePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = appColor.withValues(alpha: _applyOpacity(0.08));

      canvas.drawLine(
        const Offset(-18, -5),
        const Offset(18, -5),
        messagePaint,
      );
      canvas.drawLine(const Offset(-18, 0), const Offset(10, 0), messagePaint);
      canvas.drawLine(const Offset(-18, 5), const Offset(15, 5), messagePaint);

      // Draw Zoe bot indicator (small circle with "Z")
      final botIndicatorPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = colorScheme.secondary.withValues(alpha: _applyOpacity(0.06));

      canvas.drawCircle(const Offset(20, -18), 8, botIndicatorPaint);

      canvas.drawCircle(
        const Offset(20, -18),
        8,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = colorScheme.secondary.withValues(
            alpha: _applyOpacity(0.12),
          ),
      );

      // Draw "Z" for Zoe bot
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'Z',
          style: TextStyle(
            color: colorScheme.secondary.withValues(alpha: _applyOpacity(0.15)),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(16, -23));

      // Draw connection line between chat and bot (animated)
      final connectionPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = colorScheme.secondary.withValues(alpha: _applyOpacity(0.06));

      final connectionOffset = math.sin(animation.value * 4 * math.pi + i) * 2;
      canvas.drawLine(
        Offset(25 + connectionOffset, -8),
        Offset(12 + connectionOffset, -15),
        connectionPaint,
      );

      canvas.restore();
    }
  }

  void _drawFloatingNotes(Canvas canvas, Size size) {
    // Draw small floating note elements - filling center gaps
    final notePositions = [
      (0.55, 0.25), // top center
      (0.25, 0.45), // middle left
      (0.75, 0.55), // middle right
    ];

    for (int i = 0; i < notePositions.length; i++) {
      final pos = notePositions[i];
      final x =
          pos.$1 * size.width +
          math.sin(animation.value * 3 * math.pi + i * 0.8) * 5;
      final y =
          pos.$2 * size.height +
          math.cos(animation.value * 2.5 * math.pi + i * 0.6) * 4;

      canvas.save();
      canvas.translate(x, y);

      // Rotate slightly for natural look
      canvas.rotate(math.sin(animation.value * 2 * math.pi + i) * 0.2);

      // Draw small note
      final notePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isDark
            ? Colors.white.withValues(alpha: _applyOpacity(0.02))
            : colorScheme.primary.withValues(alpha: _applyOpacity(0.03));

      final noteStroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = isDark
            ? Colors.white.withValues(alpha: _applyOpacity(0.04))
            : colorScheme.primary.withValues(alpha: _applyOpacity(0.05));

      final noteRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-12, -8, 24, 16),
        const Radius.circular(2),
      );

      canvas.drawRRect(noteRect, notePaint);
      canvas.drawRRect(noteRect, noteStroke);

      // Draw small lines on note
      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6
        ..color = isDark
            ? Colors.white.withValues(alpha: _applyOpacity(0.03))
            : colorScheme.onSurface.withValues(alpha: _applyOpacity(0.04));

      canvas.drawLine(const Offset(-8, -3), const Offset(8, -3), linePaint);
      canvas.drawLine(const Offset(-8, 0), const Offset(6, 0), linePaint);
      canvas.drawLine(const Offset(-8, 3), const Offset(4, 3), linePaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
