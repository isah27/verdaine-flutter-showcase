import 'package:flutter/widgets.dart';

abstract final class AppRadii {
  static const Radius soft = Radius.circular(18);
  static const BorderRadius card = BorderRadius.all(soft);
  static const BorderRadius sheet = BorderRadius.all(Radius.circular(28));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}
