import 'package:flutter/foundation.dart';

import '../../../catalog/domain/entities/step_kind.dart';
import 'ritual_mood.dart';
import 'ritual_step.dart';

@immutable
class RitualPlan {
  const RitualPlan({required this.mood, required this.steps});

  final RitualMood mood;
  final List<RitualStep> steps;

  int get totalMinutes =>
      steps.fold<int>(0, (int sum, RitualStep s) => sum + s.minutes);

  List<StepKind> get kinds =>
      steps.map((RitualStep s) => s.kind).toList(growable: false);

  String get summary => '${steps.length} steps · $totalMinutes min';
}
