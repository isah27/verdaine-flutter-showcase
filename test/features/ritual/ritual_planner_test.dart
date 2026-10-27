import 'package:flutter_test/flutter_test.dart';
import 'package:verdaine/features/catalog/data/repositories/local_product_repository.dart';
import 'package:verdaine/features/catalog/domain/entities/product.dart';
import 'package:verdaine/features/catalog/domain/entities/step_kind.dart';
import 'package:verdaine/features/profile/domain/entities/ritual_moment.dart';
import 'package:verdaine/features/profile/domain/entities/skin_concern.dart';
import 'package:verdaine/features/profile/domain/entities/skin_profile.dart';
import 'package:verdaine/features/profile/domain/entities/skin_type.dart';
import 'package:verdaine/features/ritual/domain/entities/ritual_mood.dart';
import 'package:verdaine/features/ritual/domain/entities/ritual_plan.dart';
import 'package:verdaine/features/ritual/domain/entities/ritual_step.dart';
import 'package:verdaine/features/ritual/domain/services/ritual_planner.dart';

void main() {
  final List<Product> catalog = const LocalProductRepository().all();
  const SkinProfile isah = SkinProfile(
    name: 'Isah',
    skinType: SkinType.combination,
    concerns: <SkinConcern>{SkinConcern.glow, SkinConcern.hydration},
    moment: RitualMoment.sunrise,
    minutes: 15,
  );

  group('RitualPlanner', () {
    test('morning ends with sunscreen and uses the lead-concern serum', () {
      final RitualPlan plan = RitualPlanner.plan(isah, RitualMood.day, catalog);
      expect(plan.kinds.first, StepKind.cleanse);
      expect(plan.kinds.last, StepKind.spf);
      final Product serum = plan.steps
          .firstWhere((RitualStep s) => s.kind == StepKind.serum)
          .product;
      expect(serum.concern, SkinConcern.glow);
    });

    test('evening has no sunscreen and polishes for glow', () {
      final RitualPlan plan = RitualPlanner.plan(
        isah,
        RitualMood.night,
        catalog,
      );
      expect(plan.kinds, isNot(contains(StepKind.spf)));
      expect(plan.kinds, contains(StepKind.exfoliate));
    });

    test('sensitive skin never gets the exfoliant', () {
      final SkinProfile p = isah.copyWith(skinType: SkinType.sensitive);
      final RitualPlan plan = RitualPlanner.plan(p, RitualMood.night, catalog);
      expect(plan.kinds, isNot(contains(StepKind.exfoliate)));
    });

    test('dry skin skips toner and gets the oil at night', () {
      final SkinProfile p = isah.copyWith(skinType: SkinType.dry);
      expect(
        RitualPlanner.plan(p, RitualMood.day, catalog).kinds,
        isNot(contains(StepKind.tone)),
      );
      expect(
        RitualPlanner.plan(p, RitualMood.night, catalog).kinds,
        contains(StepKind.oil),
      );
    });

    test('fine lines add the eye step', () {
      final SkinProfile p = isah.copyWith(
        concerns: <SkinConcern>{SkinConcern.fineLines},
      );
      expect(
        RitualPlanner.plan(p, RitualMood.day, catalog).kinds,
        contains(StepKind.eye),
      );
    });

    test('a short budget drops optional steps but keeps the core', () {
      final SkinProfile p = isah.copyWith(minutes: SkinProfile.minMinutes);
      final RitualPlan plan = RitualPlanner.plan(p, RitualMood.day, catalog);
      final RitualPlan full = RitualPlanner.plan(isah, RitualMood.day, catalog);
      expect(plan.steps.length, lessThan(full.steps.length));
      for (final StepKind k in StepKind.values.where((StepKind k) => k.core)) {
        if (full.kinds.contains(k)) expect(plan.kinds, contains(k));
      }
    });

    test('greeting uses the name, or none after Skip', () {
      expect(
        RitualPlanner.greeting(isah, RitualMood.day),
        'Good morning, Isah.',
      );
      expect(
        RitualPlanner.greeting(isah, RitualMood.night),
        'Good evening, Isah.',
      );
      expect(
        RitualPlanner.greeting(SkinProfile.defaults, RitualMood.day),
        'Good morning.',
      );
    });

    test('tailored line echoes skin type and concerns', () {
      expect(
        RitualPlanner.tailoredLine(isah),
        'For combination skin, focused on glow + hydration.',
      );
      expect(
        RitualPlanner.tailoredLine(SkinProfile.defaults),
        contains('starter'),
      );
    });
  });
}
