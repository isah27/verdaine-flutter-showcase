import 'package:flutter/foundation.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/domain/entities/step_kind.dart';
import '../../../catalog/domain/repositories/product_repository.dart';
import '../../../profile/domain/entities/skin_profile.dart';
import '../../domain/entities/blend_result.dart';
import '../../domain/services/blend_formula.dart';

/// Texture Lab state. Only committed values live here: the slab keeps the
/// per-frame swirl in its own notifier and commits once per stroke.
class LabController extends ChangeNotifier {
  LabController(ProductRepository repo, SkinProfile profile)
    : serum = _serumFor(repo.all(), profile),
      cream = _creamFor(repo.all(), profile);

  final Product serum;
  final Product cream;

  BlendResult _result = BlendFormula.mix(.5, 0);
  BlendResult get result => _result;

  bool _scanned = false;
  bool get scanned => _scanned;

  double _mix = 0;

  /// How far the swirl has gone, 0..1, rounded to 2 places.
  double get mix => _mix;

  int _resetCount = 0;
  int get resetCount => _resetCount;

  void commit({required double ratio, required double progress}) {
    final BlendResult next = BlendFormula.mix(ratio, progress);
    final double mix = (progress.clamp(0.0, 1.0) * 100).round() / 100;
    if (next == _result && mix == _mix) return;
    _result = next;
    _mix = mix;
    notifyListeners();
  }

  void scan() {
    if (!_result.mixed || _scanned) return;
    _scanned = true;
    notifyListeners();
  }

  void reset() {
    _result = BlendFormula.mix(.5, 0);
    _scanned = false;
    _mix = 0;
    _resetCount++;
    notifyListeners();
  }

  static Product _serumFor(List<Product> all, SkinProfile p) => all.firstWhere(
    (Product x) => x.kind == StepKind.serum && x.concern == p.leadConcern,
  );

  static Product _creamFor(List<Product> all, SkinProfile p) => all.firstWhere(
    (Product x) => x.kind == StepKind.moisturise && x.suits(p.skinType),
  );
}
