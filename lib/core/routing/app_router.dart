import 'package:flutter/material.dart';

import '../../features/home/presentation/pages/home_shell.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/reveal/presentation/pages/reveal_page.dart';
import '../theme/app_durations.dart';
import 'app_routes.dart';

/// Named routes with a soft fade between them.
abstract final class AppRouter {
  static Route<void> onGenerate(RouteSettings s) {
    final Widget page = switch (s.name) {
      AppRoutes.reveal => const RevealPage(),
      AppRoutes.home => const HomeShell(),
      _ => const OnboardingPage(),
    };
    return PageRouteBuilder<void>(
      settings: s,
      transitionDuration: AppDurations.medium,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, Animation<double> a, _, Widget child) =>
          FadeTransition(opacity: a, child: child),
    );
  }
}
