import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

import '../../../profile/domain/entities/skin_concern.dart';
import '../../../profile/domain/entities/skin_type.dart';
import 'bottle_shape.dart';
import 'step_kind.dart';

/// A fictional VERDAINE product. Bottles are painted, so no image assets.
@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.kind,
    required this.note,
    required this.liquid,
    required this.bottle,
    this.forTypes = const <SkinType>{},
    this.concern,
  });

  final String id;
  final String name;
  final StepKind kind;
  final String note;
  final Color liquid;
  final BottleShape bottle;

  /// Empty means suitable for every skin type.
  final Set<SkinType> forTypes;
  final SkinConcern? concern;

  bool suits(SkinType type) => forTypes.isEmpty || forTypes.contains(type);
}
