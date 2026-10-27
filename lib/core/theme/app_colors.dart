import 'package:flutter/widgets.dart';

/// VERDAINE palette. Every colour in the app comes from here.
abstract final class AppColors {
  // Day (morning) surfaces.
  static const Color milk = Color(0xFFF7F2EC);
  static const Color petal = Color(0xFFEFE2D8);
  static const Color hairline = Color(0xFFDDCFC4);
  static const Color ink = Color(0xFF2A2026);
  static const Color smoke = Color(0xFF7A6C70);

  // Accents.
  static const Color clay = Color(0xFFC27B66);
  static const Color clayDeep = Color(0xFF9E5A47);
  static const Color sage = Color(0xFF7F927A);
  static const Color honey = Color(0xFFE0A955);

  // Night (evening) surfaces.
  static const Color plum = Color(0xFF241B2B);
  static const Color plumRaised = Color(0xFF342839);
  static const Color moonMilk = Color(0xFFEDE4F0);
  static const Color dusk = Color(0xFFA897B0);

  // Skin-type tints (used by the bottle layers and the texture lab).
  static const Color dryTint = Color(0xFFE8C9A0);
  static const Color oilyTint = Color(0xFFA9C2A0);
  static const Color comboTint = Color(0xFFE9B8A4);
  static const Color sensitiveTint = Color(0xFFEBC3C6);
  static const Color normalTint = Color(0xFFD9CFE6);

  // Skin swatch for the glow scan.
  static const Color skinLight = Color(0xFFE7BFA2);
  static const Color skinDeep = Color(0xFFB9846A);

  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
}
