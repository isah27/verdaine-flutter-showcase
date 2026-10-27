import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_strings.dart';
import 'ritual_moment.dart';
import 'skin_concern.dart';
import 'skin_type.dart';

/// The answers from onboarding. Immutable; equality is by value.
@immutable
class SkinProfile {
  const SkinProfile({
    required this.name,
    required this.skinType,
    required this.concerns,
    required this.moment,
    required this.minutes,
    this.skipped = false,
  });

  /// Sensible defaults used when the user taps Skip.
  static const SkinProfile defaults = SkinProfile(
    name: AppStrings.guest,
    skinType: SkinType.normal,
    concerns: <SkinConcern>{SkinConcern.hydration},
    moment: RitualMoment.both,
    minutes: 8,
    skipped: true,
  );

  static const int minMinutes = 3;
  static const int maxMinutes = 15;

  final String name;
  final SkinType skinType;
  final Set<SkinConcern> concerns;
  final RitualMoment moment;
  final int minutes;
  final bool skipped;

  /// The concern that leads the routine (enum order is the tie-break).
  SkinConcern get leadConcern {
    for (final SkinConcern c in SkinConcern.values) {
      if (concerns.contains(c)) return c;
    }
    return SkinConcern.hydration;
  }

  SkinProfile copyWith({
    String? name,
    SkinType? skinType,
    Set<SkinConcern>? concerns,
    RitualMoment? moment,
    int? minutes,
    bool? skipped,
  }) {
    return SkinProfile(
      name: name ?? this.name,
      skinType: skinType ?? this.skinType,
      concerns: concerns ?? this.concerns,
      moment: moment ?? this.moment,
      minutes: minutes ?? this.minutes,
      skipped: skipped ?? this.skipped,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SkinProfile &&
      other.name == name &&
      other.skinType == skinType &&
      setEquals(other.concerns, concerns) &&
      other.moment == moment &&
      other.minutes == minutes &&
      other.skipped == skipped;

  @override
  int get hashCode => Object.hash(
    name,
    skinType,
    Object.hashAllUnordered(concerns),
    moment,
    minutes,
    skipped,
  );
}
