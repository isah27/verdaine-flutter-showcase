import 'package:flutter/widgets.dart';

import '../../../../core/demo/demo_tour.dart';
import '../../../lab/presentation/controllers/lab_controller.dart';
import '../../../lab/presentation/widgets/blend_slab.dart';
import '../../../ritual/domain/entities/ritual_step.dart';
import '../../../ritual/presentation/controllers/ritual_controller.dart';

/// Hands-free tour of home for the screen recording only.
class HomeDemo {
  const HomeDemo({
    required this.ritual,
    required this.lab,
    required this.slab,
    required this.ritualScroll,
    required this.labScroll,
    required this.select,
  });

  final RitualController ritual;
  final LabController lab;
  final GlobalKey<BlendSlabState> slab;
  final ScrollController ritualScroll;
  final ScrollController labScroll;
  final ValueChanged<int> select;

  Future<void> _scroll(ScrollController c, double to, int ms) async {
    if (!c.hasClients) return;
    await c.animateTo(
      to,
      duration: Duration(milliseconds: ms),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> run() async {
    await DemoTour.wait(2600);
    await _scroll(ritualScroll, 300, 1200);
    for (final RitualStep step in ritual.plan.steps.take(3).toList()) {
      ritual.toggleDone(step.kind);
      await DemoTour.wait(650);
    }
    await DemoTour.wait(500);
    await _scroll(ritualScroll, 0, 900);
    await DemoTour.wait(500);
    ritual.toggleMood();
    await DemoTour.wait(2200);
    await _scroll(ritualScroll, 260, 1100);
    await DemoTour.wait(1200);
    await _scroll(ritualScroll, 0, 800);
    ritual.toggleMood();
    await DemoTour.wait(1400);
    select(1);
    await DemoTour.wait(1400);
    await _scroll(labScroll, 150, 900);
    await DemoTour.wait(500);
    final BlendSlabState? s = slab.currentState;
    if (s != null) {
      final Offset c = Offset(s.size.width * .44, s.size.height * .5);
      await s.swirlAround(c, loops: 3, ms: 4200);
    }
    await DemoTour.wait(900);
    await _scroll(labScroll, 420, 900);
    await DemoTour.wait(400);
    lab.scan();
    await DemoTour.wait(1000);
    await _scroll(labScroll, labScroll.position.maxScrollExtent, 900);
  }
}
