import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../domain/entities/ritual_mood.dart';

/// Sun/moon switch that flips the whole home between morning and evening.
class MoodToggle extends StatelessWidget {
  const MoodToggle({required this.mood, required this.onToggle, super.key});

  final RitualMood mood;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final bool night = mood == RitualMood.night;
    return Semantics(
      button: true,
      label: night ? 'Switch to morning ritual' : 'Switch to evening ritual',
      child: GestureDetector(
        key: const ValueKey<String>('mood-toggle'),
        onTap: onToggle,
        child: AnimatedContainer(
          duration: AppDurations.mood,
          curve: Curves.easeInOutCubic,
          width: 76,
          height: 38,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: AppRadii.pill,
            color: night
                ? AppColors.plumRaised
                : AppColors.white.withValues(alpha: .7),
            border: Border.all(
              color: night
                  ? AppColors.dusk.withValues(alpha: .4)
                  : AppColors.hairline,
            ),
          ),
          child: AnimatedAlign(
            duration: AppDurations.mood,
            curve: Curves.easeInOutBack,
            alignment: night ? Alignment.centerRight : Alignment.centerLeft,
            child: AnimatedContainer(
              duration: AppDurations.mood,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: night ? AppColors.moonMilk : AppColors.honey,
              ),
              child: Icon(
                night ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                size: 17,
                color: night ? AppColors.plum : AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
