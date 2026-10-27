import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/widgets/app_text.dart';
import '../controllers/ritual_controller.dart';
import 'progress_ring_painter.dart';

/// "2/5" ring. Selects only the counts it shows.
class ProgressRing extends StatelessWidget {
  const ProgressRing({required this.night, super.key});

  final bool night;

  @override
  Widget build(BuildContext context) {
    final (int done, int total) = context.select<RitualController, (int, int)>(
      (RitualController c) => (c.doneCount, c.plan.steps.length),
    );
    final Color ink = night ? AppColors.moonMilk : AppColors.ink;
    return SizedBox.square(
      dimension: 62,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: total == 0 ? 0 : done / total),
        duration: AppDurations.medium,
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double v, Widget? child) => CustomPaint(
          painter: ProgressRingPainter(
            value: v,
            track: ink.withValues(alpha: .14),
            fill: night ? AppColors.honey : AppColors.clay,
          ),
          child: child,
        ),
        child: Center(
          child: AppText(
            '$done/$total',
            key: const ValueKey<String>('progress-text'),
            variant: AppTextVariant.label,
            color: ink,
          ),
        ),
      ),
    );
  }
}
