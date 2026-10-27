import 'package:flutter/widgets.dart';

/// Decodes asset images at the size they are shown, not their full size.
abstract final class DisplayImage {
  static ImageProvider<Object> asset(
    BuildContext context,
    String path, {
    required double width,
  }) {
    final double dpr = MediaQuery.devicePixelRatioOf(context);
    return ResizeImage(
      AssetImage(path),
      width: (width * dpr).round(),
      policy: ResizeImagePolicy.fit,
    );
  }

  static Future<void> precache(
    BuildContext context,
    Iterable<String> paths, {
    required double width,
  }) {
    return Future.wait(
      paths.map(
        (String p) => precacheImage(asset(context, p, width: width), context),
      ),
    );
  }
}
