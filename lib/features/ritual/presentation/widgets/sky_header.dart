import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/display_image.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/brand_wordmark.dart';
import '../../../profile/domain/entities/skin_profile.dart';
import '../../domain/entities/ritual_mood.dart';
import '../../domain/services/ritual_planner.dart';
import '../controllers/ritual_controller.dart';
import 'mood_toggle.dart';
import 'profile_chips.dart';
import 'progress_ring.dart';
import 'sky_images.dart';
import 'sky_painter.dart';

/// The greeting sky. One controller crossfades the photos and moves the
/// painted sun and moon when the mood flips.
class SkyHeader extends StatefulWidget {
  const SkyHeader({required this.mood, super.key});

  final RitualMood mood;

  @override
  State<SkyHeader> createState() => _SkyHeaderState();
}

class _SkyHeaderState extends State<SkyHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController(
    vsync: this,
    duration: AppDurations.mood,
    value: widget.mood == RitualMood.night ? 1 : 0,
  );

  @override
  void didUpdateWidget(SkyHeader old) {
    super.didUpdateWidget(old);
    if (old.mood != widget.mood) {
      _t.animateTo(widget.mood == RitualMood.night ? 1 : 0);
    }
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RitualController c = context.read<RitualController>();
    final SkinProfile p = c.profile;
    final bool night = widget.mood == RitualMood.night;
    final Color ink = night ? AppColors.moonMilk : AppColors.ink;
    final double w = MediaQuery.sizeOf(context).width;
    return SizedBox(
      height: 360,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          RepaintBoundary(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image(
                  image: DisplayImage.asset(
                    context,
                    SkyImages.morning,
                    width: w,
                  ),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
                FadeTransition(
                  opacity: _t,
                  child: Image(
                    image: DisplayImage.asset(
                      context,
                      SkyImages.night,
                      width: w,
                    ),
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                ),
                CustomPaint(painter: SkyPainter(_t)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    BrandWordmark(color: ink),
                    const Spacer(),
                    MoodToggle(mood: widget.mood, onToggle: c.toggleMood),
                  ],
                ),
                const Spacer(),
                AppText(
                  '${widget.mood.label.toUpperCase()} RITUAL',
                  variant: AppTextVariant.overline,
                  color: night ? AppColors.honey : AppColors.clayDeep,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  RitualPlanner.greeting(p, widget.mood),
                  key: const ValueKey<String>('greeting'),
                  variant: AppTextVariant.display,
                  color: ink,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AppText(
                            RitualPlanner.tailoredLine(p),
                            key: const ValueKey<String>('tailored'),
                            variant: AppTextVariant.body,
                            color: ink.withValues(alpha: .8),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ProfileChips(profile: p, night: night),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ProgressRing(night: night),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
