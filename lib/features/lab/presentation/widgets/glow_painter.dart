import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';

/// Mock "skin glow" scan: a skin swatch, a sweeping scan line, and dew
/// highlights that appear behind the line, scaled by the glow score.
class GlowPainter extends CustomPainter {
  GlowPainter({required this.t, required this.glow}) : super(repaint: t);

  final Animation<double> t;
  final double glow;

  static final List<(Offset, double)> _dew = List<(Offset, double)>.generate(
    18,
    (int i) {
      final math.Random r = math.Random(i * 13 + 5);
      return (Offset(r.nextDouble(), r.nextDouble()), 6 + r.nextDouble() * 16);
    },
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Rect b = Offset.zero & size;
    final double v = Curves.easeInOutSine.transform(t.value);
    canvas.drawRect(
      b,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.skinLight, AppColors.skinDeep],
        ).createShader(b),
    );
    // Fine texture so it reads as skin.
    final math.Random r = math.Random(3);
    final Paint pore = Paint()
      ..color = AppColors.skinDeep.withValues(alpha: .25);
    for (int i = 0; i < 160; i++) {
      canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        .8,
        pore,
      );
    }
    final double lineY = size.height * v;
    for (final (Offset o, double rad) in _dew) {
      final Offset c = Offset(o.dx * size.width, o.dy * size.height);
      if (c.dy > lineY) continue;
      final double a = (glow / 100) * .75;
      canvas.drawOval(
        Rect.fromCenter(center: c, width: rad * 2.2, height: rad * 1.3),
        Paint()
          ..color = AppColors.white.withValues(alpha: a)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, rad * .5),
      );
    }
    if (v < 1) {
      canvas.drawRect(
        Rect.fromLTWH(0, lineY - 22, size.width, 22),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              AppColors.honey.withValues(alpha: 0),
              AppColors.honey.withValues(alpha: .5),
            ],
          ).createShader(Rect.fromLTWH(0, lineY - 22, size.width, 22)),
      );
      canvas.drawLine(
        Offset(0, lineY),
        Offset(size.width, lineY),
        Paint()
          ..color = AppColors.white
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(GlowPainter old) => old.glow != glow || old.t != t;
}
