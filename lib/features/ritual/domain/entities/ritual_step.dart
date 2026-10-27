import 'package:flutter/foundation.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/domain/entities/step_kind.dart';

@immutable
class RitualStep {
  const RitualStep(this.product);

  final Product product;

  StepKind get kind => product.kind;
  int get minutes => kind.minutes;
}
