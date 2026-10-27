import 'package:flutter/widgets.dart';

import '../../../../core/demo/demo_tour.dart';
import '../../../profile/domain/entities/ritual_moment.dart';
import '../../../profile/domain/entities/skin_concern.dart';
import '../../../profile/domain/entities/skin_type.dart';
import '../controllers/onboarding_controller.dart';

/// Hands-free run of the quiz for the screen recording only.
abstract final class OnboardingDemo {
  static Future<void> run(
    OnboardingController c,
    TextEditingController name,
    Future<void> Function() finish,
  ) async {
    await DemoTour.wait(1600);
    for (final String ch in 'Isah'.split('')) {
      name.text = '${name.text}$ch';
      await DemoTour.wait(170);
    }
    await DemoTour.wait(600);
    c.submitName(name.text);
    await DemoTour.wait(1900);
    c.pickSkinType(SkinType.combination);
    await DemoTour.wait(1500);
    c.toggleConcern(SkinConcern.glow);
    await DemoTour.wait(450);
    c.toggleConcern(SkinConcern.hydration);
    await DemoTour.wait(800);
    c.confirmConcerns();
    await DemoTour.wait(1700);
    c.pickMoment(RitualMoment.sunrise);
    await DemoTour.wait(1300);
    for (final int m in <int>[9, 10, 9, 8, 7]) {
      c.setMinutes(m);
      await DemoTour.wait(260);
    }
    await DemoTour.wait(800);
    c.confirmMinutes();
    await finish();
  }
}
