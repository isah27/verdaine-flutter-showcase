import 'dart:ui';

import '../../../../core/theme/app_colors.dart';
import '../../../profile/domain/entities/ritual_moment.dart';
import '../../../profile/domain/entities/skin_profile.dart';

/// Turns a finished profile into the five bottle layers, bottom first.
/// Same colours the quiz poured, so the reveal bottle matches.
abstract final class FormulaLayers {
  static List<Color> of(SkinProfile p) => <Color>[
    AppColors.petal,
    p.skinType.tint,
    p.leadConcern.color,
    switch (p.moment) {
      RitualMoment.sunrise => AppColors.honey,
      RitualMoment.moonlight => AppColors.dusk,
      RitualMoment.both => AppColors.clay,
    },
    AppColors.milk,
  ];
}
