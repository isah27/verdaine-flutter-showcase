import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../profile/domain/entities/skin_profile.dart';

class MinutesDial extends StatelessWidget {
  const MinutesDial({
    required this.minutes,
    required this.onChanged,
    required this.onConfirm,
    super.key,
  });

  final int minutes;
  final ValueChanged<int> onChanged;
  final VoidCallback onConfirm;

  String get _feel => minutes <= 5
      ? 'Quick and essential'
      : minutes <= 9
      ? 'A calm, complete ritual'
      : 'The full slow ritual';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            AppText('$minutes', variant: AppTextVariant.display, size: 64),
            const SizedBox(width: AppSpacing.xs),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: AppText('min', variant: AppTextVariant.italic),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AppText(
                  _feel,
                  variant: AppTextVariant.caption,
                  align: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
        Slider(
          key: const ValueKey<String>('minutes-slider'),
          value: minutes.toDouble(),
          min: SkinProfile.minMinutes.toDouble(),
          max: SkinProfile.maxMinutes.toDouble(),
          divisions: SkinProfile.maxMinutes - SkinProfile.minMinutes,
          onChanged: (double v) => onChanged(v.round()),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          key: const ValueKey<String>('formulate'),
          label: 'Formulate my ritual',
          onPressed: onConfirm,
        ),
      ],
    );
  }
}
