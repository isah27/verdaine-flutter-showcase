import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';

/// "Ingredients" poured so far, listed beside the bottle, newest on top.
class PouredList extends StatelessWidget {
  const PouredList({required this.items, required this.colors, super.key});

  final List<String> items;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const AppText('YOUR FORMULA', variant: AppTextVariant.overline),
        const SizedBox(height: AppSpacing.xs),
        for (int i = items.length - 1; i >= 0; i--)
          TweenAnimationBuilder<double>(
            key: ValueKey<String>('poured-$i'),
            tween: Tween<double>(begin: 0, end: 1),
            duration: AppDurations.medium,
            builder: (BuildContext context, double t, Widget? child) => Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, (1 - t) * -12),
                child: child,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: i < colors.length ? colors[i] : AppColors.hairline,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.ink.withValues(alpha: .2),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: AppText(
                      items[i],
                      variant: AppTextVariant.label,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (items.isEmpty)
          const AppText(
            'Every answer pours a layer.',
            variant: AppTextVariant.caption,
          ),
      ],
    );
  }
}
