import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';

/// Sun sets and the moon rises as [t] goes 0 (morning) → 1 (evening).
/// Repaints from the animation; the header never rebuilds per frame.
class SkyPainter extends CustomPainter {
  SkyPainter(this.t) : super(repaint: t);

  final Animation<double> t;

  static final List<Offset> _stars = List<Offset>.generate(26, (int i) {
    final math.Random r = math.Random(i * 7 + 3);
    return Offset(r.nextDouble(), r.nextDouble() * .62);
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double v = Curves.easeInOutCubic.transform(t.value);
    final double w = size.width;
    final double h = size.height;

    // Stars fade in at night.
    if (v > .02) {
      final Paint star = Paint()
        ..color = AppColors.moonMilk.withValues(alpha: .8 * v);
      for (int i = 0; i < _stars.length; i++) {
        final Offset s = _stars[i];
        canvas.drawCircle(
          Offset(s.dx * w, s.dy * h),
          i.isEven ? 1.3 : .9,
          star,
        );
      }
    }

    // Sun: high on the right in the morning, sinks below the fold.
    final Offset sun = Offset(w * (.78 + .1 * v), h * (.2 + .9 * v));
    _glowDisc(canvas, sun, 34, AppColors.honey, 1 - v);

    // Moon: rises from below into the same spot.
    final Offset moon = Offset(
      w * (.82 - .04 * (1 - v)),
      h * (.22 + .9 * (1 - v)),
    );
    _glowDisc(canvas, moon, 26, AppColors.moonMilk, v);
    if (v > .02) {
      // Crescent bite.
      canvas.drawCircle(
        moon + const Offset(-10, -6),
        22,
        Paint()..color = AppColors.plum.withValues(alpha: v),
      );
    }
  }

  void _glowDisc(Canvas c, Offset o, double r, Color col, double a) {
    if (a <= .01) return;
    c.drawCircle(
      o,
      r * 2.6,
      Paint()
        ..color = col.withValues(alpha: .28 * a)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );
    c.drawCircle(o, r, Paint()..color = col.withValues(alpha: a));
  }

  @override
  bool shouldRepaint(SkyPainter old) => old.t != t;
}
