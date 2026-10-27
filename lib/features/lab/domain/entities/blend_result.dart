import 'package:flutter/foundation.dart';

@immutable
class BlendResult {
  const BlendResult({
    required this.serumShare,
    required this.texture,
    required this.glow,
    required this.mixed,
  });

  /// 0..100, the serum's share of the blend.
  final int serumShare;
  final String texture;

  /// 0..100 glow score shown after the scan.
  final int glow;

  /// True once the two drops are fully worked together.
  final bool mixed;

  int get creamShare => 100 - serumShare;

  @override
  bool operator ==(Object other) =>
      other is BlendResult &&
      other.serumShare == serumShare &&
      other.texture == texture &&
      other.glow == glow &&
      other.mixed == mixed;

  @override
  int get hashCode => Object.hash(serumShare, texture, glow, mixed);
}
