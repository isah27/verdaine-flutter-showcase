import 'package:flutter_test/flutter_test.dart';
import 'package:verdaine/features/catalog/data/repositories/local_product_repository.dart';
import 'package:verdaine/features/catalog/domain/entities/step_kind.dart';
import 'package:verdaine/features/lab/domain/entities/blend_result.dart';
import 'package:verdaine/features/lab/domain/services/blend_formula.dart';
import 'package:verdaine/features/lab/presentation/controllers/lab_controller.dart';
import 'package:verdaine/features/profile/domain/entities/ritual_moment.dart';
import 'package:verdaine/features/profile/domain/entities/skin_concern.dart';
import 'package:verdaine/features/profile/domain/entities/skin_profile.dart';
import 'package:verdaine/features/profile/domain/entities/skin_type.dart';

void main() {
  group('BlendFormula', () {
    test('progress grows with distance and caps at 1', () {
      expect(BlendFormula.progressFor(0), 0);
      expect(BlendFormula.progressFor(1300), closeTo(.5, 1e-9));
      expect(BlendFormula.progressFor(99999), 1);
    });

    test('swirling on the serum side gives a higher serum share', () {
      expect(BlendFormula.ratioFor(50, 400), greaterThan(.5));
      expect(BlendFormula.ratioFor(350, 400), lessThan(.5));
      expect(BlendFormula.ratioFor(0, 400), .85);
      expect(BlendFormula.ratioFor(400, 400), .15);
      expect(BlendFormula.ratioFor(10, 0), .5);
    });

    test('textures follow the ratio', () {
      expect(BlendFormula.textureFor(.8), 'Water gel');
      expect(BlendFormula.textureFor(.6), 'Silk serum');
      expect(BlendFormula.textureFor(.5), 'Milky lotion');
      expect(BlendFormula.textureFor(.3), 'Soft cream');
      expect(BlendFormula.textureFor(.2), 'Rich balm');
    });

    test('a balanced full mix scores the highest glow', () {
      final BlendResult even = BlendFormula.mix(.5, 1);
      final BlendResult lopsided = BlendFormula.mix(.85, 1);
      expect(even.mixed, isTrue);
      expect(even.glow, 100);
      expect(lopsided.glow, lessThan(even.glow));
      expect(BlendFormula.mix(.5, .5).mixed, isFalse);
      expect(even.serumShare + even.creamShare, 100);
    });
  });

  group('LabController', () {
    const SkinProfile dry = SkinProfile(
      name: 'Ada',
      skinType: SkinType.dry,
      concerns: <SkinConcern>{SkinConcern.calm},
      moment: RitualMoment.both,
      minutes: 8,
    );

    test('drops come from the profile', () {
      final LabController c = LabController(
        const LocalProductRepository(),
        dry,
      );
      expect(c.serum.kind, StepKind.serum);
      expect(c.serum.concern, SkinConcern.calm);
      expect(c.cream.kind, StepKind.moisturise);
      expect(c.cream.suits(SkinType.dry), isTrue);
    });

    test('scan only after a full mix; reset clears everything', () {
      final LabController c = LabController(
        const LocalProductRepository(),
        dry,
      );
      c.commit(ratio: .5, progress: .4);
      c.scan();
      expect(c.scanned, isFalse);
      c.commit(ratio: .5, progress: 1);
      c.scan();
      expect(c.scanned, isTrue);
      expect(c.mix, 1);
      c.reset();
      expect(c.scanned, isFalse);
      expect(c.mix, 0);
      expect(c.result.mixed, isFalse);
      expect(c.resetCount, 1);
    });
  });
}
