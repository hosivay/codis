import 'dart:math' as math;

import 'package:flutter/material.dart';

class CipherLoadingIndicator extends StatefulWidget {
  const CipherLoadingIndicator({
    super.key,
    this.size = 32,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  State<CipherLoadingIndicator> createState() => _CipherLoadingIndicatorState();
}

class _CipherLoadingIndicatorState extends State<CipherLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _rotateReverseController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _rotateReverseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _rotateReverseController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Colors.white;
    final size = widget.size;

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = 0.9 + 0.1 * Curves.easeInOut.transform(_pulseController.value);
            return Transform.scale(
              scale: scale,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  RotationTransition(
                    turns: _rotateController,
                    child: CustomPaint(
                      size: Size(size, size),
                      painter: _CipherRingsPainter(
                        color: color,
                        sweepOuter: 1.35,
                        sweepInner: 0.95,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _rotateReverseController,
                    child: CustomPaint(
                      size: Size(size, size),
                      painter: _CipherRingsPainter(
                        color: color,
                        sweepOuter: 1.0,
                        sweepInner: 0,
                        offset: 0.55,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.lock_rounded,
                    size: size * 0.38,
                    color: color,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CipherRingsPainter extends CustomPainter {
  _CipherRingsPainter({
    required this.color,
    required this.sweepOuter,
    required this.sweepInner,
    this.offset = 0,
  });

  final Color color;
  final double sweepOuter;
  final double sweepInner;
  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 2;

    final outerStroke = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final innerStroke = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: r);

    canvas.drawArc(rect, offset * math.pi, sweepOuter * math.pi, false, outerStroke);
    if (sweepInner > 0) {
      canvas.drawArc(rect, offset * math.pi + 0.15 * math.pi, sweepInner * math.pi, false, innerStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _CipherRingsPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.sweepOuter != sweepOuter ||
        oldDelegate.sweepInner != sweepInner ||
        oldDelegate.offset != offset;
  }
}
