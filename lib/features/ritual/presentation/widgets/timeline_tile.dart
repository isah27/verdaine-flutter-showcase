import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../catalog/presentation/widgets/product_bottle.dart';
import '../../domain/entities/ritual_step.dart';
import '../controllers/ritual_controller.dart';
import 'rail_painter.dart';

/// One step on the ritual timeline. Tap to tick it off; only this tile
/// rebuilds, because it selects just its own done flag.
class TimelineTile extends StatelessWidget {
  const TimelineTile({
    required this.step,
    required this.index,
    required this.count,
    required this.startMinute,
    required this.night,
    super.key,
  });

  final RitualStep step;
  final int index;
  final int count;
  final int startMinute;
  final bool night;

  @override
  Widget build(BuildContext context) {
    final bool done = context.select<RitualController, bool>(
      (RitualController c) => c.isDone(step.kind),
    );
    final Color ink = night ? AppColors.moonMilk : AppColors.ink;
    final Color card = night ? AppColors.plumRaised : AppColors.white;
    final String n = (index + 1).toString().padLeft(2, '0');
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: AppSizes.timelineRail,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: done ? 1 : 0),
              duration: AppDurations.medium,
              curve: Curves.easeOutBack,
              builder: (BuildContext context, double v, _) => CustomPaint(
                painter: RailPainter(
                  first: index == 0,
                  last: index == count - 1,
                  done: v.clamp(0.0, 1.0),
                  line: ink.withValues(alpha: .16),
                  fill: night ? AppColors.honey : AppColors.clay,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Material(
                color: card,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.card,
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  key: ValueKey<String>('step-${step.kind.name}'),
                  onTap: () =>
                      context.read<RitualController>().toggleDone(step.kind),
                  child: AnimatedOpacity(
                    duration: AppDurations.quick,
                    opacity: done ? .55 : 1,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Row(
                        children: <Widget>[
                          ProductBottle(product: step.product, size: 58),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AppText(
                                  '$n · ${step.kind.label.toUpperCase()} · MIN $startMinute',
                                  variant: AppTextVariant.overline,
                                  color: night
                                      ? AppColors.honey
                                      : AppColors.clayDeep,
                                ),
                                const SizedBox(height: 2),
                                AppText(
                                  step.product.name,
                                  variant: AppTextVariant.italic,
                                  color: ink,
                                  size: 19,
                                ),
                                AppText(
                                  step.product.note,
                                  variant: AppTextVariant.caption,
                                  color: night
                                      ? AppColors.dusk
                                      : AppColors.smoke,
                                ),
                              ],
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: AppDurations.quick,
                            child: Icon(
                              done
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                              key: ValueKey<bool>(done),
                              color: done
                                  ? (night ? AppColors.honey : AppColors.clay)
                                  : ink.withValues(alpha: .3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
