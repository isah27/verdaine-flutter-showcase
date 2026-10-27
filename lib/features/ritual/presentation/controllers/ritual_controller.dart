import 'package:flutter/foundation.dart';

import '../../../catalog/domain/entities/step_kind.dart';
import '../../../catalog/domain/repositories/product_repository.dart';
import '../../../profile/domain/entities/skin_profile.dart';
import '../../domain/entities/ritual_mood.dart';
import '../../domain/entities/ritual_plan.dart';
import '../../domain/services/ritual_planner.dart';

/// Home state: the day/night mood, today's plan and the ticked steps.
class RitualController extends ChangeNotifier {
  RitualController(this._repo, SkinProfile profile)
    : _profile = profile,
      _mood = profile.moment.opensAtNight ? RitualMood.night : RitualMood.day {
    _plan = RitualPlanner.plan(_profile, _mood, _repo.all());
  }

  final ProductRepository _repo;
  SkinProfile _profile;
  RitualMood _mood;
  late RitualPlan _plan;
  final Set<StepKind> _done = <StepKind>{};

  SkinProfile get profile => _profile;
  RitualMood get mood => _mood;
  RitualPlan get plan => _plan;
  bool isDone(StepKind k) => _done.contains(k);
  int get doneCount => _done.length;
  double get progress =>
      _plan.steps.isEmpty ? 0 : _done.length / _plan.steps.length;

  /// Re-plans if the saved answers change.
  void updateProfile(SkinProfile next) {
    if (next == _profile) return;
    _profile = next;
    _replan();
  }

  void toggleMood() {
    _mood = _mood.flipped;
    _replan();
  }

  void toggleDone(StepKind k) {
    if (!_plan.kinds.contains(k)) return;
    if (!_done.remove(k)) _done.add(k);
    notifyListeners();
  }

  void _replan() {
    _done.clear();
    _plan = RitualPlanner.plan(_profile, _mood, _repo.all());
    notifyListeners();
  }
}
