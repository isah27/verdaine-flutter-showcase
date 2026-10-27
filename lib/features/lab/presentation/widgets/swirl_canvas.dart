import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../domain/services/blend_formula.dart';

/// Per-frame swirl data for the slab. A plain ChangeNotifier used only as
/// the painter's `repaint`, so dragging never rebuilds a widget.
class SwirlCanvas extends ChangeNotifier {
  static const int maxPoints = 700;

  final List<Offset> _points = <Offset>[];
  double _distance = 0;
  double _sumX = 0;
  int _count = 0;

  List<Offset> get points => _points;
  double get distance => _distance;
  double get progress => BlendFormula.progressFor(_distance);

  double ratio(double width) =>
      BlendFormula.ratioFor(_count == 0 ? width / 2 : _sumX / _count, width);

  void add(Offset p) {
    if (_points.isNotEmpty) _distance += (p - _points.last).distance;
    _points.add(p);
    if (_points.length > maxPoints) _points.removeAt(0);
    _sumX += p.dx;
    _count++;
    notifyListeners();
  }

  /// Lifting the finger breaks the stroke, so the next one starts fresh.
  void lift() {
    if (_points.isNotEmpty) _points.add(Offset.infinite);
  }

  void clear() {
    _points.clear();
    _distance = 0;
    _sumX = 0;
    _count = 0;
    notifyListeners();
  }
}
