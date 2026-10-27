/// When the user most wants their ritual. Sets the home's opening mood.
enum RitualMoment {
  sunrise('Sunrise', 'A fresh, bright start'),
  moonlight('Moonlight', 'A slow wind-down'),
  both('Both', 'Morning and night');

  const RitualMoment(this.label, this.hint);

  final String label;
  final String hint;

  bool get opensAtNight => this == RitualMoment.moonlight;
}
