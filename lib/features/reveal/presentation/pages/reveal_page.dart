import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/skip_button.dart';
import '../../../onboarding/domain/services/formula_layers.dart';
import '../../../onboarding/presentation/widgets/pour_bottle.dart';
import '../../../profile/domain/entities/skin_profile.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../../ritual/domain/services/ritual_planner.dart';

/// The bottle turns to show its label, then the ritual opens by itself.
class RevealPage extends StatefulWidget {
  const RevealPage({super.key});

  @override
  State<RevealPage> createState() => _RevealPageState();
}

class _RevealPageState extends State<RevealPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController(
    vsync: this,
    duration: AppDurations.reveal,
  );
  bool _left = false;

  @override
  void initState() {
    super.initState();
    unawaited(_t.forward().whenComplete(_go));
  }

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  void _go() {
    if (_left || !mounted) return;
    _left = true;
    unawaited(Navigator.of(context).pushReplacementNamed(AppRoutes.home));
  }

  @override
  Widget build(BuildContext context) {
    final SkinProfile p = context.select<ProfileController, SkinProfile>(
      (ProfileController c) => c.profile,
    );
    final Animation<double> turn = CurvedAnimation(
      parent: _t,
      curve: const Interval(0, .45, curve: Curves.easeInOutCubic),
    );
    final Animation<double> words = CurvedAnimation(
      parent: _t,
      curve: const Interval(.35, .6, curve: Curves.easeOut),
    );
    return Scaffold(
      backgroundColor: AppColors.petal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: SkipButton(onPressed: _go),
              ),
              const Spacer(),
              SizedBox(
                height: 330,
                child: AnimatedBuilder(
                  animation: turn,
                  builder: (BuildContext context, Widget? child) => Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, .0012)
                      ..rotateY((1 - turn.value) * math.pi * 1.5)
                      ..scaleByDouble(
                        .85 + .15 * turn.value,
                        .85 + .15 * turn.value,
                        1,
                        1,
                      ),
                    child: child,
                  ),
                  child: PourBottle(
                    layers: FormulaLayers.of(p),
                    total: 5,
                    name: p.name,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FadeTransition(
                opacity: words,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, .2),
                    end: Offset.zero,
                  ).animate(words),
                  child: Column(
                    children: <Widget>[
                      const AppText(
                        'FORMULATED FOR YOU',
                        variant: AppTextVariant.overline,
                        color: AppColors.clayDeep,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        p.skipped
                            ? 'Your ritual is ready.'
                            : '${p.name}, your ritual is ready.',
                        key: const ValueKey<String>('reveal-title'),
                        variant: AppTextVariant.display,
                        align: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        RitualPlanner.tailoredLine(p),
                        variant: AppTextVariant.body,
                        align: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              AppButton(
                key: const ValueKey<String>('open-ritual'),
                label: 'Open my ritual',
                icon: Icons.arrow_forward_rounded,
                onPressed: _go,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
