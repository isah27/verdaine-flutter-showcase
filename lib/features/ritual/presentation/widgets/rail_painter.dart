import 'package:flutter/widgets.dart';

/// The vertical timeline rail with a node that fills when the step is done.
class RailPainter extends CustomPainter {
  const RailPainter({
    required this.first,
    required this.last,
    required this.done,
    required this.line,
    required this.fill,
  });

  final bool first;
  final bool last;
  final double done;
  final Color line;
  final Color fill;

  static const double nodeY = 34;

  @override
  void paint(Canvas canvas, Size size) {
    final double x = size.width / 2;
    final Paint rail = Paint()
      ..color = line
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(x, first ? nodeY : 0),
      Offset(x, last ? nodeY : size.height),
      rail,
    );
    final Offset c = Offset(x, nodeY);
    canvas.drawCircle(c, 11, Paint()..color = line);
    if (done > 0) {
      canvas.drawCircle(c, 11 * done, Paint()..color = fill);
      canvas.drawCircle(
        c,
        11 + 8 * done,
        Paint()..color = fill.withValues(alpha: .18 * (1 - done + .4)),
      );
    }
  }

  @override
  bool shouldRepaint(RailPainter old) =>
      old.done != done ||
      old.line != line ||
      old.fill != fill ||
      old.first != first ||
      old.last != last;
}
