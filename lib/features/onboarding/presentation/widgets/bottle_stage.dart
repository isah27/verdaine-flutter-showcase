import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../profile/domain/entities/skin_concern.dart';
import '../../domain/entities/onboarding_question.dart';
import '../controllers/onboarding_controller.dart';
import 'pour_bottle.dart';
import 'poured_list.dart';

/// Bottle + poured list. Rebuilds only when the answered count changes.
class BottleStage extends StatelessWidget {
  const BottleStage({super.key});

  @override
  Widget build(BuildContext context) {
    final int answered = context.select<OnboardingController, int>(
      (OnboardingController c) => c.answered,
    );
    final OnboardingController c = context.read<OnboardingController>();
    final List<String> items = <String>[
      if (answered > 0) c.name,
      if (answered > 1 && c.skinType != null) '${c.skinType!.label} skin',
      if (answered > 2)
        (c.concerns.toList()..sort(
              (SkinConcern a, SkinConcern b) => a.index.compareTo(b.index),
            ))
            .map((SkinConcern x) => x.label)
            .join(' + '),
      if (answered > 3 && c.moment != null) c.moment!.label,
      if (answered > 4) '${c.minutes} min a day',
    ];
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: <Widget>[
            PourBottle(
              layers: c.layers,
              total: OnboardingQuestion.values.length,
              name: answered > 0 ? c.name : '',
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: PouredList(items: items, colors: c.layers),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
