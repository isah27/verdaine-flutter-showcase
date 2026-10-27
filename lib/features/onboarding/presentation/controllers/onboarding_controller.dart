import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../profile/domain/entities/ritual_moment.dart';
import '../../../profile/domain/entities/skin_concern.dart';
import '../../../profile/domain/entities/skin_profile.dart';
import '../../../profile/domain/entities/skin_type.dart';
import '../../domain/entities/onboarding_question.dart';

/// Page-scoped state for the "fill your bottle" quiz.
///
/// Every action checks it belongs to the current question, so a late tap
/// can never answer the wrong one.
class OnboardingController extends ChangeNotifier {
  static const int maxConcerns = 3;

  OnboardingQuestion _question = OnboardingQuestion.name;
  String _name = '';
  SkinType? _skinType;
  final Set<SkinConcern> _concerns = <SkinConcern>{};
  RitualMoment? _moment;
  int _minutes = SkinProfile.defaults.minutes;
  bool _done = false;

  OnboardingQuestion get question => _question;
  String get name => _name;
  SkinType? get skinType => _skinType;
  Set<SkinConcern> get concerns => Set<SkinConcern>.unmodifiable(_concerns);
  RitualMoment? get moment => _moment;
  int get minutes => _minutes;
  bool get done => _done;
  int get answered =>
      _done ? OnboardingQuestion.values.length : _question.index;

  /// Bottle layers, one per answered question, bottom first.
  List<Color> get layers => <Color>[
    if (answered > 0) AppColors.petal,
    if (answered > 1 && _skinType != null) _skinType!.tint,
    if (answered > 2)
      _concerns.isEmpty
          ? AppColors.normalTint
          : (SkinConcern.values.firstWhere(_concerns.contains)).color,
    if (answered > 3 && _moment != null)
      switch (_moment!) {
        RitualMoment.sunrise => AppColors.honey,
        RitualMoment.moonlight => AppColors.dusk,
        RitualMoment.both => AppColors.clay,
      },
    if (answered > 4) AppColors.milk,
  ];

  void submitName(String raw) {
    if (_question != OnboardingQuestion.name) return;
    final String n = raw.trim();
    if (n.isEmpty) return;
    _name = n.length > 18 ? n.substring(0, 18) : n;
    _advance();
  }

  void pickSkinType(SkinType t) {
    if (_question != OnboardingQuestion.skinType) return;
    _skinType = t;
    _advance();
  }

  void toggleConcern(SkinConcern c) {
    if (_question != OnboardingQuestion.concerns) return;
    if (!_concerns.remove(c)) {
      if (_concerns.length >= maxConcerns) return;
      _concerns.add(c);
    }
    notifyListeners();
  }

  void confirmConcerns() {
    if (_question != OnboardingQuestion.concerns || _concerns.isEmpty) return;
    _advance();
  }

  void pickMoment(RitualMoment m) {
    if (_question != OnboardingQuestion.moment) return;
    _moment = m;
    _advance();
  }

  void setMinutes(int m) {
    if (_question != OnboardingQuestion.minutes) return;
    final int v = m.clamp(SkinProfile.minMinutes, SkinProfile.maxMinutes);
    if (v == _minutes) return;
    _minutes = v;
    notifyListeners();
  }

  void confirmMinutes() {
    if (_question != OnboardingQuestion.minutes || _done) return;
    _done = true;
    notifyListeners();
  }

  /// The answers as a profile; anything unanswered falls back to defaults.
  SkinProfile toProfile() {
    const SkinProfile d = SkinProfile.defaults;
    return SkinProfile(
      name: _name.isEmpty ? d.name : _name,
      skinType: _skinType ?? d.skinType,
      concerns: _concerns.isEmpty ? d.concerns : Set<SkinConcern>.of(_concerns),
      moment: _moment ?? d.moment,
      minutes: _minutes,
    );
  }

  void _advance() {
    _question = OnboardingQuestion.values[_question.index + 1];
    notifyListeners();
  }
}
