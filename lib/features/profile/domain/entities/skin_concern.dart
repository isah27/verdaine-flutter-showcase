import 'dart:ui' show Color;

import '../../../../core/theme/app_colors.dart';

/// Order matters: it is the tie-break when several concerns are picked.
enum SkinConcern {
  glow('Glow', AppColors.honey),
  hydration('Hydration', AppColors.normalTint),
  calm('Calm redness', AppColors.sensitiveTint),
  fineLines('Fine lines', AppColors.clay),
  breakouts('Breakouts', AppColors.sage);

  const SkinConcern(this.label, this.color);

  final String label;
  final Color color;
}
