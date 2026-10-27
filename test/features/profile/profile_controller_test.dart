import 'package:flutter_test/flutter_test.dart';
import 'package:verdaine/features/catalog/data/repositories/local_product_repository.dart';
import 'package:verdaine/features/catalog/domain/entities/step_kind.dart';
import 'package:verdaine/features/profile/domain/entities/ritual_moment.dart';
import 'package:verdaine/features/profile/domain/entities/skin_profile.dart';
import 'package:verdaine/features/profile/presentation/controllers/profile_controller.dart';
import 'package:verdaine/features/ritual/domain/entities/ritual_mood.dart';
import 'package:verdaine/features/ritual/presentation/controllers/ritual_controller.dart';

void main() {
  test('ProfileController only notifies on a real change', () {
    final ProfileController c = ProfileController();
    int calls = 0;
    c.addListener(() => calls++);
    c.useDefaults();
    expect(calls, 0);
    c.save(SkinProfile.defaults.copyWith(name: 'Isah', skipped: false));
    expect(calls, 1);
    expect(c.profile.name, 'Isah');
    c.dispose();
  });

  test('profile equality is by value', () {
    expect(
      SkinProfile.defaults.copyWith(name: 'A'),
      SkinProfile.defaults.copyWith(name: 'A'),
    );
  });

  group('RitualController', () {
    test('a moonlight person opens on the evening ritual', () {
      final RitualController c = RitualController(
        const LocalProductRepository(),
        SkinProfile.defaults.copyWith(moment: RitualMoment.moonlight),
      );
      expect(c.mood, RitualMood.night);
      c.dispose();
    });

    test('ticking steps and flipping the mood', () {
      final RitualController c = RitualController(
        const LocalProductRepository(),
        SkinProfile.defaults,
      );
      expect(c.mood, RitualMood.day);
      final StepKind k = c.plan.steps.first.kind;
      c.toggleDone(k);
      expect(c.isDone(k), isTrue);
      expect(c.doneCount, 1);
      expect(c.progress, greaterThan(0));
      c.toggleDone(k);
      expect(c.doneCount, 0);
      c.toggleDone(k);
      c.toggleMood();
      expect(c.mood, RitualMood.night);
      expect(c.doneCount, 0);
      c.dispose();
    });
  });
}
