import 'dart:ui' show Color;

import '../../../../core/theme/app_colors.dart';

enum SkinType {
  dry('Dry', 'Feels tight by noon', AppColors.dryTint),
  oily('Oily', 'Shiny by lunchtime', AppColors.oilyTint),
  combination('Combination', 'Oily T-zone, dry cheeks', AppColors.comboTint),
  sensitive('Sensitive', 'Reacts, flushes easily', AppColors.sensitiveTint),
  normal('Balanced', 'Mostly calm and even', AppColors.normalTint);

  const SkinType(this.label, this.hint, this.tint);

  final String label;
  final String hint;
  final Color tint;
}
