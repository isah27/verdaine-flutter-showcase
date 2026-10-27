import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../profile/domain/entities/ritual_moment.dart';

/// Three little skies to pick from.
class MomentPicker extends StatelessWidget {
  const MomentPicker({required this.selected, required this.onPick, super.key});

  final RitualMoment? selected;
  final ValueChanged<RitualMoment> onPick;

  static List<Color> _sky(RitualMoment m) => switch (m) {
    RitualMoment.sunrise => const <Color>[AppColors.honey, AppColors.petal],
    RitualMoment.moonlight => const <Color>[AppColors.plum, AppColors.dusk],
    RitualMoment.both => const <Color>[AppColors.honey, AppColors.plum],
  };

  static IconData _icon(RitualMoment m) => switch (m) {
    RitualMoment.sunrise => Icons.wb_sunny_rounded,
    RitualMoment.moonlight => Icons.nightlight_round,
    RitualMoment.both => Icons.brightness_6_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final RitualMoment m in RitualMoment.values) ...<Widget>[
          if (m.index > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: GestureDetector(
              key: ValueKey<String>('moment-${m.name}'),
              onTap: () => onPick(m),
              child: AnimatedScale(
                scale: m == selected ? 1.04 : 1,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    borderRadius: AppRadii.card,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _sky(m),
                    ),
                    border: Border.all(
                      color: m == selected
                          ? AppColors.ink
                          : AppColors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(_icon(m), color: AppColors.white, size: 30),
                      const Spacer(),
                      AppText(
                        m.label,
                        variant: AppTextVariant.label,
                        color: AppColors.white,
                      ),
                      AppText(
                        m.hint,
                        variant: AppTextVariant.caption,
                        color: AppColors.white,
                        size: 11,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
