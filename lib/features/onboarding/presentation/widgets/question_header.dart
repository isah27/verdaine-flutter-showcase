import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/onboarding_question.dart';

class QuestionHeader extends StatelessWidget {
  const QuestionHeader({required this.question, super.key});

  final OnboardingQuestion question;

  @override
  Widget build(BuildContext context) {
    final String n = (question.index + 1).toString().padLeft(2, '0');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppText(
          'LAYER $n OF 05',
          variant: AppTextVariant.overline,
          color: AppColors.clayDeep,
        ),
        const SizedBox(height: AppSpacing.xs),
        AppText(question.title, variant: AppTextVariant.title),
        const SizedBox(height: AppSpacing.xxs),
        AppText(question.hint, variant: AppTextVariant.caption),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
