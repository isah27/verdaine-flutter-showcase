import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../catalog/domain/entities/bottle_shape.dart';
import '../../../catalog/presentation/widgets/bottle_painter.dart';
import 'bottle_label.dart';

/// The big dropper bottle that fills one layer per answer.
///
/// The fill level tweens on each answer; the surface wave is a repeating
/// controller passed to the painter as `repaint`, and it stops once full.
class PourBottle extends StatefulWidget {
  const PourBottle({
    required this.layers,
    required this.total,
    required this.name,
    super.key,
  });

  final List<Color> layers;
  final int total;
  final String name;

  @override
  State<PourBottle> createState() => _PourBottleState();
}

class _PourBottleState extends State<PourBottle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: AppDurations.wave,
  )..repeat();

  @override
  void didUpdateWidget(PourBottle old) {
    super.didUpdateWidget(old);
    if (widget.layers.length >= widget.total) {
      _wave.stop();
    } else if (!_wave.isAnimating) {
      _wave.repeat();
    }
  }

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double target = widget.layers.length / widget.total * .92;
    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: .62,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: target),
                duration: AppDurations.pour,
                curve: Curves.easeOutBack,
                builder: (BuildContext context, double level, Widget? _) {
                  return CustomPaint(
                    painter: BottlePainter(
                      shape: BottleShape.dropper,
                      layers: widget.layers,
                      level: level,
                      wave: _wave,
                      capColor: AppColors.ink,
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: const Alignment(0, .5),
              child: AnimatedSwitcher(
                duration: AppDurations.medium,
                child: widget.name.isEmpty
                    ? const SizedBox.shrink()
                    : BottleLabel(
                        key: ValueKey<String>(widget.name),
                        name: widget.name,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
