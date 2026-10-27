import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Fraunces (soft serif) for display, Manrope for body and labels.
/// Both are variable fonts, so weights are set with `wght` variations.
abstract final class AppTypography {
  static const String serif = 'Fraunces';
  static const String sans = 'Manrope';

  static const List<FontVariation> _w400 = <FontVariation>[
    FontVariation('wght', 400),
  ];
  static const List<FontVariation> _w500 = <FontVariation>[
    FontVariation('wght', 500),
  ];
  static const List<FontVariation> _w700 = <FontVariation>[
    FontVariation('wght', 700),
  ];
  static const List<FontVariation> _serifSoft = <FontVariation>[
    FontVariation('wght', 380),
    FontVariation('SOFT', 100),
    FontVariation('opsz', 72),
  ];

  static const TextStyle display = TextStyle(
    fontFamily: serif,
    fontVariations: _serifSoft,
    fontSize: 46,
    height: 1.02,
    letterSpacing: -1.0,
    color: AppColors.ink,
  );
  static const TextStyle title = TextStyle(
    fontFamily: serif,
    fontVariations: _serifSoft,
    fontSize: 28,
    height: 1.1,
    letterSpacing: -0.4,
    color: AppColors.ink,
  );
  static const TextStyle italic = TextStyle(
    fontFamily: serif,
    fontStyle: FontStyle.italic,
    fontVariations: _serifSoft,
    fontSize: 21,
    height: 1.2,
    color: AppColors.ink,
  );
  static const TextStyle body = TextStyle(
    fontFamily: sans,
    fontVariations: _w400,
    fontSize: 14.5,
    height: 1.45,
    color: AppColors.ink,
  );
  static const TextStyle label = TextStyle(
    fontFamily: sans,
    fontVariations: _w700,
    fontSize: 14,
    letterSpacing: 0.2,
    color: AppColors.ink,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: sans,
    fontVariations: _w500,
    fontSize: 12.5,
    height: 1.4,
    color: AppColors.smoke,
  );
  static const TextStyle overline = TextStyle(
    fontFamily: sans,
    fontVariations: _w700,
    fontSize: 10.5,
    letterSpacing: 2.4,
    color: AppColors.smoke,
  );
  static const TextStyle wordmark = TextStyle(
    fontFamily: serif,
    fontVariations: _serifSoft,
    fontSize: 19,
    letterSpacing: 7,
    color: AppColors.ink,
  );
}
