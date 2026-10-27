import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/blend_result.dart';
import '../controllers/lab_controller.dart';

/// Live formula card. Rebuilds only when a committed result changes.
class BlendReadout extends StatelessWidget {
  const BlendReadout({super.key});

  @override
  Widget build(BuildContext context) {
    final (BlendResult r, double mix) = context
        .select<LabController, (BlendResult, double)>(
          (LabController c) => (c.result, c.mix),
        );
    final LabController lab = context.read<LabController>();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.card,
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              AppText(
                r.mixed ? 'BLENDED' : 'KEEP SWIRLING',
                variant: AppTextVariant.overline,
                color: r.mixed ? AppColors.sage : AppColors.clayDeep,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedSwitcher(
                    duration: AppDurations.quick,
                    child: AppText(
                      r.texture,
                      key: ValueKey<String>(r.texture),
                      variant: AppTextVariant.italic,
                      size: 20,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.pill,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: mix),
              duration: AppDurations.medium,
              builder: (BuildContext context, double v, _) =>
                  LinearProgressIndicator(
                    value: v,
                    minHeight: 6,
                    backgroundColor: AppColors.petal,
                    color: AppColors.clay,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            '${r.serumShare}% ${lab.serum.name}',
            key: const ValueKey<String>('serum-share'),
            variant: AppTextVariant.label,
          ),
          AppText(
            '${r.creamShare}% ${lab.cream.name}',
            variant: AppTextVariant.caption,
          ),
        ],
      ),
    );
  }
}
