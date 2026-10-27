import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/ritual_mood.dart';
import '../../domain/entities/ritual_plan.dart';
import '../../domain/entities/ritual_step.dart';
import '../controllers/ritual_controller.dart';
import '../widgets/sky_header.dart';
import '../widgets/timeline_tile.dart';

/// Home: a greeting sky over a vertical ritual timeline.
class RitualPage extends StatelessWidget {
  const RitualPage({this.scroll, super.key});

  final ScrollController? scroll;

  @override
  Widget build(BuildContext context) {
    final RitualPlan plan = context.select<RitualController, RitualPlan>(
      (RitualController c) => c.plan,
    );
    final RitualMood mood = plan.mood;
    final bool night = mood == RitualMood.night;
    final List<int> starts = <int>[];
    int t = 0;
    for (final RitualStep s in plan.steps) {
      starts.add(t);
      t += s.minutes;
    }
    return AnimatedContainer(
      duration: AppDurations.mood,
      color: night ? AppColors.plum : AppColors.milk,
      child: CustomScrollView(
        controller: scroll,
        slivers: <Widget>[
          SliverToBoxAdapter(child: SkyHeader(mood: mood)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.sm,
                  bottom: AppSpacing.md,
                ),
                child: AppText(
                  'Your ${mood.label.toLowerCase()} · ${plan.summary}',
                  key: const ValueKey<String>('plan-summary'),
                  variant: AppTextVariant.title,
                  size: 22,
                  color: night ? AppColors.moonMilk : AppColors.ink,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              right: AppSpacing.md,
            ),
            sliver: SliverList.builder(
              itemCount: plan.steps.length,
              itemBuilder: (BuildContext context, int i) => TimelineTile(
                key: ValueKey<String>(
                  '${mood.name}-${plan.steps[i].kind.name}',
                ),
                step: plan.steps[i],
                index: i,
                count: plan.steps.length,
                startMinute: starts[i],
                night: night,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                120,
              ),
              child: AppText(
                AppStrings.fictionalNote,
                variant: AppTextVariant.caption,
                align: TextAlign.center,
                color: night ? AppColors.dusk : AppColors.smoke,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
