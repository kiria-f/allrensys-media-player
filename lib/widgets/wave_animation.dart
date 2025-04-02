import 'dart:math' as math;

import 'package:flutter/material.dart';

class WaveAnimation extends StatefulWidget {
  const WaveAnimation({super.key});

  @override
  State<WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat();

    // Create a continuous animation that doesn't reset
    _animation = Tween<double>(
      begin: 0,
      end: 4 * math.pi, // Increased range for smoother transition
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(size: const Size(200, 40), painter: WavePainter(animation: _animation.value, color: const Color(0xFF4A3F35).withAlpha(179)));
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animation;
  final Color color;

  WavePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final centerY = height / 2;
    final padding = width * 0.2; // Add padding to hide the stuck edge

    // Start the path before the visible area
    path.moveTo(-padding, centerY);

    // Draw the wave with extended range to prevent edge sticking
    for (double x = -padding; x <= width + padding; x++) {
      final y = centerY + math.sin((x / width * 2 * math.pi) + animation) * 10 + math.sin((x / width * 4 * math.pi) + animation * 1.5) * 5;
      path.lineTo(x, y);
    }

    // Clip the path to only show the visible area
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, width, height));
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}
