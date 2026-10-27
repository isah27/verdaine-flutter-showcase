import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/bottle_shape.dart';
import 'bottle_geometry.dart';

/// Paints a glass bottle with stacked liquid layers and an optional wave.
///
/// [layers] fill from the bottom; [level] (0..1) is the total fill.
/// [wave] drives the surface ripple through `repaint`, so the widget
/// never rebuilds while the liquid moves.
class BottlePainter extends CustomPainter {
  BottlePainter({
    required this.shape,
    required this.layers,
    this.level = .72,
    this.wave,
    this.capColor = AppColors.ink,
    this.glass = AppColors.white,
  }) : super(repaint: wave);

  final BottleShape shape;
  final List<Color> layers;
  final double level;
  final Animation<double>? wave;
  final Color capColor;
  final Color glass;

  @override
  void paint(Canvas canvas, Size size) {
    final BottleGeometry g = BottleGeometry(shape, size);
    final Rect b = g.bounds;

    // Soft floor shadow.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(b.center.dx, size.height),
        width: b.width * 1.1,
        height: size.height * .05,
      ),
      Paint()
        ..color = AppColors.ink.withValues(alpha: .12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    canvas.drawPath(g.body, Paint()..color = glass.withValues(alpha: .55));

    if (layers.isNotEmpty && level > 0) {
      canvas.save();
      canvas.clipPath(g.body);
      final double phase = (wave?.value ?? 0) * math.pi * 2;
      final double filled = b.height * level.clamp(0.0, 1.0);
      final double layerH = filled / layers.length;
      for (int i = 0; i < layers.length; i++) {
        final double bottom = b.bottom - layerH * i;
        final double top = bottom - layerH;
        final bool surface = i == layers.length - 1;
        final Path p = Path()..moveTo(b.left, bottom);
        p.lineTo(b.left, top);
        if (surface && wave != null) {
          for (double x = b.left; x <= b.right; x += 4) {
            final double t = (x - b.left) / b.width;
            p.lineTo(x, top + math.sin(t * math.pi * 2 + phase) * 3.2);
          }
        }
        p
          ..lineTo(b.right, top)
          ..lineTo(b.right, bottom + 1)
          ..close();
        canvas.drawPath(p, Paint()..color = layers[i]);
      }
      // Gloss on the liquid.
      canvas.drawRect(
        Rect.fromLTWH(b.left, b.top, b.width * .5, b.height),
        Paint()
          ..shader = LinearGradient(
            colors: <Color>[
              AppColors.white.withValues(alpha: .35),
              AppColors.white.withValues(alpha: 0),
            ],
          ).createShader(b),
      );
      canvas.restore();
    }

    canvas.drawPath(
      g.body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = AppColors.ink.withValues(alpha: .22),
    );
    // Highlight streak on the glass.
    canvas.drawLine(
      Offset(b.left + b.width * .16, b.top + b.height * .14),
      Offset(b.left + b.width * .16, b.top + b.height * .62),
      Paint()
        ..strokeWidth = b.width * .05
        ..strokeCap = StrokeCap.round
        ..color = AppColors.white.withValues(alpha: .7),
    );
    canvas.drawPath(g.cap, Paint()..color = capColor);
  }

  @override
  bool shouldRepaint(BottlePainter old) =>
      old.shape != shape ||
      old.level != level ||
      old.capColor != capColor ||
      !_sameLayers(old.layers, layers);

  static bool _sameLayers(List<Color> a, List<Color> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
