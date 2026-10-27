import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/domain/entities/step_kind.dart';
import '../../../profile/domain/entities/skin_concern.dart';
import '../../../profile/domain/entities/skin_profile.dart';
import '../../../profile/domain/entities/skin_type.dart';
import '../entities/ritual_mood.dart';
import '../entities/ritual_plan.dart';
import '../entities/ritual_step.dart';

/// Pure function from answers + mood to a ritual. No Flutter, fully tested.
abstract final class RitualPlanner {
  /// Optional steps are dropped in this order to fit the time budget.
  static const List<StepKind> dropOrder = <StepKind>[
    StepKind.tone,
    StepKind.eye,
    StepKind.exfoliate,
    StepKind.oil,
  ];

  static RitualPlan plan(
    SkinProfile profile,
    RitualMood mood,
    List<Product> catalog,
  ) {
    final List<StepKind> kinds = _kindsFor(profile, mood);
    final List<RitualStep> steps = <RitualStep>[
      for (final StepKind k in kinds)
        if (_pick(k, profile, catalog) case final Product p) RitualStep(p),
    ];
    final RitualPlan full = RitualPlan(mood: mood, steps: steps);
    return _fit(full, profile.minutes);
  }

  static List<StepKind> _kindsFor(SkinProfile p, RitualMood mood) {
    final bool lines = p.concerns.contains(SkinConcern.fineLines);
    final SkinType t = p.skinType;
    if (mood == RitualMood.day) {
      return <StepKind>[
        StepKind.cleanse,
        if (t != SkinType.dry) StepKind.tone,
        StepKind.serum,
        if (lines) StepKind.eye,
        StepKind.moisturise,
        StepKind.spf,
      ];
    }
    final bool polish =
        t != SkinType.sensitive &&
        (p.concerns.contains(SkinConcern.breakouts) ||
            p.concerns.contains(SkinConcern.glow));
    return <StepKind>[
      StepKind.cleanse,
      if (polish) StepKind.exfoliate,
      StepKind.serum,
      if (lines) StepKind.eye,
      if (t == SkinType.dry || t == SkinType.normal || t == SkinType.sensitive)
        StepKind.oil,
      StepKind.moisturise,
    ];
  }

  static Product? _pick(StepKind kind, SkinProfile p, List<Product> catalog) {
    if (kind == StepKind.serum) {
      for (final Product x in catalog) {
        if (x.kind == kind && x.concern == p.leadConcern) return x;
      }
    }
    for (final Product x in catalog) {
      if (x.kind == kind && x.suits(p.skinType)) return x;
    }
    return null;
  }

  static RitualPlan _fit(RitualPlan plan, int budget) {
    final List<RitualStep> steps = List<RitualStep>.of(plan.steps);
    for (final StepKind drop in dropOrder) {
      if (RitualPlan(mood: plan.mood, steps: steps).totalMinutes <= budget) {
        break;
      }
      steps.removeWhere((RitualStep s) => s.kind == drop);
    }
    return RitualPlan(
      mood: plan.mood,
      steps: List<RitualStep>.unmodifiable(steps),
    );
  }

  /// "Good morning, Isah." or, after Skip, a nameless greeting.
  static String greeting(SkinProfile p, RitualMood mood) {
    final String part = mood == RitualMood.day
        ? 'Good morning'
        : 'Good evening';
    return p.skipped ? '$part.' : '$part, ${p.name}.';
  }

  /// One plain line that proves the answers were used.
  static String tailoredLine(SkinProfile p) {
    if (p.skipped) return 'A balanced starter ritual. Retake the quiz anytime.';
    final String focus = p.concerns.isEmpty
        ? 'balance'
        : (p.concerns.toList()..sort((SkinConcern a, SkinConcern b) {
                return a.index.compareTo(b.index);
              }))
              .map((SkinConcern c) => c.label.toLowerCase())
              .take(2)
              .join(' + ');
    return 'For ${p.skinType.label.toLowerCase()} skin, focused on $focus.';
  }
}
