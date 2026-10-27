import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/product_bottle.dart';

/// Names the two drops on the slab: serum on the left, cream on the right.
class LabDropLegend extends StatelessWidget {
  const LabDropLegend({required this.serum, required this.cream, super.key});

  final Product serum;
  final Product cream;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ProductBottle(product: serum, size: 40),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: AppText(
            serum.name,
            variant: AppTextVariant.label,
            maxLines: 2,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppText(
            cream.name,
            variant: AppTextVariant.label,
            align: TextAlign.right,
            maxLines: 2,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        ProductBottle(product: cream, size: 40),
      ],
    );
  }
}
