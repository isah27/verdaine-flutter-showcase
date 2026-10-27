import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import 'swirl_canvas.dart';

/// Paints the two drops and the swirl on the stone slab.
///
/// Each swirl point takes the colour of the drop it is nearer to, and drifts
/// toward the blended colour as mixing progresses. The whole swirl is drawn
/// in one blurred layer, so it reads like a smooth texture, not dots.
class BlendPainter extends CustomPainter {
  BlendPainter({
    required this.swirl,
    required this.serum,
    required this.cream,
    required this.shimmer,
  }) : super(repaint: Listenable.merge(<Listenable>[swirl, shimmer]));

  final SwirlCanvas swirl;
  final Color serum;
  final Color cream;
  final Animation<double> shimmer;

  static Offset serumAt(Size s) => Offset(s.width * .3, s.height * .44);
  static Offset creamAt(Size s) => Offset(s.width * .7, s.height * .56);

  @override
  void paint(Canvas canvas, Size size) {
    final double p = swirl.progress;
    final double ratio = swirl.ratio(size.width);
    final Color blend = Color.lerp(cream, serum, ratio)!;
    final Rect bounds = Offset.zero & size;

    canvas.saveLayer(
      bounds,
      Paint()..imageFilter = ui.ImageFilter.blur(sigmaX: 7, sigmaY: 7),
    );
    // The drops shrink as they are worked into the swirl.
    final double shrink = 1 - p * .75;
    _drop(canvas, serumAt(size), 50 * shrink, Color.lerp(serum, blend, p)!);
    _drop(canvas, creamAt(size), 58 * shrink, Color.lerp(cream, blend, p)!);

    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 30;
    final List<Offset> pts = swirl.points;
    for (int i = 1; i < pts.length; i++) {
      final Offset a = pts[i - 1];
      final Offset b = pts[i];
      if (!a.isFinite || !b.isFinite) continue;
      final double side = (b.dx / size.width).clamp(0.0, 1.0);
      final Color own = Color.lerp(serum, cream, side)!;
      stroke.color = Color.lerp(own, blend, p)!.withValues(alpha: .9);
      canvas.drawLine(a, b, stroke);
    }
    canvas.restore();

    // Gloss over the texture.
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.white.withValues(alpha: .22),
            AppColors.white.withValues(alpha: 0),
            AppColors.white.withValues(alpha: .08),
          ],
        ).createShader(bounds),
    );

    if (p >= 1) _sparkles(canvas, size);
  }

  void _drop(Canvas c, Offset o, double r, Color col) {
    if (r < 1) return;
    c.drawCircle(o, r, Paint()..color = col);
    c.drawCircle(
      o + Offset(-r * .35, -r * .35),
      r * .28,
      Paint()..color = AppColors.white.withValues(alpha: .55),
    );
  }

  void _sparkles(Canvas c, Size s) {
    final double t = shimmer.value;
    final math.Random r = math.Random(11);
    final Paint paint = Paint()..color = AppColors.white;
    for (int i = 0; i < 14; i++) {
      final Offset o = Offset(
        r.nextDouble() * s.width,
        r.nextDouble() * s.height,
      );
      final double phase = (t + i / 14) % 1;
      final double a = math.sin(phase * math.pi);
      paint.color = AppColors.white.withValues(alpha: a * .9);
      final double k = 2 + 5 * a;
      c.drawPath(
        Path()
          ..moveTo(o.dx, o.dy - k)
          ..lineTo(o.dx + k * .25, o.dy)
          ..lineTo(o.dx, o.dy + k)
          ..lineTo(o.dx - k * .25, o.dy)
          ..close()
          ..moveTo(o.dx - k, o.dy)
          ..lineTo(o.dx, o.dy + k * .25)
          ..lineTo(o.dx + k, o.dy)
          ..lineTo(o.dx, o.dy - k * .25)
          ..close(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BlendPainter old) =>
      old.serum != serum || old.cream != cream || old.swirl != swirl;
}
