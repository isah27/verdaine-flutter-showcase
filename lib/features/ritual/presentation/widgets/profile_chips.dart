import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../profile/domain/entities/skin_profile.dart';

/// Small read-only tags that echo the onboarding answers.
class ProfileChips extends StatelessWidget {
  const ProfileChips({required this.profile, required this.night, super.key});

  final SkinProfile profile;
  final bool night;

  @override
  Widget build(BuildContext context) {
    final List<String> tags = <String>[
      profile.skinType.label,
      profile.leadConcern.label,
      '${profile.minutes} min',
    ];
    final Color ink = night ? AppColors.moonMilk : AppColors.ink;
    return Wrap(
      spacing: AppSpacing.xxs + 2,
      runSpacing: AppSpacing.xxs,
      children: <Widget>[
        for (final String t in tags)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: AppRadii.pill,
              color: ink.withValues(alpha: .08),
              border: Border.all(color: ink.withValues(alpha: .18)),
            ),
            child: AppText(t, variant: AppTextVariant.caption, color: ink),
          ),
      ],
    );
  }
}
