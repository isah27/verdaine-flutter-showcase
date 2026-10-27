import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/blend_result.dart';
import '../controllers/lab_controller.dart';
import '../widgets/blend_readout.dart';
import '../widgets/blend_slab.dart';
import '../widgets/glow_scan.dart';
import '../widgets/lab_drop_legend.dart';

/// Signature screen: swirl your serum and cream together on a stone slab.
class LabPage extends StatelessWidget {
  const LabPage({this.slabKey, this.scroll, super.key});

  final GlobalKey<BlendSlabState>? slabKey;
  final ScrollController? scroll;

  @override
  Widget build(BuildContext context) {
    final LabController lab = context.read<LabController>();
    return ColoredBox(
      color: AppColors.milk,
      child: SafeArea(
        bottom: false,
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            120,
          ),
          children: <Widget>[
            const AppText(
              'TEXTURE LAB',
              variant: AppTextVariant.overline,
              color: AppColors.clayDeep,
            ),
            const SizedBox(height: AppSpacing.xxs),
            const AppText(
              'Blend your own texture',
              variant: AppTextVariant.title,
            ),
            const SizedBox(height: AppSpacing.xxs),
            const AppText(
              'Swirl the two drops together. Stay on the serum side for a lighter blend.',
              variant: AppTextVariant.caption,
            ),
            const SizedBox(height: AppSpacing.md),
            LabDropLegend(serum: lab.serum, cream: lab.cream),
            const SizedBox(height: AppSpacing.sm),
            BlendSlab(key: slabKey),
            const SizedBox(height: AppSpacing.md),
            const BlendReadout(),
            const SizedBox(height: AppSpacing.md),
            Selector<LabController, (BlendResult, bool)>(
              selector: (_, LabController c) => (c.result, c.scanned),
              builder: (BuildContext context, (BlendResult, bool) s, _) {
                final (BlendResult r, bool scanned) = s;
                return AnimatedSwitcher(
                  duration: AppDurations.medium,
                  child: scanned
                      ? Column(
                          key: const ValueKey<String>('scanned'),
                          children: <Widget>[
                            GlowScan(glow: r.glow, texture: r.texture),
                            const SizedBox(height: AppSpacing.sm),
                            AppButton(
                              label: 'Start a new blend',
                              variant: AppButtonVariant.ghost,
                              onPressed: lab.reset,
                            ),
                          ],
                        )
                      : AppButton(
                          key: const ValueKey<String>('scan'),
                          label: r.mixed
                              ? 'Scan my glow'
                              : 'Swirl to blend first',
                          icon: Icons.auto_awesome_rounded,
                          onPressed: r.mixed ? lab.scan : null,
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
