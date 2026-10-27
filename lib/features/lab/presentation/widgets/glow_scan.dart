import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import 'glow_painter.dart';

/// Runs the glow scan once and counts the score up with the scan line.
class GlowScan extends StatefulWidget {
  const GlowScan({required this.glow, required this.texture, super.key});

  final int glow;
  final String texture;

  @override
  State<GlowScan> createState() => _GlowScanState();
}

class _GlowScanState extends State<GlowScan>
    with SingleTickerProviderStateMixin {
  late final AnimationController _t = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..forward();

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.card,
      child: SizedBox(
        height: 170,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            RepaintBoundary(
              child: CustomPaint(
                painter: GlowPainter(t: _t, glow: widget.glow.toDouble()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const AppText(
                    'GLOW SCAN · DEMO',
                    variant: AppTextVariant.overline,
                    color: AppColors.white,
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _t,
                    builder: (BuildContext context, _) => AppText(
                      'Glow ${(widget.glow * _t.value).round()}',
                      key: const ValueKey<String>('glow-score'),
                      variant: AppTextVariant.display,
                      color: AppColors.white,
                      size: 44,
                    ),
                  ),
                  AppText(
                    'Dewy finish from your ${widget.texture.toLowerCase()}',
                    variant: AppTextVariant.caption,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
