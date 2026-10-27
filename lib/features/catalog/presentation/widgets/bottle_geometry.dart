import 'dart:ui';

import '../../domain/entities/bottle_shape.dart';

/// Body and cap outlines for each bottle shape, in a given box.
class BottleGeometry {
  BottleGeometry(this.shape, Size size) {
    final double w = size.width;
    final double h = size.height;
    switch (shape) {
      case BottleShape.dropper:
        body = _round(Rect.fromLTRB(w * .2, h * .36, w * .8, h), w * .14);
        cap = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTRB(w * .34, h * .2, w * .66, h * .36),
              Radius.circular(w * .04),
            ),
          )
          ..addOval(Rect.fromLTRB(w * .38, 0, w * .62, h * .26));
      case BottleShape.pump:
        body = _round(Rect.fromLTRB(w * .22, h * .3, w * .78, h), w * .1);
        cap = Path()
          ..addRect(Rect.fromLTRB(w * .4, h * .2, w * .6, h * .3))
          ..addRect(Rect.fromLTRB(w * .46, h * .06, w * .54, h * .2))
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTRB(w * .3, h * .02, w * .62, h * .09),
              Radius.circular(w * .03),
            ),
          );
      case BottleShape.jar:
        body = _round(Rect.fromLTRB(w * .06, h * .5, w * .94, h), w * .16);
        cap = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTRB(w * .1, h * .34, w * .9, h * .5),
              Radius.circular(w * .06),
            ),
          );
      case BottleShape.tube:
        body = Path()
          ..moveTo(w * .18, h * .08)
          ..lineTo(w * .82, h * .08)
          ..lineTo(w * .7, h * .8)
          ..lineTo(w * .3, h * .8)
          ..close();
        cap = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTRB(w * .32, h * .8, w * .68, h),
              Radius.circular(w * .05),
            ),
          )
          ..addRect(Rect.fromLTRB(w * .16, h * .02, w * .84, h * .08));
      case BottleShape.mist:
        body = _round(Rect.fromLTRB(w * .26, h * .28, w * .74, h), w * .2);
        cap = Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTRB(w * .32, h * .06, w * .68, h * .28),
              Radius.circular(w * .1),
            ),
          );
    }
    bounds = body.getBounds();
  }

  final BottleShape shape;
  late final Path body;
  late final Path cap;
  late final Rect bounds;

  static Path _round(Rect r, double radius) =>
      Path()..addRRect(RRect.fromRectAndRadius(r, Radius.circular(radius)));
}
