import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../profile/domain/entities/skin_type.dart';

class SkinSwatch extends StatelessWidget {
  const SkinSwatch({
    super.key,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final SkinType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.ink : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.card,
        side: BorderSide(color: selected ? AppColors.ink : AppColors.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey<String>('skin-${type.name}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 10,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: AppRadii.pill,
                  gradient: LinearGradient(
                    colors: <Color>[type.tint, AppColors.white, type.tint],
                    stops: const <double>[0, .45, 1],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppText(
                type.label,
                variant: AppTextVariant.label,
                color: selected ? AppColors.milk : AppColors.ink,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: AppText(
                  type.hint,
                  variant: AppTextVariant.caption,
                  align: TextAlign.right,
                  maxLines: 1,
                  color: selected ? AppColors.hairline : AppColors.smoke,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
