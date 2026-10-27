import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import 'app_text.dart';

/// Always-visible Skip pill used on onboarding and the reveal.
class SkipButton extends StatelessWidget {
  const SkipButton({required this.onPressed, this.dark = false, super.key});

  final VoidCallback onPressed;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final Color ink = dark ? AppColors.moonMilk : AppColors.ink;
    return Semantics(
      button: true,
      label: 'Skip to your ritual',
      child: Material(
        color: ink.withValues(alpha: .08),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.pill),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const ValueKey<String>('skip'),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppText(
                  AppStrings.skip,
                  variant: AppTextVariant.label,
                  color: ink,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Icon(Icons.east_rounded, size: 16, color: ink),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
