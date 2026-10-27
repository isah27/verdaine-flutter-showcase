/// Compile-time switch for the hands-free recording tour.
/// Enable with `--dart-define=DEMO_TOUR=true`; off in normal builds.
abstract final class DemoTour {
  static const bool enabled = bool.fromEnvironment('DEMO_TOUR');

  static Future<void> wait(int ms) =>
      Future<void>.delayed(Duration(milliseconds: ms));
}
