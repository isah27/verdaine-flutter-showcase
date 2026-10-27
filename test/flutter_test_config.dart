import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

/// Loads the real brand fonts so widget tests lay out text like the app
/// does (the default test font is much wider).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  Future<void> load(String family, List<String> files) async {
    final FontLoader loader = FontLoader(family);
    for (final String f in files) {
      final Uint8List bytes = File('assets/fonts/$f').readAsBytesSync();
      loader.addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  await load('Fraunces', <String>['Fraunces.ttf', 'Fraunces-Italic.ttf']);
  await load('Manrope', <String>['Manrope.ttf']);
  await testMain();
}
