import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/demo/demo_tour.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/display_image.dart';
import '../../../../core/widgets/brand_wordmark.dart';
import '../../../../core/widgets/skip_button.dart';
import '../../../profile/domain/entities/skin_concern.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../../ritual/presentation/widgets/sky_images.dart';
import '../../domain/entities/onboarding_question.dart';
import '../controllers/onboarding_controller.dart';
import '../demo/onboarding_demo.dart';
import '../widgets/bottle_stage.dart';
import '../widgets/concern_chips.dart';
import '../widgets/minutes_dial.dart';
import '../widgets/moment_picker.dart';
import '../widgets/name_step.dart';
import '../widgets/question_header.dart';
import '../widgets/skin_type_picker.dart';

/// "Fill your bottle": five quick questions, each pouring a layer.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final OnboardingController _quiz = OnboardingController();
  final TextEditingController _name = TextEditingController();
  bool _left = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Warm the home screen's sky images while the user answers.
    unawaited(
      DisplayImage.precache(
        context,
        SkyImages.all,
        width: AppSizes.maxContentWidth,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (DemoTour.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(OnboardingDemo.run(_quiz, _name, _finish));
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _quiz.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_left || !mounted) return;
    _left = true;
    context.read<ProfileController>().save(_quiz.toProfile());
    await Navigator.of(context).pushReplacementNamed(AppRoutes.reveal);
  }

  Future<void> _skip() async {
    if (_left) return;
    _left = true;
    context.read<ProfileController>().useDefaults();
    await Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingController>.value(
      value: _quiz,
      child: Scaffold(
        backgroundColor: AppColors.milk,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: Row(
                  children: <Widget>[
                    const BrandWordmark(),
                    const Spacer(),
                    SkipButton(onPressed: () => unawaited(_skip())),
                  ],
                ),
              ),
              const BottleStage(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Selector<OnboardingController, OnboardingQuestion>(
                    selector: (_, OnboardingController c) => c.question,
                    builder: (BuildContext context, OnboardingQuestion q, _) {
                      return AnimatedSwitcher(
                        duration: AppDurations.medium,
                        transitionBuilder:
                            (Widget child, Animation<double> a) =>
                                FadeTransition(
                                  opacity: a,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, .06),
                                      end: Offset.zero,
                                    ).animate(a),
                                    child: child,
                                  ),
                                ),
                        child: Column(
                          key: ValueKey<OnboardingQuestion>(q),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            QuestionHeader(question: q),
                            _answerFor(q),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _answerFor(OnboardingQuestion q) {
    final OnboardingController c = _quiz;
    return switch (q) {
      OnboardingQuestion.name => NameStep(
        controller: _name,
        onSubmit: c.submitName,
      ),
      OnboardingQuestion.skinType => Selector<OnboardingController, Object?>(
        selector: (_, OnboardingController c) => c.skinType,
        builder: (_, _, _) =>
            SkinTypePicker(selected: c.skinType, onPick: c.pickSkinType),
      ),
      OnboardingQuestion.concerns =>
        Selector<OnboardingController, Set<SkinConcern>>(
          selector: (_, OnboardingController c) => c.concerns,
          builder: (_, Set<SkinConcern> s, _) => ConcernChips(
            selected: s,
            onToggle: c.toggleConcern,
            onConfirm: c.confirmConcerns,
          ),
        ),
      OnboardingQuestion.moment => Selector<OnboardingController, Object?>(
        selector: (_, OnboardingController c) => c.moment,
        builder: (_, _, _) =>
            MomentPicker(selected: c.moment, onPick: c.pickMoment),
      ),
      OnboardingQuestion.minutes => Selector<OnboardingController, int>(
        selector: (_, OnboardingController c) => c.minutes,
        builder: (_, int m, _) => MinutesDial(
          minutes: m,
          onChanged: c.setMinutes,
          onConfirm: () {
            c.confirmMinutes();
            unawaited(_finish());
          },
        ),
      ),
    };
  }
}
