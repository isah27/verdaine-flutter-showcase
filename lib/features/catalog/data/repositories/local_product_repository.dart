import 'dart:ui' show Color;

import '../../../../core/theme/app_colors.dart';
import '../../../profile/domain/entities/skin_concern.dart';
import '../../../profile/domain/entities/skin_type.dart';
import '../../domain/entities/bottle_shape.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/step_kind.dart';
import '../../domain/repositories/product_repository.dart';

/// In-memory catalogue. Every name here is invented for the challenge.
class LocalProductRepository implements ProductRepository {
  const LocalProductRepository();

  static const Set<SkinType> _rich = <SkinType>{
    SkinType.dry,
    SkinType.sensitive,
    SkinType.normal,
  };
  static const Set<SkinType> _light = <SkinType>{
    SkinType.oily,
    SkinType.combination,
  };

  static const List<Product> _products = <Product>[
    Product(
      id: 'cloud-milk',
      name: 'Cloud Milk Cleanser',
      kind: StepKind.cleanse,
      note: 'Massage onto dry skin for 60 s, rinse warm.',
      liquid: Color(0xFFF3ECE4),
      bottle: BottleShape.pump,
      forTypes: _rich,
    ),
    Product(
      id: 'willow-gel',
      name: 'Willow Gel Cleanser',
      kind: StepKind.cleanse,
      note: 'Lather in wet hands, focus on the T-zone.',
      liquid: AppColors.oilyTint,
      bottle: BottleShape.pump,
      forTypes: _light,
    ),
    Product(
      id: 'petal-mist',
      name: 'Petal Mist Toner',
      kind: StepKind.tone,
      note: 'Three mists, then press in with palms.',
      liquid: AppColors.sensitiveTint,
      bottle: BottleShape.mist,
    ),
    Product(
      id: 'soft-polish',
      name: 'Soft Polish Exfoliant',
      kind: StepKind.exfoliate,
      note: 'Twice a week, light circles, never scrub.',
      liquid: Color(0xFFE6D6C3),
      bottle: BottleShape.jar,
      forTypes: <SkinType>{
        SkinType.oily,
        SkinType.combination,
        SkinType.normal,
        SkinType.dry,
      },
    ),
    Product(
      id: 'dew-vitamin',
      name: 'Dew Vitamin Serum',
      kind: StepKind.serum,
      note: 'Four drops, pat from the centre out.',
      liquid: AppColors.honey,
      bottle: BottleShape.dropper,
      concern: SkinConcern.glow,
    ),
    Product(
      id: 'cloud-water',
      name: 'Cloud Water Serum',
      kind: StepKind.serum,
      note: 'On damp skin, to hold the water in.',
      liquid: AppColors.normalTint,
      bottle: BottleShape.dropper,
      concern: SkinConcern.hydration,
    ),
    Product(
      id: 'oat-calm',
      name: 'Oat Calm Serum',
      kind: StepKind.serum,
      note: 'Press over flushed areas, no rubbing.',
      liquid: AppColors.sensitiveTint,
      bottle: BottleShape.dropper,
      concern: SkinConcern.calm,
    ),
    Product(
      id: 'peptide-silk',
      name: 'Peptide Silk Serum',
      kind: StepKind.serum,
      note: 'Smooth upward along the lines.',
      liquid: AppColors.clay,
      bottle: BottleShape.dropper,
      concern: SkinConcern.fineLines,
    ),
    Product(
      id: 'clear-willow',
      name: 'Clear Willow Serum',
      kind: StepKind.serum,
      note: 'Dab on spots and the T-zone only.',
      liquid: AppColors.sage,
      bottle: BottleShape.dropper,
      concern: SkinConcern.breakouts,
    ),
    Product(
      id: 'rise-eye',
      name: 'Rise Eye Balm',
      kind: StepKind.eye,
      note: 'Ring finger, tap along the bone.',
      liquid: Color(0xFFEAD9C8),
      bottle: BottleShape.tube,
    ),
    Product(
      id: 'night-bloom',
      name: 'Night Bloom Oil',
      kind: StepKind.oil,
      note: 'Two drops warmed in palms, press to seal.',
      liquid: Color(0xFFD99A4E),
      bottle: BottleShape.dropper,
      forTypes: <SkinType>{SkinType.dry, SkinType.normal, SkinType.sensitive},
    ),
    Product(
      id: 'velvet-barrier',
      name: 'Velvet Barrier Cream',
      kind: StepKind.moisturise,
      note: 'A pea-sized amount, warm it first.',
      liquid: Color(0xFFF1E3D6),
      bottle: BottleShape.jar,
      forTypes: _rich,
    ),
    Product(
      id: 'air-gel',
      name: 'Air Gel Moisturiser',
      kind: StepKind.moisturise,
      note: 'Sheer layer, sinks in within a minute.',
      liquid: Color(0xFFDCE8DA),
      bottle: BottleShape.jar,
      forTypes: _light,
    ),
    Product(
      id: 'day-veil',
      name: 'Sheer Day Veil SPF 50',
      kind: StepKind.spf,
      note: 'Two finger-lengths, last step every morning.',
      liquid: Color(0xFFF6E7D2),
      bottle: BottleShape.tube,
    ),
  ];

  @override
  List<Product> all() => _products;
}
