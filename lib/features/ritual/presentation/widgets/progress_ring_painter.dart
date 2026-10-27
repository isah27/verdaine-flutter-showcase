import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class ProgressRingPainter extends CustomPainter {
  const ProgressRingPainter({
    required this.value,
    required this.track,
    required this.fill,
  });

  final double value;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect r = Offset.zero & size;
    final Paint p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(r.deflate(3), 0, math.pi * 2, false, p..color = track);
    if (value > 0) {
      canvas.drawArc(
        r.deflate(3),
        -math.pi / 2,
        math.pi * 2 * value,
        false,
        p..color = fill,
      );
    }
  }

  @override
  bool shouldRepaint(ProgressRingPainter old) =>
      old.value != value || old.track != track || old.fill != fill;
}
