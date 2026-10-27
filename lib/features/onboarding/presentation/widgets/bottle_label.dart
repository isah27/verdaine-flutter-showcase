import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

/// The paper label that appears once the name is poured in.
class BottleLabel extends StatelessWidget {
  const BottleLabel({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.milk.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.ink.withValues(alpha: .15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const AppText('VERDAINE', variant: AppTextVariant.overline, size: 8),
          const SizedBox(height: 4),
          AppText(
            'for $name',
            variant: AppTextVariant.italic,
            size: 17,
            maxLines: 1,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
