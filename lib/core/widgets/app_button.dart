import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_durations.dart';
import '../theme/app_radii.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import 'app_text.dart';

enum AppButtonVariant { primary, ghost, chip }

/// Shared button: ink primary, hairline ghost, and a selectable chip
/// that can carry a small colour swatch.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.expanded = true,
    this.selected = false,
    this.swatch,
    this.icon,
    this.dark = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool expanded;
  final bool selected;
  final Color? swatch;
  final IconData? icon;

  /// Night surfaces flip the ink and paper colours.
  final bool dark;

  Color get _paper => dark ? AppColors.plum : AppColors.milk;
  Color get _ink => dark ? AppColors.moonMilk : AppColors.ink;

  Color get _fill => switch (variant) {
    AppButtonVariant.primary => _ink,
    AppButtonVariant.chip => selected ? _ink : _paper,
    AppButtonVariant.ghost => AppColors.transparent,
  };

  Color get _label => switch (variant) {
    AppButtonVariant.primary => _paper,
    AppButtonVariant.chip => selected ? _paper : _ink,
    AppButtonVariant.ghost => _ink,
  };

  @override
  Widget build(BuildContext context) {
    final bool chip = variant == AppButtonVariant.chip;
    return Semantics(
      button: true,
      selected: selected,
      child: AnimatedContainer(
        duration: AppDurations.quick,
        height: chip ? AppSizes.chipHeight : AppSizes.buttonHeight,
        width: expanded ? double.infinity : null,
        decoration: BoxDecoration(
          color: _fill,
          borderRadius: AppRadii.pill,
          border: variant == AppButtonVariant.primary
              ? null
              : Border.all(color: selected ? _ink : AppColors.hairline),
        ),
        child: Material(
          type: MaterialType.transparency,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.pill),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: chip ? AppSpacing.md : AppSpacing.lg,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (swatch != null) ...<Widget>[
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: swatch,
                        shape: BoxShape.circle,
                        border: Border.all(color: _label.withValues(alpha: .4)),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  if (icon != null) ...<Widget>[
                    Icon(icon, size: 18, color: _label),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Flexible(
                    child: AppText(
                      label,
                      variant: AppTextVariant.label,
                      color: _label,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
