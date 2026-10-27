import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/utils/display_image.dart';
import '../../../ritual/presentation/widgets/sky_images.dart';
import '../controllers/lab_controller.dart';
import 'blend_painter.dart';
import 'swirl_canvas.dart';

/// The stone slab you swirl on. Drag adds points to [SwirlCanvas] (repaint
/// only); the controller hears one commit per stroke.
class BlendSlab extends StatefulWidget {
  const BlendSlab({super.key});

  @override
  State<BlendSlab> createState() => BlendSlabState();
}

class BlendSlabState extends State<BlendSlab>
    with SingleTickerProviderStateMixin {
  final SwirlCanvas _swirl = SwirlCanvas();
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  Size _size = Size.zero;
  int _seenReset = 0;

  @override
  void dispose() {
    _swirl.dispose();
    _shimmer.dispose();
    super.dispose();
  }

  void _commit() {
    _swirl.lift();
    final LabController lab = context.read<LabController>();
    lab.commit(ratio: _swirl.ratio(_size.width), progress: _swirl.progress);
    if (lab.result.mixed && !_shimmer.isAnimating) _shimmer.repeat();
  }

  /// Demo/test helper: swirls a figure-eight around [centre].
  Future<void> swirlAround(
    Offset centre, {
    int loops = 3,
    int ms = 2400,
  }) async {
    final int steps = loops * 48;
    final int dt = ms ~/ steps;
    for (int i = 0; i <= steps; i++) {
      if (!mounted) return;
      final double a = i / 48 * math.pi * 2;
      _swirl.add(
        centre +
            Offset(
              math.sin(a) * _size.width * .3,
              math.sin(a * 2) * _size.height * .22,
            ),
      );
      await Future<void>.delayed(Duration(milliseconds: dt));
      if (i % 48 == 47) _commit();
    }
    _commit();
  }

  Size get size => _size;

  @override
  Widget build(BuildContext context) {
    final LabController lab = context.read<LabController>();
    final int reset = context.select<LabController, int>(
      (LabController c) => c.resetCount,
    );
    if (reset != _seenReset) {
      _seenReset = reset;
      _swirl.clear();
      _shimmer.stop();
    }
    return AspectRatio(
      aspectRatio: 1.05,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints box) {
          _size = box.biggest;
          return ClipRRect(
            borderRadius: AppRadii.sheet,
            child: RepaintBoundary(
              child: GestureDetector(
                key: const ValueKey<String>('slab'),
                onPanStart: (DragStartDetails d) => _swirl.add(d.localPosition),
                onPanUpdate: (DragUpdateDetails d) =>
                    _swirl.add(d.localPosition),
                onPanEnd: (_) => _commit(),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image(
                      image: DisplayImage.asset(
                        context,
                        SkyImages.slab,
                        width: box.maxWidth,
                      ),
                      fit: BoxFit.cover,
                      color: AppColors.white.withValues(alpha: .08),
                      colorBlendMode: BlendMode.lighten,
                    ),
                    CustomPaint(
                      painter: BlendPainter(
                        swirl: _swirl,
                        serum: lab.serum.liquid,
                        cream: lab.cream.liquid,
                        shimmer: _shimmer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
