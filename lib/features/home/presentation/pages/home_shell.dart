import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/demo/demo_tour.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../catalog/domain/repositories/product_repository.dart';
import '../../../lab/presentation/controllers/lab_controller.dart';
import '../../../lab/presentation/pages/lab_page.dart';
import '../../../lab/presentation/widgets/blend_slab.dart';
import '../../../profile/domain/entities/skin_profile.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../../ritual/domain/entities/ritual_mood.dart';
import '../../../ritual/presentation/controllers/ritual_controller.dart';
import '../../../ritual/presentation/pages/ritual_page.dart';
import '../demo/home_demo.dart';
import '../widgets/dew_dock.dart';

/// Home: Ritual and Texture Lab in an IndexedStack. The hidden tab is
/// wrapped in TickerMode(false), so its animations pause off-screen.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final SkinProfile _profile = context.read<ProfileController>().profile;
  late final ProductRepository _repo = context.read<ProductRepository>();
  late final RitualController _ritual = RitualController(_repo, _profile);
  late final LabController _lab = LabController(_repo, _profile);
  final GlobalKey<BlendSlabState> _slab = GlobalKey<BlendSlabState>();
  final ScrollController _ritualScroll = ScrollController();
  final ScrollController _labScroll = ScrollController();
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    if (DemoTour.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(
          HomeDemo(
            ritual: _ritual,
            lab: _lab,
            slab: _slab,
            ritualScroll: _ritualScroll,
            labScroll: _labScroll,
            select: _select,
          ).run(),
        );
      });
    }
  }

  @override
  void dispose() {
    _ritual.dispose();
    _lab.dispose();
    _ritualScroll.dispose();
    _labScroll.dispose();
    super.dispose();
  }

  void _select(int i) {
    if (i == _tab || !mounted) return;
    setState(() => _tab = i);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<RitualController>.value(value: _ritual),
        ChangeNotifierProvider<LabController>.value(value: _lab),
      ],
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            IndexedStack(
              index: _tab,
              children: <Widget>[
                TickerMode(
                  enabled: _tab == 0,
                  child: RitualPage(scroll: _ritualScroll),
                ),
                TickerMode(
                  enabled: _tab == 1,
                  child: LabPage(slabKey: _slab, scroll: _labScroll),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.lg,
              child: Center(
                child: Selector<RitualController, bool>(
                  selector: (_, RitualController c) =>
                      c.mood == RitualMood.night,
                  builder: (_, bool night, _) => DewDock(
                    index: _tab,
                    night: night && _tab == 0,
                    onSelect: _select,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
