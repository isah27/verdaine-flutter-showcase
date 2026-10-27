import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verdaine/app.dart';

Future<void> _pumpApp(WidgetTester t) async {
  t.view.physicalSize = const Size(412 * 3, 915 * 3);
  t.view.devicePixelRatio = 3;
  addTearDown(t.view.reset);
  await t.pumpWidget(const VerdaineApp());
  await _settle(t);
}

/// The onboarding bottle ripples forever, so pump a fixed time instead of
/// waiting for every animation to settle.
Future<void> _settle(WidgetTester t, [int ms = 1500]) async {
  for (int i = 0; i < ms ~/ 100; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

String _text(WidgetTester t, String key) => (t.widget<Text>(
  find.descendant(
    of: find.byKey(ValueKey<String>(key)),
    matching: find.byType(Text),
  ),
)).data!;

void main() {
  testWidgets('Skip goes straight to a default home', (WidgetTester t) async {
    await _pumpApp(t);
    await t.tap(find.byKey(const ValueKey<String>('skip')));
    await _settle(t);
    expect(_text(t, 'greeting'), 'Good morning.');
    expect(_text(t, 'tailored'), contains('starter'));
    expect(find.byKey(const ValueKey<String>('dock-1')), findsOneWidget);
  });

  testWidgets('answers personalise the reveal and the home', (
    WidgetTester t,
  ) async {
    await _pumpApp(t);
    await t.enterText(find.byKey(const ValueKey<String>('name-field')), 'Isah');
    await t.tap(find.byKey(const ValueKey<String>('name-next')));
    await _settle(t);
    await t.tap(find.byKey(const ValueKey<String>('skin-combination')));
    await _settle(t);
    await t.tap(find.byKey(const ValueKey<String>('concern-glow')));
    await t.tap(find.byKey(const ValueKey<String>('concern-hydration')));
    await t.pump();
    await t.ensureVisible(find.byKey(const ValueKey<String>('concerns-next')));
    await t.tap(find.byKey(const ValueKey<String>('concerns-next')));
    await _settle(t);
    await t.tap(find.byKey(const ValueKey<String>('moment-moonlight')));
    await _settle(t);
    await t.ensureVisible(find.byKey(const ValueKey<String>('formulate')));
    await t.tap(find.byKey(const ValueKey<String>('formulate')));
    await t.pump();
    await t.pump(const Duration(milliseconds: 400));
    await t.pump(const Duration(seconds: 2));
    expect(_text(t, 'reveal-title'), 'Isah, your ritual is ready.');
    await _settle(t, 4000);
    // Moonlight people open on the evening ritual.
    expect(_text(t, 'greeting'), 'Good evening, Isah.');
    expect(
      _text(t, 'tailored'),
      'For combination skin, focused on glow + hydration.',
    );
  });

  testWidgets('home: tick a step, flip the mood, open the lab', (
    WidgetTester t,
  ) async {
    await _pumpApp(t);
    await t.tap(find.byKey(const ValueKey<String>('skip')));
    await _settle(t);
    await t.tap(find.byKey(const ValueKey<String>('step-cleanse')));
    await _settle(t);
    expect(_text(t, 'progress-text'), startsWith('1'));
    await t.tap(find.byKey(const ValueKey<String>('mood-toggle')));
    await _settle(t);
    expect(_text(t, 'greeting'), 'Good evening.');
    await t.tap(find.byKey(const ValueKey<String>('dock-1')));
    await _settle(t);
    expect(find.text('Blend your own texture'), findsOneWidget);
    expect(find.text('Swirl to blend first'), findsOneWidget);
    // Swirl hard on the slab until it is fully mixed.
    final Offset c = t.getCenter(find.byKey(const ValueKey<String>('slab')));
    for (int i = 0; i < 4; i++) {
      final TestGesture g = await t.startGesture(c + const Offset(-120, -80));
      for (int k = 0; k < 12; k++) {
        await g.moveBy(Offset(k.isEven ? 220 : -220, 15));
      }
      await g.up();
      await t.pump();
    }
    await t.pump(const Duration(milliseconds: 400));
    expect(find.text('Scan my glow'), findsOneWidget);
    await t.ensureVisible(find.text('Scan my glow'));
    await t.tap(find.text('Scan my glow'));
    await t.pump(const Duration(seconds: 3));
    expect(find.byKey(const ValueKey<String>('glow-score')), findsOneWidget);
  });
}
