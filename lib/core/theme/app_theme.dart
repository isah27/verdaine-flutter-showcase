import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.milk,
    fontFamily: AppTypography.sans,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.clay,
      surface: AppColors.milk,
      primary: AppColors.ink,
    ),
    splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.clay,
      inactiveTrackColor: AppColors.hairline,
      thumbColor: AppColors.ink,
      overlayColor: Color(0x22C27B66),
      trackHeight: 6,
    ),
  );
}
