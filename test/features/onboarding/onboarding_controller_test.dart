import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:verdaine/features/onboarding/domain/entities/onboarding_question.dart';
import 'package:verdaine/features/onboarding/domain/services/formula_layers.dart';
import 'package:verdaine/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:verdaine/features/profile/domain/entities/ritual_moment.dart';
import 'package:verdaine/features/profile/domain/entities/skin_concern.dart';
import 'package:verdaine/features/profile/domain/entities/skin_profile.dart';
import 'package:verdaine/features/profile/domain/entities/skin_type.dart';

void main() {
  group('OnboardingController personalisation', () {
    test('answers become the profile, one layer per answer', () {
      final OnboardingController c = OnboardingController();
      expect(c.layers, isEmpty);
      c.submitName('  Isah  ');
      expect(c.name, 'Isah');
      expect(c.layers.length, 1);
      c.pickSkinType(SkinType.combination);
      c.toggleConcern(SkinConcern.glow);
      c.toggleConcern(SkinConcern.hydration);
      c.confirmConcerns();
      c.pickMoment(RitualMoment.sunrise);
      c.setMinutes(99);
      expect(c.minutes, SkinProfile.maxMinutes);
      c.setMinutes(7);
      c.confirmMinutes();
      expect(c.done, isTrue);
      expect(c.layers.length, OnboardingQuestion.values.length);
      final SkinProfile p = c.toProfile();
      expect(p.name, 'Isah');
      expect(p.skinType, SkinType.combination);
      expect(p.concerns, <SkinConcern>{
        SkinConcern.glow,
        SkinConcern.hydration,
      });
      expect(p.leadConcern, SkinConcern.glow);
      expect(p.moment, RitualMoment.sunrise);
      expect(p.minutes, 7);
      expect(p.skipped, isFalse);
      c.dispose();
    });

    test('empty name does not advance; answers out of order are ignored', () {
      final OnboardingController c = OnboardingController();
      c.submitName('   ');
      expect(c.question, OnboardingQuestion.name);
      c.pickSkinType(SkinType.dry);
      expect(c.skinType, isNull);
      c.dispose();
    });

    test('at most three concerns', () {
      final OnboardingController c = OnboardingController()
        ..submitName('A')
        ..pickSkinType(SkinType.oily);
      for (final SkinConcern s in SkinConcern.values) {
        c.toggleConcern(s);
      }
      expect(c.concerns.length, OnboardingController.maxConcerns);
      c.dispose();
    });

    test('unanswered questions fall back to defaults', () {
      final OnboardingController c = OnboardingController()..submitName('Bo');
      c.setMinutes(99);
      final SkinProfile p = c.toProfile();
      expect(p.name, 'Bo');
      expect(p.skinType, SkinProfile.defaults.skinType);
      expect(p.concerns, SkinProfile.defaults.concerns);
      expect(p.minutes, lessThanOrEqualTo(SkinProfile.maxMinutes));
      c.dispose();
    });

    test('reveal bottle layers reflect skin type and lead concern', () {
      const SkinProfile p = SkinProfile(
        name: 'Isah',
        skinType: SkinType.oily,
        concerns: <SkinConcern>{SkinConcern.breakouts},
        moment: RitualMoment.moonlight,
        minutes: 6,
      );
      final List<Color> layers = FormulaLayers.of(p);
      expect(layers.length, 5);
      expect(layers[1], SkinType.oily.tint);
      expect(layers[2], SkinConcern.breakouts.color);
    });
  });
}
