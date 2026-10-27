enum RitualMood {
  day('Morning'),
  night('Evening');

  const RitualMood(this.label);

  final String label;

  RitualMood get flipped => this == day ? night : day;
}
