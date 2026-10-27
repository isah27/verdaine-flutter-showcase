import 'package:flutter/foundation.dart';

import '../../domain/entities/skin_profile.dart';

/// App-wide holder of the onboarding answers (Provider + ChangeNotifier).
class ProfileController extends ChangeNotifier {
  ProfileController([SkinProfile initial = SkinProfile.defaults])
    : _profile = initial;

  SkinProfile _profile;
  SkinProfile get profile => _profile;

  /// Saves answers; equal answers do not notify, so nothing rebuilds.
  void save(SkinProfile next) {
    if (next == _profile) return;
    _profile = next;
    notifyListeners();
  }

  void useDefaults() => save(SkinProfile.defaults);
}
