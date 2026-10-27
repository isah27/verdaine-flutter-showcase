import '../entities/blend_result.dart';

/// Pure maths for the Texture Lab.
///
/// [ratio] is the serum's share (0..1), taken from where you swirl:
/// swirling on the serum side makes the blend lighter.
/// [progress] (0..1) is how far the two drops have been worked together.
abstract final class BlendFormula {
  /// Swirl distance, in logical pixels, that fully mixes the drops.
  static const double fullMixDistance = 2600;

  static double progressFor(double distance) =>
      (distance / fullMixDistance).clamp(0.0, 1.0);

  /// Average x of the strokes (0 = serum side) to the serum share.
  static double ratioFor(double meanX, double width) {
    if (width <= 0) return .5;
    return (1 - meanX / width).clamp(.15, .85);
  }

  static String textureFor(double ratio) {
    if (ratio >= .72) return 'Water gel';
    if (ratio >= .56) return 'Silk serum';
    if (ratio >= .44) return 'Milky lotion';
    if (ratio >= .28) return 'Soft cream';
    return 'Rich balm';
  }

  static BlendResult mix(double ratio, double progress) {
    final double r = ratio.clamp(0.0, 1.0);
    final double p = progress.clamp(0.0, 1.0);
    final double balance = 1 - (2 * r - 1).abs();
    final int glow = (100 * p * (.7 + .3 * balance)).round();
    return BlendResult(
      serumShare: (r * 100).round(),
      texture: textureFor(r),
      glow: glow,
      mixed: p >= 1,
    );
  }
}
